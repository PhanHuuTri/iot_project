import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/face_recog/blocs/event/event_bloc.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../../core/base/blocs/block_state.dart';
import '../../../../../core/modules/face_recog/models/event_model.dart';
import '../../../../../main.dart';
import '../../../../../open_sources/popover/popover.dart';
import '../../../../../widgets/data_table/table_component.dart';
import '../../../../../widgets/data_table/table_pagination.dart';
import '../../../../../widgets/table/dynamic_table.dart';
import '../../../../../widgets/table_columns/table_column_date_time.dart';
import '../../../smart_parking/component/filter_popover_content.dart';
import 'user_info_dialog.dart';

class EventActionHitory extends StatefulWidget {
  final EventBloc eventOperationBloc;
  final Function(int, {List<String>? eventType}) onFetch;
  final List<String> eventType;
  const EventActionHitory({
    Key? key,
    required this.eventOperationBloc,
    required this.onFetch,
    required this.eventType,
  }) : super(key: key);

  @override
  State<EventActionHitory> createState() => _EventActionHitoryState();
}

class _EventActionHitoryState extends State<EventActionHitory> {
  List<String> _eventType = [];
  // ignore: prefer_final_fields
  int _limit = 10;
  // ignore: prefer_final_fields
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.room)!,
        width: 150,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.eventUser)!,
        width: 250,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.email)!,
        width: 250,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.date)!,
        width: 150,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.time)!,
        width: 150,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceId)!,
        width: 200,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.event)!,
        width: 250,
      ),
    ];
    return Stack(
      children: [
        StreamBuilder(
            stream: widget.eventOperationBloc.allData,
            builder: (context,
                AsyncSnapshot<ApiResponse<EventListModel?>> snapshot) {
              if (snapshot.hasData) {
                final events = snapshot.data!.model!.records;
                final int _total = int.tryParse(snapshot.data!.model!.total)!;
                int _totalPage = (_total / _limit).ceil();
                final Paging meta = Paging.fromJson(
                  {
                    "total_records": _total,
                    "limit": _limit,
                    "page": _page,
                    "total_page": _totalPage,
                  },
                );
                return Column(
                  children: [
                    DynamicTable(
                      columnWidthRatio: tableHeaders,
                      numberOfRows: events.length,
                      rowBuilder: (index) => _rowFor(
                        item: events[index],
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
                    if (events.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(ScreenUtil.t(I18nKey.noData)!),
                      ),
                    TablePagination(
                      onFetch: _fetchTableDataOnPage,
                      pagination: meta,
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
              return const SizedBox();
            }),
        StreamBuilder(
          stream: widget.eventOperationBloc.allDataState,
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
        ),
      ],
    );
  }

  TableRow _rowFor({required EventModel item}) {
    return TableRow(
      children: [
        tableCellText(
            title: item.doorModels.isNotEmpty ? item.doorModels.first.id : ''),
        tableCellOnHover(
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            child: Row(
              children: [
                InkWell(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.info,
                      size: 18,
                      color: AppColor.primary,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UserInfoDialog(
                          userInfos: [
                            UserInfoField(
                              fieldHeader: ScreenUtil.t(I18nKey.name)!,
                              info: item.userId.name,
                            ),
                            UserInfoField(
                              fieldHeader: ScreenUtil.t(I18nKey.email)!,
                              info: item.userEmail,
                            ),
                            UserInfoField(
                              fieldHeader: ScreenUtil.t(I18nKey.roleGroup)!,
                              info: item.userGroupId.name,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  child: Center(
                    child: Text(item.userId.name),
                  ),
                ),
              ],
            ),
          ),
          onHoverChild: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(minHeight: 72, minWidth: 170),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadow.withOpacity(0.16),
                    blurRadius: 16,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ScreenUtil.t(I18nKey.roleGroup)!,
                          style: TextStyle(
                              fontSize: 12, color: AppColor.dividerColor),
                        ),
                        Text(item.userId.name),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        tableCellText(
          title: item.userEmail,
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
        tableCellText(
          title: _displayEvent(item.event),
        ),
      ],
    );
  }

  String _displayEvent(String event) {
    String displayEvent = '';
    if (event == 'lock') {
      displayEvent = ScreenUtil.t(I18nKey.lock)!;
    }
    if (event == 'unlock') {
      displayEvent = ScreenUtil.t(I18nKey.unlock)!;
    }
    if (event == 'open') {
      displayEvent = ScreenUtil.t(I18nKey.openDoor)!;
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
                    selected: _eventType,
                    source: const ['lock', 'open', 'unlock'],
                    onChanged: (list) {
                      setState(() {
                        _eventType = list;
                        _fetchTableDataOnPage(1);
                      });
                    },
                    enableSearch: false,
                    searchHintText: ScreenUtil.t(I18nKey.search),
                    onDisplayedName: (value) {
                      if (value == 'lock') {
                        return ScreenUtil.t(I18nKey.lock)!;
                      } else if (value == 'unlock') {
                        return ScreenUtil.t(I18nKey.unlock)!;
                      } else {
                        return ScreenUtil.t(I18nKey.openDoor)!;
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

  _fetchTableDataOnPage(int page) {
    setState(() {
      _page = page;
      widget.onFetch(page, eventType: _eventType);
    });
  }
}
