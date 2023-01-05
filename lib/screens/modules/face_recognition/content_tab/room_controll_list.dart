import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/base/blocs/block_state.dart';
import '../../../../core/modules/face_recog/blocs/door/door_bloc.dart';
import '../../../../core/modules/face_recog/models/door_model.dart';
import '../../../../main.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';

final faceControllKey = GlobalKey<_RoomControllListState>();

class RoomControllList extends StatefulWidget {
  final Function(int) changeTab;
  final bool allowViewRooms;
  const RoomControllList({
    Key? key,
    required this.changeTab,
    required this.allowViewRooms,
  }) : super(key: key);

  @override
  _RoomControllListState createState() => _RoomControllListState();
}

class _RoomControllListState extends State<RoomControllList> {
  final _doorBloc = DoorBloc();
  bool _changeColor = false;
  @override
  void initState() {
    JTToast.init(context);
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _doorBloc.dispose();
    doorStatusBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, size) {
            final roomTabWidth = size.maxWidth / 4;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: _doorBloc.userAllDoor,
                    builder: (context,
                        AsyncSnapshot<ApiResponse<ListDoorControlModel?>>
                            snapshot) {
                      if (snapshot.hasData) {
                        final rooms = snapshot.data!.model!.records;

                        return rooms.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 16,
                                      color: AppColor.shadow.withOpacity(0.16),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: roomTabWidth,
                                      child: _buildRoomTab(rooms: rooms),
                                    ),
                                    Container(
                                      width:
                                          size.maxWidth - roomTabWidth - 16 * 2,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                      child: _buildTabContent(rooms: rooms),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 16),
                                child: Text(ScreenUtil.t(I18nKey.noData)!),
                              );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: snapshot.error.toString().trim() ==
                                  'request timeout'
                              ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
                              : Text(snapshot.error.toString()),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  StreamBuilder(
                    stream: _doorBloc.allDataState,
                    builder: (context, state) {
                      if (!state.hasData || state.data == BlocState.fetching) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: JTCircularProgressIndicator(
                              size: 24,
                              strokeWidth: 2.0,
                              color: Theme.of(context).textTheme.button!.color!,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            );
          })
        ],
      );
    });
  }

  Widget _buildRoomTab({required List<DoorControlModel> rooms}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        for (var room in rooms)
          InkWell(
            onTap: () {
              setState(() {
                roomControlSelectedTab = rooms.indexOf(room);
              });
            },
            child: LayoutBuilder(builder: (context, size) {
              final int index = rooms.indexOf(room);
              final isSelected = roomControlSelectedTab == index;
              final doorId = room.door.id.toString();
              doorStatusBloc.fetchDoorStatusById(id: doorId);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  border: Border(
                    right: !isSelected
                        ? BorderSide(
                            color: AppColor.primary,
                            width: 4,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 82,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.primary : AppColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          index == 0 ? const Radius.circular(4) : Radius.zero,
                      bottomLeft: index == rooms.length - 1
                          ? const Radius.circular(4)
                          : Radius.zero,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 10, 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.door.name,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColor.white
                                    : AppColor.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            StreamBuilder(
                                stream: doorStatusBloc.doorStatus,
                                builder: (context,
                                    AsyncSnapshot<ApiResponse<DoorStatusModel?>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    final status = snapshot.data!.model!.status;
                                    return Text(
                                      _getStatusName(status),
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColor.white
                                            : _getStatusColor(status),
                                        fontSize: 12,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Container(
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColor.primary,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            }),
          ),
        if (rooms.length < 3)
          Container(
            height: 82.0 * (3 - rooms.length),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColor.primary,
                  width: 4,
                ),
              ),
            ),
          ),
      ],
    );
  }

  _getStatusName(String status) {
    switch (status) {
      case '-1':
        return ScreenUtil.t(I18nKey.statusInvalid)!;
      case '0':
        return ScreenUtil.t(I18nKey.statusNormal)!;
      case '1':
        return ScreenUtil.t(I18nKey.statusLocked)!;
      case '2':
        return ScreenUtil.t(I18nKey.statusUnlocked)!;
      case '4':
        return ScreenUtil.t(I18nKey.statusForcedOpenAlarm)!;
      case '8':
        return ScreenUtil.t(I18nKey.statusHeldOpenAlarm)!;
      case '16':
        return ScreenUtil.t(I18nKey.statusAPBFailed)!;
      case '32':
        return ScreenUtil.t(I18nKey.disconected)!;
      case '64':
        return ScreenUtil.t(I18nKey.statusScheduleLocked)!;
      case '128':
        return ScreenUtil.t(I18nKey.statusScheduleUnlocked)!;
      case '256':
        return ScreenUtil.t(I18nKey.statusEmergencyLocked)!;
      case '512':
        return ScreenUtil.t(I18nKey.statusEmergencyUnlocked)!;
      case '1024':
        return ScreenUtil.t(I18nKey.statusOperatorLocked)!;
      case '2048':
        return ScreenUtil.t(I18nKey.statusOperatorUnlocked)!;
      default:
        return ScreenUtil.t(I18nKey.statusInvalid)!;
    }
  }

  _getStatusColor(String status) {
    switch (status) {
      case '-1':
        return AppColor.dividerColor;
      case '0':
        return AppColor.black;
      case '1':
        return AppColor.card3;
      case '2':
        return AppColor.card3;
      case '4':
        return AppColor.card3;
      case '8':
        return AppColor.card3;
      case '16':
        return AppColor.error;
      case '32':
        return AppColor.error;
      case '64':
        return AppColor.card3;
      case '128':
        return AppColor.card3;
      case '256':
        return AppColor.error;
      case '512':
        return AppColor.error;
      case '1024':
        return AppColor.card3;
      case '2048':
        return AppColor.card3;
      default:
        return AppColor.dividerColor;
    }
  }

  Widget _buildTabContent({required List<DoorControlModel> rooms}) {
    final room = rooms[roomControlSelectedTab];
    final doorId = room.door.id.toString();
    currentRoomId = doorId;
    doorStatusBloc.fetchDoorStatusById(id: doorId);
    return StreamBuilder(
        stream: doorStatusBloc.doorStatus,
        builder:
            (context, AsyncSnapshot<ApiResponse<DoorStatusModel?>> snapshot) {
          if (snapshot.hasData) {
            final status = snapshot.data!.model!.status;
            logDebug('status $status');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                    child: Text(
                      ScreenUtil.t(I18nKey.controllDoor)! +
                          ' ' +
                          room.door.name.toLowerCase(),
                      style: const TextStyle(
                        color: AppColor.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      color: AppColor.buttonBackground,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                              child: Container(
                                height: 112,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            ScreenUtil.t(I18nKey.doorStatus)!,
                                            style: TextStyle(
                                              color: AppColor.subTitle,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            ScreenUtil.t(
                                                I18nKey.mustBeNormalToOpen)!,
                                            style: TextStyle(
                                              color: AppColor.card3,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColor.primary,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            _roomStatusButton(
                                              title:
                                                  ScreenUtil.t(I18nKey.normal)!,
                                              isSelected: status == '0',
                                              onTap: () {
                                                _releaseDoor(doorId);
                                              },
                                            ),
                                            _roomStatusButton(
                                              title:
                                                  ScreenUtil.t(I18nKey.lock)!,
                                              isSelected: status == '1024',
                                              onTap: () {
                                                _lockDoor(doorId);
                                              },
                                            ),
                                            _roomStatusButton(
                                              title: ScreenUtil.t(
                                                  I18nKey.alwaysOpen)!,
                                              isSelected: status == '2048',
                                              onTap: () {
                                                _unlockDoor(doorId);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                              child: Container(
                                height: 112,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _openDoorButton(
                                  status: status,
                                  doorId: doorId,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Widget _openDoorButton({
    required String status,
    required String doorId,
  }) {
    final _isNomarl = status == '0';
    final buttonColor = _isNomarl
        ? _changeColor
            ? Colors.white
            : AppColor.primary
        : AppColor.hintColor;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            ScreenUtil.t(I18nKey.openDoor)!,
            style: TextStyle(
              color: AppColor.subTitle,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: _changeColor ? AppColor.primary : Colors.white,
              border: Border.all(
                color: buttonColor,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            height: 46,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new_rounded,
                      size: 18,
                      color: buttonColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Text(
                        ScreenUtil.t(I18nKey.active)!,
                        style: TextStyle(
                          color: buttonColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: _isNomarl
                  ? () {
                      setState(() {
                        _changeColor = true;
                        Timer(
                          const Duration(milliseconds: 250),
                          () {
                            setState(() {
                              _changeColor = false;
                            });
                          },
                        );
                        _openDoor(doorId);
                      });
                    }
                  : null,
            ),
          ),
        )
      ],
    );
  }

  Widget _roomStatusButton({
    required String title,
    required bool isSelected,
    Function()? onTap,
  }) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? AppColor.primary : Colors.transparent,
          ),
          child: InkWell(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColor.white : AppColor.subTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  _lockDoor(String id) {
    _doorBloc.lockDoor(id: id).then((value) {
      doorStatusBloc.fetchDoorStatusById(id: id);
    });
  }

  _unlockDoor(String id) {
    _doorBloc.unlockDoor(id: id).then((value) {
      doorStatusBloc.fetchDoorStatusById(id: id);
    });
  }

  _releaseDoor(String id) {
    _doorBloc.releaseDoor(id: id).then((value) {
      doorStatusBloc.fetchDoorStatusById(id: id);
    });
  }

  _openDoor(String id) {
    _doorBloc.openDoor(id: id).then((value) async {
      if (value.result.toLowerCase() == 'true') {
        doorStatusBloc.fetchDoorStatusById(id: id);
        await Future.delayed(const Duration(milliseconds: 400));
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
      }
    });
  }

  fetchData() {
    _doorBloc.fetchAllUserDoor(params: {});
  }
}
