import 'package:flutter/material.dart';
import 'jt_form_input_header.dart';

class JTDropdownButtonFormField<T> extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;
  final List<Map<String, dynamic>> dataSource;
  final T defaultValue;
  final void Function(T)? onChanged;
  final void Function()? onTap;
  final double? width;
  final double? height;
  final InputDecoration? decoration;

  const JTDropdownButtonFormField({
    Key? key,
    this.title,
    this.titleStyle,
    required this.defaultValue,
    required this.dataSource,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.onTap,
    this.width ,
    this.height,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T _displayedValue = defaultValue;
    if (_displayedValue == null) {
      // Get the first value of the `dataSource`
      if (dataSource.isEmpty) {
        return const Text('DataSource must not be empty');
      }
      _displayedValue = dataSource[0]['name'];
    }
    if (_displayedValue == null) {
      return const Text('Could not find the default value');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null && title!.isNotEmpty && titleStyle != null)
          JTFormInputHeader(
            child: Text(
              title!,
              style: titleStyle,
            ),
          ),
        SizedBox(
          width: width,
          height: height,
          child: DropdownButtonFormField<T>(
            isExpanded: true,
            decoration: decoration,
            value: _displayedValue,
            iconSize: 16,
            elevation: 16,
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: onChanged == null
                  ? Theme.of(context).textTheme.bodyText2!.color
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
            style: onChanged == null
                ? Theme.of(context).textTheme.bodyText2
                : Theme.of(context).textTheme.bodyText1,
            onTap: onTap,
            onChanged:  (newValue) {
                    onChanged!(newValue!);
                  },
            validator: validator,
            onSaved: onSaved,
            items: dataSource
                .map<DropdownMenuItem<T>>((Map<String, dynamic> value) {
              final isDefault = value['isDefault'] ?? false;
              return DropdownMenuItem<T>(
                value: value['value'] as T,
                child: Text(
                  value['name'],
                  style: isDefault || onChanged == null
                      ? Theme.of(context).textTheme.bodyText2!
                      : Theme.of(context).textTheme.bodyText1,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
