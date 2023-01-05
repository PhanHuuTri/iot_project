import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_iot/widgets/calendar_popup/time_picker_spinner.dart';
import '../../main.dart';
import 'custom_calendar.dart';

class CalendarPopupView extends StatefulWidget {
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final bool barrierDismissible;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime, DateTime)? onApplyClick;
  final double itemWidth;
  final double itemHeight;
  final EdgeInsetsGeometry contentPadding;
  const CalendarPopupView({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    this.onApplyClick,
    this.barrierDismissible = true,
    this.minimumDate,
    this.maximumDate,
    this.itemWidth = 36,
    this.itemHeight = 36,
    this.contentPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _CalendarPopupViewState createState() => _CalendarPopupViewState();
}

class _CalendarPopupViewState extends State<CalendarPopupView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  String _errorMessage = '';
  final scrollController = ScrollController();
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  final double dialogWidth = 873;
  final double contentHeight = 545;
  final double scrollEnableHeight = 680;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.barrierDismissible) {
              Navigator.pop(context);
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: dialogWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: AppColor.shadow, blurRadius: 16),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  ),
                  child: LayoutBuilder(builder: (context, size) {
                    return Scrollbar(
                      controller: scrollController,
                      thumbVisibility: size.maxHeight < scrollEnableHeight,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: dialogWidth,
                              height: contentHeight,
                              child: Row(
                                children: [
                                  buildDateTimeField(isStartDate: true),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 8),
                                    child: SizedBox(
                                      height: contentHeight,
                                      child: VerticalDivider(
                                        width: 1,
                                        color: AppColor.dividerColor,
                                      ),
                                    ),
                                  ),
                                  buildDateTimeField(isStartDate: false),
                                ],
                              ),
                            ),
                            if (_errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(
                                      color: Theme.of(context).errorColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      _errorMessage,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontStyle: FontStyle.italic,
                                              color:
                                                  Theme.of(context).errorColor),
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 32, 16, 16),
                              child: _actions(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validator() {
    _errorMessage = '';
    if (endDate!.isBefore(startDate!) ||
        endDate!.isAtSameMomentAs(startDate!)) {
      _errorMessage = ValidatorText.mustBeAfter(
        end: ScreenUtil.t(I18nKey.endTime)!,
        start: ScreenUtil.t(I18nKey.startTime)!,
      );
    }
  }

  Widget buildDateTimeField({required bool isStartDate}) {
    final calendarHeight = widget.itemHeight * 7 + 104;
    return SizedBox(
      width: dialogWidth / 2 - 0.5,
      child: Column(
        children: [
          SizedBox(
            height: calendarHeight,
            child: CustomCalendarView(
              itemWidth: widget.itemWidth,
              itemHeight: widget.itemHeight,
              minimumDate: widget.minimumDate,
              maximumDate: widget.maximumDate,
              initialDate:
                  isStartDate ? widget.initialStartDate : widget.initialEndDate,
              onChange: (DateTime dateData) {
                setState(() {
                  if (isStartDate) {
                    final date = DateTime(
                      dateData.year,
                      dateData.month,
                      dateData.day,
                      0,
                      0,
                    );
                    startDate = date;
                  } else {
                    final date = DateTime(
                      dateData.year,
                      dateData.month,
                      dateData.day,
                      23,
                      59,
                    );
                    endDate = date;
                  }
                  _validator();
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadow.withOpacity(0.16),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isStartDate
                            ? ScreenUtil.t(I18nKey.startTime)!
                            : ScreenUtil.t(I18nKey.endTime)!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isStartDate
                                  ? startDate != null
                                      ? ScreenUtil.t(I18nKey.from)! +
                                          ' ' +
                                          DateFormat('EEE, ' +
                                                  ScreenUtil.t(
                                                      I18nKey.formatDMY)!)
                                              .format(startDate!)
                                      : '--/-- '
                                  : endDate != null
                                      ? ScreenUtil.t(I18nKey.to)! +
                                          ' ' +
                                          DateFormat(
                                            'EEE, ' +
                                                ScreenUtil.t(
                                                    I18nKey.formatDMY)!,
                                          ).format(endDate!)
                                      : '--/-- ',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: TimePickerSpinner(
                                itemHeight: 36,
                                normalTextStyle: TextStyle(
                                    fontSize: 16, color: AppColor.dividerColor),
                                highlightedTextStyle: const TextStyle(
                                  fontSize: 16,
                                ),
                                time: isStartDate ? startDate : endDate,
                                onTimeChange: (dateTime) {
                                  setState(() {
                                    if (isStartDate) {
                                      DateTime tempStartDateTime = DateTime(
                                        startDate!.year,
                                        startDate!.month,
                                        startDate!.day,
                                        dateTime.hour,
                                        dateTime.minute,
                                        dateTime.second,
                                      );
                                      startDate = tempStartDateTime;
                                    } else {
                                      DateTime tempStartDateTime = DateTime(
                                        endDate!.year,
                                        endDate!.month,
                                        endDate!.day,
                                        dateTime.hour,
                                        dateTime.minute,
                                        dateTime.second,
                                      );
                                      endDate = tempStartDateTime;
                                    }
                                    _validator();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 36,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ScreenUtil.t(I18nKey.cancel)!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 36,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ScreenUtil.t(I18nKey.saveChange)!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
            onPressed: () {
              setState(() {
                if (endDate!.isBefore(startDate!)) {
                  _errorMessage = 'Enddate is before startdate';
                }
                if (endDate!.isAtSameMomentAs(startDate!)) {
                  _errorMessage = 'Enddate is at same moment as startdate';
                } else {
                  _errorMessage = '';
                  widget.onApplyClick!(startDate!, endDate!);
                  Navigator.of(context).pop();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
