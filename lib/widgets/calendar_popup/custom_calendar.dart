import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../main.dart';

class CustomCalendarView extends StatefulWidget {
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? initialDate;
  // final DateTime? initialEndDate;
  final double itemWidth;
  final double itemHeight;

  const CustomCalendarView({
    Key? key,
    this.initialDate,
    // this.initialEndDate,
    this.onChange,
    this.minimumDate,
    this.maximumDate,
    this.itemWidth = 36,
    this.itemHeight = 36,
  }) : super(key: key);

  final Function(DateTime)? onChange;

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialDate != null) {
      startDate = widget.initialDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
          child: Row(
            children: <Widget>[
              _headerButton(
                icon: Icons.keyboard_arrow_left,
                onTap: () {
                  setState(() {
                    currentMonthDate = DateTime(
                        currentMonthDate.year, currentMonthDate.month, 0);
                    setListOfDate(currentMonthDate);
                  });
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('MMMM, yyyy').format(currentMonthDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              _headerButton(
                icon: Icons.keyboard_arrow_right,
                onTap: () {
                  setState(() {
                    currentMonthDate = DateTime(
                        currentMonthDate.year, currentMonthDate.month + 2, 0);
                    setListOfDate(currentMonthDate);
                  });
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getDaysNameUI(),
        ),
        Column(
          children: getDaysNoUI(),
        ),
      ],
    );
  }

  Widget _headerButton({
    Function()? onTap,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: AppColor.dividerColor,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            onTap: onTap,
            child: Icon(
              icon,
              color: AppColor.dividerColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Padding(
          padding: i == 0
              ? const EdgeInsets.fromLTRB(0, 4, 8, 4)
              : i == 6
                  ? const EdgeInsets.fromLTRB(8, 4, 0, 4)
                  : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: SizedBox(
            width: widget.itemWidth,
            height: widget.itemHeight,
            child: Center(
              child: Text(
                DateFormat('EEE').format(dateList[i]),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Padding(
            padding: i == 0
                ? const EdgeInsets.fromLTRB(0, 0, 8, 0)
                : i == 6
                    ? const EdgeInsets.fromLTRB(8, 0, 0, 0)
                    : const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: widget.itemWidth,
              height: widget.itemHeight,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      child: Container(
                        decoration: BoxDecoration(
                            color: startDate != null
                                ? getIsItStartAndEndDate(date)
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4)
                                    : Colors.transparent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        onTap: () {
                          if (widget.minimumDate != null &&
                              widget.maximumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isAfter(newminimumDate) &&
                                date.isBefore(newmaximumDate)) {
                              onDateClick(date);
                            }
                          } else if (widget.minimumDate != null) {
                            final DateTime newminimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1);
                            if (date.isAfter(newminimumDate)) {
                              onDateClick(date);
                            }
                          } else if (widget.maximumDate != null) {
                            final DateTime newmaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1);
                            if (date.isBefore(newmaximumDate)) {
                              onDateClick(date);
                            }
                          } else {
                            onDateClick(date);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: getIsItStartAndEndDate(date)
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                              border: Border.all(
                                color: DateTime.now().day == date.day &&
                                        DateTime.now().month == date.month &&
                                        DateTime.now().year == date.year
                                    ? getIsInRange(date)
                                        ? Colors.white
                                        : Theme.of(context).primaryColor
                                    : Colors.transparent,
                              )),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: getIsItStartAndEndDate(date)
                                    ? Colors.white
                                    : currentMonthDate.month == date.month
                                        ? Colors.black
                                        : AppColor.dividerColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    startDate = date;
    setState(() {
      try {
        widget.onChange!(startDate!);
      } catch (_) {}
    });
  }
}
