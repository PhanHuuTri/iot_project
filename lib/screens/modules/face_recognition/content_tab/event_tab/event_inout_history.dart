import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/face_recog/blocs/event/event_bloc.dart';
import 'package:web_iot/widgets/data_table/table_pagination.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../../core/base/blocs/block_state.dart';
import '../../../../../core/modules/face_recog/models/event_model.dart';
import '../../../../../main.dart';
import '../../../../../open_sources/popover/popover.dart';
import '../../../../../widgets/data_table/table_component.dart';
import '../../../../../widgets/table/dynamic_table.dart';
import '../../../../../widgets/table_columns/table_column_date_time.dart';
import '../../../smart_parking/component/filter_popover_content.dart';

class EventInOutHitory extends StatefulWidget {
  final EventBloc eventBloc;
  final List<String> eventType;
  final List<EventModel>? listEventData;
  final Function({
    List<String>? eventType,
    String? hint,
  }) onFetch;
  final bool? isInitData;
  const EventInOutHitory({
    Key? key,
    required this.eventBloc,
    required this.onFetch,
    required this.eventType,
    this.listEventData,
    this.isInitData,
  }) : super(key: key);

  @override
  State<EventInOutHitory> createState() => _EventInOutHitoryState();
}

class _EventInOutHitoryState extends State<EventInOutHitory> {
  bool isShowPopover = false;
  List<EventModel> listAllData = [];
  List<EventModel> listDisplayData = [];

  @override
  Widget build(BuildContext context) {
    if (widget.isInitData != null && widget.isInitData!) {
      if (listAllData.isNotEmpty) {
        listAllData.clear();
      }
      listAllData.addAll(widget.listEventData!);
      listDisplayData = widget.listEventData!;
    } else {
      if (widget.listEventData != null) {
        if (listAllData.isNotEmpty) {
          var listData = widget.listEventData!
              .where((e) => listAllData.where((l) => l.id == e.id).isEmpty)
              .toList();
          if (listData.isNotEmpty) {
            listAllData.addAll(listData);
          }
        } else {
          listAllData.addAll(widget.listEventData!);
        }
        if (widget.listEventData!.isNotEmpty) {
          listDisplayData = widget.listEventData!;
        }
      }
    }

    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.no)!,
        width: 150,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.room)!,
        width: 150,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.event)!,
        width: 200,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.faceRecoUser)!,
        width: 250,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.faceRecoGroupUser)!,
        width: 250,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.date)!,
        width: 130,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.time)!,
        width: 130,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceId)!,
        width: 150,
        isConstant: true,
      ),
    ];
    return Stack(
      children: [
        StreamBuilder(
          stream: widget.eventBloc.allData,
          builder:
              (context, AsyncSnapshot<ApiResponse<EventListModel?>> snapshot) {
             //final meta = snapshot.data!.model!.meta;
            if (snapshot.hasData) {
              return Column(
                children: [
                  DynamicTable(
                    columnWidthRatio: tableHeaders,
                    numberOfRows: listDisplayData.length,
                    rowBuilder: (index) => _rowFor(
                      item: listDisplayData[index],
                    ),
                    hasBodyData: true,
                    tableBorder: Border.all(color: AppColor.black, width: 1),
                    headerBorder: TableBorder(
                      bottom: const BorderSide(color: AppColor.black),
                      verticalInside: BorderSide(
                        color: AppColor.noticeBackground,
                      ),
                    ),
                    headerStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    bodyBorder: TableBorder.all(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    getHeaderButton: _getHeaderButton,
                  ),
                  if (listAllData.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(ScreenUtil.t(I18nKey.noData)!),
                    ),
                  if (listDisplayData.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Padding(
                        //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        //     child: TablePagination(
                        //       onFetch: (index) {
                        //           widget.onFetch;
                        //       },
                        //       pagination: meta,
                        //     ),
                        //   ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            backgroundColor: AppColor.white,
                            onSurface: AppColor.primary,
                            primary: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColor.primary,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: AppColor.primary,
                              size: 12,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              widget.onFetch(
                                eventType: widget.eventType,
                                hint: _getPreviousHint(listDisplayData.first),
                              );
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            backgroundColor: AppColor.white,
                            primary: AppColor.primary,
                            onSurface: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColor.primary,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: AppColor.primary,
                            size: 12,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.onFetch(
                                eventType: widget.eventType,
                                hint: listDisplayData.last.hint,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: snapshot.error.toString().trim() == 'request timeout'
                    ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
                    : Text(snapshot.error.toString()),
              );
            }
            return StreamBuilder(
              stream: widget.eventBloc.allDataState,
              builder: (context, state) {
                if (!state.hasData || state.data == BlocState.fetching) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: JTCircularProgressIndicator(
                      size: 24,
                      strokeWidth: 2.0,
                      color: Theme.of(context).textTheme.button!.color!,
                    ),
                  );
                }
                return const SizedBox();
              },
            );
          },
        ),
      ],
    );
  }

  TableRow _rowFor({required EventModel item}) {
    final stt =
        listAllData.indexOf(listAllData.firstWhere((e) => e.id == item.id)) + 1;
    return TableRow(
      children: [
        tableCellText(
          title: stt.toString(),
        ),
        tableCellText(
          title: item.doorModels.isNotEmpty ? item.doorModels.first.name : '',
        ),
        tableCellText(
          title: _displayEvent(item.eventTypeId.code),
        ),
        tableCellText(
          title: item.userId.name,
        ),
        tableCellText(
          title: item.userGroupId.name,
        ),
        tableCellText(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: TableColumnDateTime(
              value: item.datetime,
              displayedFormat: ScreenUtil.t(I18nKey.formatDMY)!,
            ),
          ),
        ),
        tableCellText(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: TableColumnDateTime(
              value: item.datetime,
              displayedFormat: 'HH:mm:ss',
            ),
          ),
        ),
        tableCellText(
          title: item.deviceId.id,
        ),
      ],
    );
  }

  String _displayEvent(String eventId) {
    String displayEvent = '';
    if (eventId == '4867') {
      displayEvent = ScreenUtil.t(I18nKey.identifySuccessFace)!;
    }
    if (eventId == '5125') {
      displayEvent = ScreenUtil.t(I18nKey.identifyFailFace)!;
    }
    return displayEvent;
  }

  Widget? _getHeaderButton(
    BuildContext tableContext,
    String title,
  ) {
    if (title == ScreenUtil.t(I18nKey.event)!) {
      return LayoutBuilder(builder: (iconContext, constraints) {
        return SizedBox(
          width: 40,
          child: InkWell(
            child: const Icon(
              Icons.filter_list_rounded,
              color: AppColor.black,
              size: 18,
            ),
            onTap: () {
              showPopover(
                width: 250,
                arrowHeight: 0,
                arrowWidth: 0,
                radius: 4,
                direction: PopoverDirection.bottomRight,
                barrierColor: Colors.transparent,
                shadow: [
                  BoxShadow(
                    color: AppColor.shadow.withOpacity(0.16),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
                context: tableContext,
                bodyBuilder: (popoverContext) {
                  return FilterPopoverContent(
                    title: title,
                    itemHeight: 40.0,
                    selected: widget.eventType,
                    source: const ['5125', '4867'],
                    onChanged: (eventType) async {
                      widget.onFetch(eventType: eventType);
                    },
                    enableSearch: false,
                    searchHintText: ScreenUtil.t(I18nKey.search),
                    onDisplayedName: (value) {
                      if (value == '5125') {
                        return ScreenUtil.t(I18nKey.identifyFailFace)!;
                      } else {
                        return ScreenUtil.t(I18nKey.identifySuccessFace)!;
                      }
                    },
                  );
                },
              );
            },
          ),
        );
      });
    } else {
      return null;
    }
  }

  _getPreviousHint(EventModel item) {
    final _dateTime =
        (DateTime.tryParse(item.datetime)!.millisecondsSinceEpoch / 100)
            .toString();
    final itemNumber =
        item.hint.substring(_dateTime.length + item.deviceId.id.length);
    final previousItemNumberHint = (int.tryParse(itemNumber)! + 1).toString();
    itemNumber.indexOf(int.tryParse(itemNumber)!.toString());
    final previousItemNumberHintToString = itemNumber.replaceRange(
        itemNumber.indexOf(int.tryParse(itemNumber)!.toString()),
        itemNumber.length,
        previousItemNumberHint);
    return _dateTime + item.deviceId.id + previousItemNumberHintToString + '-';
  }
}
