import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_iot/main.dart';

class TableColumnDateTime extends StatelessWidget {
  final String? displayedFormat;
  final dynamic value;
  const TableColumnDateTime({
    Key? key,
    required this.value,
    this.displayedFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final format =
        displayedFormat ?? ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
    String _displayedValue = '';
    if (value is int) {
      if (value != 0) {
        final _dateTime = DateTime.fromMillisecondsSinceEpoch(value);
        final _dateTimeLocal = _dateTime.toLocal();
        _displayedValue = DateFormat(format).format(_dateTimeLocal);
      }
    } else if (value is String) {
      final _dateTime = DateTime.tryParse(value ?? '');
      final _dateTimeLocal = _dateTime!.toLocal();
      _displayedValue = DateFormat(format).format(_dateTimeLocal);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: Text(_displayedValue,),
    );
  }
}
