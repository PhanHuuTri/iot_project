import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_iot/screens/layout_template/component/dialogScreenNoti.dart';
import 'package:web_iot/widgets/flutter_admin_scaffold/admin_scaffold.dart'
    as sidebar;
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../config/svg_constants.dart';
import '../../../core/modules/user_management/blocs/notification/notification_bloc_public.dart';
import '../../../core/modules/user_management/models/notification_model.dart';
import '../../../main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

final GlobalKey<_NotificationContentState> notiKey = GlobalKey();

class NotificationContent<T> extends StatefulWidget {
  final NotificationBloc notificationBloc;
  const NotificationContent({
    Key? key,
    required this.notificationBloc,
  }) : super(key: key);

  @override
  _NotificationContentState createState() => _NotificationContentState();
}

class _NotificationContentState extends State<NotificationContent> {
  final _scrollController = ScrollController();
  int maxPage = 0;
  int currentPage = 1;
  late BuildContext currentContext;
  bool showUnSeen = false;
  List<String> filters = [];
  List<NotificationModel> notifications = [];

  final notificationBloc = NotificationBloc();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<sidebar.MenuItem> _modules = [
      sidebar.MenuItem(
        title: ScreenUtil.t(I18nKey.all)!,
      ),
      // MenuItem(
      //   title: ScreenUtil.t(I18nKey.smartMeeting)!,
      //   svgIcon: SvgIcons.smartMeeting,
      // ),
      sidebar.MenuItem(
        title: ScreenUtil.t(I18nKey.smartParking)!,
        svgIcon: SvgIcons.smartParking,
      ),
      sidebar.MenuItem(
        title: ScreenUtil.t(I18nKey.faceRecognition)!,
        svgIcon: SvgIcons.faceRecognition,
      ),
    ];
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(),
          child: SizedBox(
            width: 407,
            height: 606,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton(
                            child: Text(
                              ScreenUtil.t(I18nKey.all)!,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: showUnSeen
                                  ? Theme.of(context).dividerColor
                                  : Theme.of(context).highlightColor,
                            ),
                            onPressed: () {
                              setState(() {
                                showUnSeen = false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton(
                            child: Text(
                              ScreenUtil.t(I18nKey.unSeen)!,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: showUnSeen
                                  ? Theme.of(context).highlightColor
                                  : Theme.of(context).dividerColor,
                            ),
                            onPressed: () {
                              setState(() {
                                showUnSeen = true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 50,
                              child: _filterButton(_modules),
                            ),
                            Tooltip(
                              message: ScreenUtil.t(I18nKey.readAllNoti),
                              child: SizedBox(
                                width: 40,
                                height: 50,
                                child: InkWell(
                                  child: const Icon(
                                    Icons.done_all_outlined,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    widget.notificationBloc
                                        .add(ReadAllNotification());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => notificationBloc
                    ..add(
                      NotificationFetchEvent(
                        params: {
                          'limit': 10,
                          'page': currentPage,
                        },
                      ),
                    ),
                  child: Expanded(
                    child: _buildContent(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterButton(List<sidebar.MenuItem> modules) {
    return PopupMenuButton(
      padding: const EdgeInsets.only(right: 0),
      offset: const Offset(0, 50),
      color: Theme.of(context).backgroundColor,
      onCanceled: () {},
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.filter_list_rounded,
          size: 20.0,
          color: Colors.black,
        ),
      ),
      itemBuilder: (context) {
        return modules.map((sidebar.MenuItem item) {
          return PopupMenuItem<sidebar.MenuItem>(
            value: item,
            child: Row(
              children: [
                if (item.icon != null) Icon(item.icon),
                if (item.svgIcon != null)
                  SvgIcon(
                    item.svgIcon!,
                    size: 16.0,
                    color: Theme.of(context).primaryColor,
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
                const Spacer(),
                if (filters.contains(item.title) ||
                    filters.isEmpty && item.title == ScreenUtil.t(I18nKey.all))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (sidebar.MenuItem menuItem) {
        setState(() {
          filters.clear();
          // if (menuItem.title == ScreenUtil.t(I18nKey.smartMeeting)) {
          //   filters.add(ScreenUtil.t(I18nKey.smartMeeting)!);
          // }
          if (menuItem.title == ScreenUtil.t(I18nKey.smartParking)) {
            filters.add(ScreenUtil.t(I18nKey.smartParking)!);
          }
          if (menuItem.title == ScreenUtil.t(I18nKey.faceRecognition)) {
            filters.add(ScreenUtil.t(I18nKey.faceRecognition)!);
          }
        });
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationFetchDoneState) {
          if (notifications.isNotEmpty) {
            final records = state.data.model!.records;
            for (var noti in records) {
              if (notifications.where((e) => e.id == noti.id).isEmpty) {
                notifications.add(noti);
              }
            }
          } else {
            notifications = state.data.model!.records;
          }
          maxPage = state.data.model!.meta.totalPage;
        }
        if (state is ReadNotificationDoneState) {
          var replaceIndex =
              notifications.indexWhere((e) => e.id == state.data.model!.id);
          notifications.removeAt(replaceIndex);
          notifications.insert(replaceIndex, state.data.model!);
        }
        if (state is NotificationFetchFailState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? '')),
          );
        }
        if (state is NotificationExceptionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? '')),
          );
        }
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          currentContext = context;
          return (state is NotificationWaitingState)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: JTCircularProgressIndicator(
                      size: 24,
                      strokeWidth: 2.0,
                      color: Theme.of(context).textTheme.button!.color!,
                    ),
                  ),
                )
              : _notiContent();
        },
      ),
    );
  }

  Widget _notiContent() {
    final isEnglish = App.of(context)!.currentLocale.languageCode == 'en';
    final titleStyle = Theme.of(context).textTheme.headline5!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
    final displayNoti = filters.isNotEmpty
        ? notifications.where((e) => filters.contains(e.title)).toList()
        : showUnSeen
            ? notifications.where((e) => e.read == false).toList()
            : notifications;
    return RefreshIndicator(
        onRefresh: () async {
          refreshData();
        },
        child: displayNoti.isNotEmpty
            ? ListView.builder(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: displayNoti.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = displayNoti[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 50),
                      width: 375,
                      child: InkWell(
                        onTap: () {
                          //debugPrint(item.category+" "+item.id+" "+item.data.idParking);
                          showGeneralDialog(
                            context: context,
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return DialogNoti(
                                notiItem: item,
                              );
                            },
                          );
                          notiKey.currentState!.notificationBloc.add(
                              ReadNotification(
                                  params: {'id': item.id, 'read': true}));
                        },
                        child: Row(
                          children: [
                            Row(
                              children: [
                                _getModuleIcon(item.category),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SizedBox(
                                    width: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: titleStyle,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          isEnglish
                                              ? item.multipleLanguagesBody.en
                                              : item.multipleLanguagesBody.vi,
                                        ),
                                        Text(
                                          _formatDateTime(item.createdTime),
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!item.read)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: InkWell(
                                        child: Icon(
                                          Icons.info_rounded,
                                          size: 20.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    SizedBox(
                                      width: 150,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _secondasNowTime(item.createdTime),
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    ScreenUtil.t(I18nKey.noData)!,
                  ),
                ),
              ));
  }

  String _formatDateTime(dynamic value) {
    final format = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
    String _displayedValue = '';
    if (value is int) {
      if (value != 0) {
        final _dateTime = DateTime.fromMillisecondsSinceEpoch(value);
        final _dateTimeLocal = _dateTime.toLocal();
        _displayedValue = DateFormat(format).format(_dateTimeLocal);
      }
    } else if (value is String) {
      final _dateTime = DateTime.tryParse(value);
      final _dateTimeLocal = _dateTime!.toLocal();
      _displayedValue = DateFormat(format).format(_dateTimeLocal);
    }
    return _displayedValue;
  }

  String _secondasNowTime(int value) {
    final format = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
    final _dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    //DateTime dob = DateTime.parse(DateFormat(format).format(_dateTimeLocal));
    Duration dur = DateTime.now().difference(_dateTime);
    int _seconds = (dur.inMinutes % 60).ceil();
    int hours = (dur.inHours/24).ceil();
    String sum =hours>1?'': (dur.inDays == 0 ? '' : dur.inDays.toString()) +
        ' ' +
        dur.inHours.toString() +
        ' giờ ' +
        _seconds.toString() +
        'phút trước';
    return sum;
  }

  Widget _getModuleIcon(String module) {
    switch (module) {
      case 'General':
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SvgIcon(
            SvgIcons.smartParking,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
        );
      case 'Smart Parking':
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SvgIcon(
            SvgIcons.smartParking,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
        );
      case 'Face Recognition':
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SvgIcon(
            SvgIcons.faceRecognition,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: SvgIcon(
            SvgIcons.smartParking,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
        );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (currentPage < maxPage) {
        currentPage += 1;

        BlocProvider.of<NotificationBloc>(currentContext).add(
          NotificationFetchEvent(
            params: {
              'limit': 10,
              'page': currentPage,
            },
          ),
        );
      }
    }
  }

  refreshData() {
    maxPage = 0;
    currentPage = 1;
    notifications.clear();
    BlocProvider.of<NotificationBloc>(currentContext).add(
      NotificationFetchEvent(
        params: {
          'limit': 10,
          'page': currentPage,
        },
      ),
    );
  }
}
