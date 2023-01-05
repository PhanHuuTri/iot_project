import 'package:flutter/material.dart';
import 'package:web_iot/widgets/joytech_components/jt_form_input_header.dart';

class JTCheckboxButton extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String enabledMessage;
  final String disabledMessage;
  final TextStyle? enabledStyle;
  final TextStyle? disabledStyle;
  final bool initialValue;
  final Function(bool?)? onChanged;
  const JTCheckboxButton({
    Key? key,
    this.title,
    this.titleStyle,
    this.initialValue = false,
    required this.enabledMessage,
    required this.disabledMessage,
    this.enabledStyle,
    this.disabledStyle,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isChecked = initialValue;
    if (title == null || title!.isEmpty) {
      return Container(
        child: CheckboxListTile(
          value: _isChecked,
          onChanged: onChanged,
          title: Text(
            _isChecked ? enabledMessage : disabledMessage,
            style: _isChecked
                ? enabledStyle ?? Theme.of(context).textTheme.button
                : disabledStyle ?? Theme.of(context).textTheme.bodyText2,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.only(right: 0.0, left: 0.0),
          activeColor: Theme.of(context).primaryColor,
          checkColor: Colors.white,
        ),
        constraints: const BoxConstraints(minHeight: 48),
      );
    } else {
      return Column(
        children: [
          JTFormInputHeader(
            child: Text(title!, style: titleStyle),
          ),
          Container(
            child: CheckboxListTile(
              value: _isChecked,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              title: Text(
                _isChecked ? enabledMessage : disabledMessage,
                style: _isChecked
                    ? enabledStyle ?? Theme.of(context).textTheme.button
                    : disabledStyle ?? Theme.of(context).textTheme.bodyText2,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(right: 0.0, left: 0.0),
              activeColor: Theme.of(context).primaryColor,
              checkColor: Colors.white,
            ),
            constraints: const BoxConstraints(minHeight: 48),
          ),
        ],
      );
    }
  }
}
