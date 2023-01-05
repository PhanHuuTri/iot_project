import 'package:flutter/material.dart';
import '../../main.dart';
import 'jt_text_field.dart';

class JTSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? borderColor;
  final Function()? onPressed;
  final Function(String)? onChanged;
  final double height;
  const JTSearchField({
    Key? key,
    this.controller,
    this.hintText,
    this.borderColor,
    this.onPressed,
    this.onChanged,
    this.height = 40,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return JTTitleTextFormField(
      height: height,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColor.buttonBackground,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        prefixIcon: Icon(
          Icons.search_outlined,
          size: 20,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.cancel,
            size: 16,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
          iconSize: 16,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          splashRadius: 16,
        ),
      ),
      style: Theme.of(context).textTheme.bodyText1,
      onChanged: onChanged,
    );
  }
}
