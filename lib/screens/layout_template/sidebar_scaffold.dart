import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validators/validators.dart';
import 'package:web_iot/themes/jt_theme.dart';
import '../../config/firebase/firebase_config.dart';
import '../../config/permissions_code.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_iot/screens/layout_template/component/notification_content.dart';
import 'package:web_iot/screens/layout_template/languge_dialog.dart';
import 'package:web_iot/widgets/flutter_admin_scaffold/admin_scaffold.dart' as sidebar;
import 'package:web_iot/routes/route_names.dart';
import '../../core/modules/user_management/blocs/account/account_bloc.dart';
import '../../core/modules/user_management/blocs/notification/notification_bloc_public.dart';
import '../../core/modules/user_management/models/account_model.dart';
import '../../core/modules/user_management/resources/notification/notification_repository.dart';
import '../../locator.dart';
import '../../routes/app_router_delegate.dart';

class SidebarScaffold extends StatefulWidget {
  final Widget body;
  final String route;
  final String? subRoute;
  final void Function() onFetch;

  const SidebarScaffold({
    Key? key,
    required this.route,
    required this.body,
    this.subRoute,
    required this.onFetch,
  }) : super(key: key);

  @override
  _SidebarScaffoldState createState() => _SidebarScaffoldState();
}

class _SidebarScaffoldState extends State<SidebarScaffold> {
  late AuthenticationBloc _authenticationBloc;
  final _accountBloc = AccountBloc();
  bool _allowUserManagement = false;
  bool _allowSmartParking = false;
  bool _allowFaceReco = false;
  bool _allowHealthyCheck = false;
  FirebaseMessaging? _messaging;
  PushNotification? _notificationInfo;
  final _notificationBloc = NotificationBloc();

  @override
  void initState() {
    _authenticationBloc = AuthenticationBlocController().authenticationBloc;
    _authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is AuthenticationStart) {
          navigateTo(authenticationRoute);
        } else if (state is UserLogoutState) {
          navigateTo(authenticationRoute);
        } else if (state is AuthenticationFailure) {
          _showError(state.errorCode);
        } else if (state is UserTokenExpired) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ScreenUtil.t(I18nKey.signInSessionExpired)!,
              ),
            ),
          );
          navigateTo(authenticationRoute);
        } else if (state is AppAutheticated) {
          _authenticationBloc.add(GetUserData());
        } else if (state is SetUserData) {
          final currentAccount = await _accountBloc.getProfile();
          isAdmin=currentAccount.isAdmin;
          if (state.currentLang != currentAccount.lang) {
            navigateTo(conflictLangRoute);
          } else {
            _requestPermissionsLocal();
            registerNotification();
            checkForInitialMessage();
            _initLocalPushNotification();
            // For handling notification when the app is in background
            // but not terminated
            FirebaseMessaging.onMessageOpenedApp
                .listen((RemoteMessage message) {
              PushNotification notification = PushNotification(
                title: message.notification?.title,
                body: message.notification?.body,
                dataTitle: message.data['title'].toString(),
                dataBody: message.data['body'].toString(),
              );
              setState(() {
                _notificationInfo = notification;
              });
            });
          }
        }
      },
      child: FutureBuilder(
          future: _accountBloc.getProfile(),
          builder: (
            context,
            AsyncSnapshot<AccountModel> snapshot,
          ) {
            return sidebar.AdminScaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: _buildAppBar(context: context, snapshot: snapshot),
              sideBar: _buildSideBar(context: context, snapshot: snapshot),
              body: Stack(
                children: [
                  SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          if (showNoti) {
                              setState(() {showNoti = false;});  
                          } 
                        },
                        child: widget.body,
                      ),
                    ),
                  if (showNoti)
                    NotificationContent(
                      key: notiKey,
                      notificationBloc: _notificationBloc,
                    ),
                ],
              ),
            );
          }),
    );
  }

  _buildAppBar({
    required BuildContext context,
    required AsyncSnapshot<AccountModel> snapshot,
  }) {
    final List<sidebar.MenuItem> _adminMenuItems = [
      sidebar.MenuItem(
          title: ScreenUtil.t(I18nKey.account)!,
          icon: Icons.person_outline_outlined),
      sidebar.MenuItem(
        title: ScreenUtil.t(I18nKey.language)!,
        svgIcon: SvgIcons.language,
      ),
      sidebar.MenuItem(title: ScreenUtil.t(I18nKey.signOut)!, icon: Icons.logout),
    ];
    return AppBar(
      elevation: 1,
      actions: [
        BlocProvider(
          create: (context) =>
              _notificationBloc..add(const NotificationUnreadTotal()),
          child: BlocListener<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is NotificationUnreadTotalDoneState) {
                if (state.data.model != null) {
                  final unreadTotal = state.data.model!.total;
                  if (showNoti) {
                    if (newNoti != unreadTotal) {
                      if (notiKey.currentState != null) {
                        if (state.notiId.isNotEmpty) {
                          notiKey.currentState!.notificationBloc.add(
                            ReadNotification(
                              params: {
                                "id": state.notiId,
                                "read": true,
                              },
                            ),
                          );
                        } else {
                          notiKey.currentState!.refreshData();
                        }
                      }
                    }
                  }
                  newNoti = unreadTotal;
                }
              }
              if (state is NotificationReadAllDoneState) {
                _notificationBloc.add(const NotificationUnreadTotal());
              }
            },
            child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
              return SizedBox(
                width: 40,
                child: InkWell(
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.notifications_rounded,
                            size: 24,
                          ),
                        ),
                        if (newNoti > 0)
                          Positioned(
                            top: 12,
                            right: 2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColor.error,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  newNoti > 9 ? '+9' : newNoti.toString(),
                                  style: JTTextStyle.caption(
                                    color: JTColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        showNoti = !showNoti;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        showNoti = false;
                      });
                      
                    },),
              );
            }),
          ),
        ),
        PopupMenuButton(
          padding: const EdgeInsets.only(right: 0),
          offset: const Offset(0, 50),
          color: Theme.of(context).backgroundColor,
          onCanceled: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                snapshot.hasData
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          _getShortName(snapshot.data!.fullName),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (context) {
            return _adminMenuItems.map((sidebar.MenuItem item) {
              return PopupMenuItem<sidebar.MenuItem>(
                value: item,
                child: Row(
                  children: [
                    if (item.icon != null)
                      Icon(
                        item.icon,
                        size: 24,
                        color: Colors.black,
                      ),
                    if (item.svgIcon != null)
                      SvgIcon(
                        item.svgIcon!,
                        size: 24.0,
                        color: Colors.black,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          onSelected: (sidebar.MenuItem menuItem) {
            if (menuItem.title == ScreenUtil.t(I18nKey.language)) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LanguageDialog(snapshot: snapshot);
                },
              );
            }
            if (menuItem.title == ScreenUtil.t(I18nKey.account)) {
              navigateTo(userProfileRoute);
            }
            if (menuItem.title == ScreenUtil.t(I18nKey.signOut)) {
              showNoti = false;
              AuthenticationBlocController()
                  .authenticationBloc
                  .add(UserLogOut());
            }
          },
        ),
      ],
    );
  }

  _buildSideBar({
    required BuildContext context,
    required AsyncSnapshot<AccountModel> snapshot,
  }) {
    if (snapshot.hasData) {
      final currentUser = snapshot.data!;
      final currentUserRoles = currentUser.roles
          .map((e) => e.modules.map((m) => m.name).toList())
          .toList();
      if (currentUser.isSuperadmin) {
        _allowUserManagement = true;
        _allowSmartParking = true;
        _allowFaceReco = true;
        _allowHealthyCheck= true;
      } else {
        for (var modules in currentUserRoles) {
          if (modules.contains('USER_MANAGEMENT')) {
            _allowUserManagement = true;
          }
          if (modules.contains('SMART_PARKING')) {
            _allowSmartParking = true;
            
          }
          if (modules.contains('FACE_RECOGNITION')) {
            _allowFaceReco = true;
          }
          if(modules.contains('HEALTHY CHECK')){
            _allowHealthyCheck= true;
          }
        }
      }
    }
    List<sidebar.MenuItem> _sideBarItems = [];
    List<sidebar.MenuItem> _newSideBarItems;
    _newSideBarItems = [
      sidebar.MenuItem(
        title: ScreenUtil.t(I18nKey.adminControl)!.toUpperCase(),
        children: [
          sidebar.MenuItem(
            title: ScreenUtil.t(I18nKey.dashboard)!,
            route: dashboardRoute,
            svgIcon: SvgIcons.dashboard,
          ),
        ],
      ),
      sidebar.MenuItem(
        title: ScreenUtil.t(I18nKey.module)!.toUpperCase(),
        children: [
          // MenuItem(
          //   title: ScreenUtil.t(I18nKey.smartMeeting)!,
          //   route: smartMeetingRoute,
          //   svgIcon: SvgIcons.smartMeeting,
          // ),
          if (_allowSmartParking)
            sidebar.MenuItem(
              title: ScreenUtil.t(I18nKey.smartParking)!,
              route: smartParkingRoute,
              svgIcon: SvgIcons.smartParking,
            ),
          if (_allowFaceReco)
            sidebar.MenuItem(
              title: ScreenUtil.t(I18nKey.faceRecognition)!,
              route: faceRecognitionRoute,
              svgIcon: SvgIcons.faceRecognition,
            ),
          if(_allowHealthyCheck) sidebar.MenuItem(
            title: ScreenUtil.t(I18nKey.healthyCheck)!,
            route: healthyCheckRoute,
            svgIcon: SvgIcons.healthyCheck,
          ),
          // MenuItem(
          //   title: ScreenUtil.t(I18nKey.occupancyMonitor)!,
          //   route: occupancyMonitorRoute,
          //   svgIcon: SvgIcons.occupancyMonitor,
          // ),
          // MenuItem(
          //   title: ScreenUtil.t(I18nKey.riskManagement)!,
          //   route: riskManagementRoute,
          //   svgIcon: SvgIcons.riskManagement,
          // ),
          // MenuItem(
          //   title: ScreenUtil.t(I18nKey.buildingManagement)!,
          //   route: buildingManagementRoute,
          //   svgIcon: SvgIcons.buildingManagement,
          // ),
          if (_allowUserManagement)
            sidebar.MenuItem(
              title: ScreenUtil.t(I18nKey.userManagement)!,
              route: userManagementRoute,
              svgIcon: SvgIcons.userManagement,
            ),
        ],
      ),
    ];
    // Build on first generation.
    if (_sideBarItems.isEmpty) {
      _sideBarItems = _newSideBarItems;
    }
    // Apply changes only if the
    var shouldUpdateSideBars = false;
    if (snapshot.hasData) {
      if (_sideBarItems.length != _newSideBarItems.length) {
        shouldUpdateSideBars = true;
      } else {
        for (int i = 0; i < _sideBarItems.length; i++) {
          if (_sideBarItems[i].children.length !=
              _newSideBarItems[i].children.length) {
            shouldUpdateSideBars = true;
            break;
          }
        }
      }
    }

    if (shouldUpdateSideBars) {
      _sideBarItems = _newSideBarItems;
    }
    return sidebar.SideBar(
      width: 253,
      backgroundColor: Theme.of(context).buttonTheme.colorScheme!.secondary,
      activeBackgroundColor: Theme.of(context).backgroundColor,
      borderColor: Theme.of(context).buttonTheme.colorScheme!.primary,
      iconColor: Theme.of(context).textTheme.headline6!.color,
      activeIconColor: Theme.of(context).textTheme.button!.color,
      textStyle: Theme.of(context).textTheme.headline6!,
      activeTextStyle: Theme.of(context).textTheme.button!,
      parentTextStyle: Theme.of(context).textTheme.headline6!,
      parentActiveTextStyle: Theme.of(context).textTheme.button!,
      items: _sideBarItems,
      selectedRoute: widget.route,
      onSelected: _onSideBarItemSelected,
    );
  }

  _onSideBarItemSelected(sidebar.MenuItem item) {
    setState(() {
      showNoti = false;
    });
    if (item.route != null &&
        (item.route != widget.route || item.subRoute != widget.subRoute)) {
      navigateTo(item.route!);
    }
  }

  _showError(String errorCode) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(showError(errorCode, context))),
    );
  }

  _getShortName(String name) {
    final list = name.split(' ');
    if (list.length > 4) {
      return list.sublist(0, 4).join(' ');
    }
    return name;
  }

  Future<void> _showNotification({String? title, String? body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title ?? '',
      body ?? '',
      platformChannelSpecifics,
      payload: selectedNotificationPayload,
    );
  }

  void _requestPermissionsLocal() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void registerNotification() async {
    FirebaseConfigs.configuration();
    _messaging = FirebaseMessaging.instance;
    final currentAccount = await _accountBloc.getProfile();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // logDebug('message.data: ${message.data}');
        if (message.notification != null &&
            message.notification!.body != '{}') {
          _getPermission(
            message: message,
            currentAccount: currentAccount,
            action: () {
              _notificationBloc.add(const NotificationUnreadTotal());
            },
          );
          // Parse the message received
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            dataTitle: message.data['title'].toString(),
            dataBody: message.data['body'].toString(),
          );

          setState(() {
            _notificationInfo = notification;
            // _totalNotifications++;
          });

          if (_notificationInfo != null) {
            // For displaying the notification as an overlay
            /* showSimpleNotification(
            Text(_notificationInfo.title),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo.body),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          ); */
            _getPermission(
                message: message,
                currentAccount: currentAccount,
                action: () {
                  _showNotification(
                    title: _notificationInfo!.title,
                    body: _notificationInfo!.body,
                  );
                });
          }
        } else {
          if (message.data['reloadNotifications']?.toString() == 'true') {
            _getPermission(
              message: message,
              currentAccount: currentAccount,
              action: () {
                _notificationBloc.add(
                    NotificationUnreadTotal(notiId: message.data['notiId']));
              },
            );
          }
          if (message.data['reloadDoorStatus']?.toString() == 'true') {
            if (locator<AppRouterDelegate>().currentConfiguration.name ==
                eventRoute) {
              Timer.periodic(const Duration(seconds: 2), (timer) {
                setState(() {
                  widget.onFetch();
                });
                timer.cancel();
              });
            }
            if (locator<AppRouterDelegate>().currentConfiguration.name ==
                controllRoute) {
              setState(() {
                widget.onFetch();
                if (currentRoomId == message.data['doorID']?.toString()) {
                  doorStatusBloc.fetchDoorStatusById(id: currentRoomId);
                }
              });
            }
          }
          if (message.data['isReload']?.toString() == 'true') {
            setState(() {
              widget.onFetch();
            });
          }
        }
      });
    } else {
      logDebug('User declined or has not accepted permission');
    }
    //Get FCM token

    _messaging
        ?.getToken(
            vapidKey:
                "BK15yRsndcz4HoY53t4pk_p6FSWLGZP2hY3zWn_4HKDo2o9uMwIo9G_HqErjEblXTxUqBXvDTdHy4O2zS9vWbhI")
        .then(
      (fcmToken) {
        logDebug('fcmToken: $fcmToken');
        setState(() {
          currentFcmToken = fcmToken;
        });
        NotificationRepository()
            .updateFcmToken(body: {'fcm_token': '$fcmToken'})
            .then((value) => logDebug(
                'Call updateFcmToken to server ${value ? 'Ok' : 'Fail'}'))
            .catchError((e) => logDebug('Call updateFcmToken Error: $e'));
      },
    ).catchError((dynamic err) {
      logDebug('Has some errors on get fcmToken: $err');
    });
  }

  _getPermission({
    required RemoteMessage message,
    required AccountModel currentAccount,
    required Function() action,
  }) {
    bool allowShowNoti = false;
    if (message.data['isValid']?.toLowerCase() == 'false') {
      final listPermissionCodes = currentAccount.roles.map((e) {
        if (e.modules.where((e) => e.name == 'SMART_PARKING').isNotEmpty) {
          return e.modules
              .firstWhere((e) => e.name == 'SMART_PARKING')
              .permissions
              .map((e) => e.permissionCode)
              .toList();
        }
      }).toList();

      if (currentAccount.isSuperadmin) {
        allowShowNoti = true;
      } else {
        for (var permissionCodes in listPermissionCodes) {
          setState(() {
            if (permissionCodes!
                .contains(PermissionsCode.smartParkingAllRoles)) {
              allowShowNoti = true;
            }
            if (permissionCodes
                .contains(PermissionsCode.smartParkingReceiveNoti)) {
              allowShowNoti = true;
            }
          });
        }
      }
      if (allowShowNoti) {
        action();
      }
    } else {
      action();
    }
  }

// For handling notification when the app is in terminated state
  void checkForInitialMessage() async {
    FirebaseConfigs.configuration();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'].toString(),
        dataBody: initialMessage.data['body'].toString(),
      );

      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    }
  }

  _initLocalPushNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String? title, String? body, String? payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        logDebug('notification payload: $payload');
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    _notificationBloc.add(const NotificationUnreadTotal());
    logDebug("Handling a background message: ${message.messageId}");
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

// const MethodChannel platform =
//     MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}

String? selectedNotificationPayload;
