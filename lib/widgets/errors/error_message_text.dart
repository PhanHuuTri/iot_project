import 'package:flutter/material.dart';
import 'package:web_iot/config/svg_constants.dart';

class ErrorMessageText extends StatelessWidget {
  final IconData? icon;
  final String message;
  final SvgIconData? svgIcon;
  const ErrorMessageText({
    Key? key,
    this.icon,
    required this.message,
    this.svgIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      child: Column(
        children: [
          svgIcon != null
              ? SvgIcon(
                  svgIcon!,
                  size: 120,
                  color: Theme.of(context).iconTheme.color,
                )
              : Icon(
                  icon ?? Icons.report_gmailerrorred_outlined,
                  size: 120,
                ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              message,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ],
      ),
    );
  }
}
