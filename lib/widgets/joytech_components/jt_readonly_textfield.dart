import 'package:flutter/material.dart';

import 'jt_form_input_header.dart';

class JTReadonlyTextField extends StatelessWidget {
  final List<Widget>? children;
  final String? title;
  final TextStyle? titleStyle;
  final double? fieldHeight;
  const JTReadonlyTextField({Key? key, 
    this.children = const <Widget>[],
    this.title,
    this.titleStyle,
    this.fieldHeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null && title!.isNotEmpty && titleStyle != null)
          JTFormInputHeader(
            child: Text(title!, style: titleStyle),
          ),
        Container(
          height: fieldHeight ?? 48,
          color: Theme.of(context).inputDecorationTheme.fillColor,
          child: Row(
            children: children!,
          ),
        ),
      ],
    );
  }
}
