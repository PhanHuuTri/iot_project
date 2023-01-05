import '../../../config/permissions_code.dart';
import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import '../../../core/modules/user_management/models/account_model.dart';
import '../../../widgets/joytech_components/joytech_components.dart';
import 'content_tab/dashboard.dart';
import 'content_tab/device_list.dart';
import 'content_tab/door_list.dart';
import 'content_tab/event_tab/event_list.dart';
import 'content_tab/room_controll_list.dart';
import 'content_tab/user_tab/user_list.dart';

class FaceRecognitionScreen extends StatefulWidget {
  final int tab;
  const FaceRecognitionScreen({Key? key, required this.tab}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  final _pageState = PageState();
  final _eventSearchKey = TextEditingController();
  final _userSearchKey = TextEditingController();
  // ignore: prefer_final_fields, unused_field
  int _limit = 10;
  List<List<String>> listPermissionCodes = [];
  // ignore: unused_field
  bool _allowViewNoti = false;
  bool _allowControllDevice = false;
  bool _allowViewEventHistory = false;
  bool _allowViewRooms = false;

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: faceRecognitionRoute,
      name: I18nKey.faceRecognition,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () => _fetchDataOnPage(),
      child: FutureBuilder(
        future: _pageState.currentUser,
        builder: (context, AsyncSnapshot<AccountModel> snapshot) => PageContent(
          userSnapshot: snapshot,
          pageState: _pageState,
          onFetch: () => _fetchDataOnPage(),
          route: faceRecognitionRoute,
          child: LayoutBuilder(
            builder: (context, size) {
              if (snapshot.hasData) {
                final currentUser = snapshot.data!;
                if (currentUser.isSuperadmin) {
                  _allowViewNoti = true;
                  _allowControllDevice = true;
                  _allowViewEventHistory = true;
                  _allowViewRooms = true;
                }
                listPermissionCodes = currentUser.roles.map((e) {
                  return e.modules
                      .firstWhere((e) => e.name == 'FACE_RECOGNITION')
                      .permissions
                      .map((e) => e.permissionCode)
                      .toList();
                }).toList();
                return _buildContent(listPermissionCodes);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<List<String>> listPermissionCodes) {
    ScreenUtil.init(context);
    for (var permissionCodes in listPermissionCodes) {
      if (permissionCodes.contains(PermissionsCode.faceRecoAllRoles)) {
        _allowViewNoti = true;
        _allowControllDevice = true;
        _allowViewEventHistory = true;
        _allowViewRooms = true;
      }
      if (permissionCodes.contains(PermissionsCode.faceRecoReceiveNoti)) {
        _allowViewNoti = true;
      }
      if (permissionCodes.contains(PermissionsCode.faceRecoControlDevice)) {
        _allowControllDevice = true;
      }
      if (permissionCodes.contains(PermissionsCode.faceRecoViewEventHistory)) {
        _allowViewEventHistory = true;
      }
      if (permissionCodes.contains(PermissionsCode.faceRecoViewRooms)) {
        _allowViewRooms = true;
      }
    }
    final List<String> tabs = [
      ScreenUtil.t(I18nKey.recDashboard)!,
      if (_allowViewRooms) ScreenUtil.t(I18nKey.roomControllList)!,
      if (_allowViewEventHistory) ScreenUtil.t(I18nKey.event)!,
      ScreenUtil.t(I18nKey.faceRecoUser)!,
      ScreenUtil.t(I18nKey.device)!,
      if (_allowControllDevice) ScreenUtil.t(I18nKey.door)!,
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: SizedBox(
                height: 40,
                child: JTTabMenu(
                  tabs: tabs,
                  currentTab: widget.tab,
                  changeTab: _changeTab, token: '',
                ),
              ),
            ),
            _getChild(context, listPermissionCodes),
          ],
        ),
      ),
    );
  }

  _changeTab(int tab) {
    if (tab == 0) {
      navigateTo(faceRecognitionRoute);
    } else if (tab == 1) {
      navigateTo(controllRoute);
    } else if (tab == 2) {
      navigateTo(eventRoute);
    } else if (tab == 3) {
      navigateTo(userRoute);
    } else if (tab == 4) {
      navigateTo(deviceRoute);
    } else if (tab == 5) {
      navigateTo(doorRoute);
    }
  }

  Widget _getChild(
    BuildContext context,
    List<List<String>> listPermissionCodes,
  ) {
    switch (widget.tab) {
      case 0:
        return 
        Dashboard(
          key: faceDashboardKey,
          changeTab: _changeTab,
        );
      case 1:
        return _checkPermission(
          allow: _allowViewRooms,
          child: RoomControllList(
            key: faceControllKey,
            changeTab: _changeTab,
            allowViewRooms: _allowViewRooms,
          ),
        );
      case 2:
        return _checkPermission(
          allow: _allowViewEventHistory,
          child: EventList(
            key: faceEventKey,
            keyword: _eventSearchKey,
            changeTab: _changeTab,
            allowViewEventHistory: _allowViewEventHistory,
          ),
        );
      case 3:
        return UserRecList(
          changeTab: _changeTab,
          key: faceUserKey,
          keyword: _userSearchKey,
        );
      case 4:
        return DeviceList(
          key: faceDeviceKey,
          changeTab: _changeTab,
        );
      case 5:
        return _checkPermission(
          allow: _allowControllDevice,
          child: DoorList(
            key: faceDoorKey,
            changeTab: _changeTab,
            allowControllDevice: _allowControllDevice,
          ),
        );
      default:
        return Dashboard(
          key: faceDashboardKey,
          changeTab: _changeTab,
        );
    }
  }

  Widget _checkPermission({required bool allow, required Widget child}) {
    if (allow) {
      return child;
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Column(
          children: [
            const Icon(
              Icons.report_gmailerrorred_outlined,
              size: 120,
            ),
            const SizedBox(height: 60),
            Align(
              alignment: Alignment.center,
              child: Text(
                ScreenUtil.t(I18nKey.doNotHavePermissionToAccess)!,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ],
        ),
      );
    }
  }

  _fetchDataOnPage() {
    final tab = widget.tab;
    if (tab == 0) {
      if (faceDashboardKey.currentState != null) {
        faceDashboardKey.currentState!.fetchData();
      }
    } else if (tab == 1) {
      if (faceControllKey.currentState != null) {
        faceControllKey.currentState!.fetchData();
      }
    } else if (tab == 2) {
      if (faceEventKey.currentState != null) {
        faceEventKey.currentState!.fetchData();
      }
    } else if (tab == 3) {
      if (faceUserKey.currentState != null) {
        faceUserKey.currentState!.fetchData();
      }
    } else if (tab == 4) {
      if (faceDeviceKey.currentState != null) {
        faceDeviceKey.currentState!.fetchData();
      }
    } else {
      if (faceDoorKey.currentState != null) {
        faceDoorKey.currentState!.fetchData();
      }
    }
  }
}

class ParkingFilterController {
  List<String> selectedStatus = [];
  String selectedUpdateTime = '';

  bool get hasFilter =>
      selectedStatus.isNotEmpty || selectedUpdateTime.isNotEmpty;
}
