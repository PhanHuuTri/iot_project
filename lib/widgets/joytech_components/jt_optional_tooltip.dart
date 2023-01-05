import 'package:flutter/material.dart';

class JTOptionalTooltip extends StatelessWidget {
  final String? message;
  final Widget child;
  const JTOptionalTooltip({Key? key, this.message, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message != null && message!.isNotEmpty) {
      return Tooltip(
        message: message!,
        child: child,
      );
    }
    return child;
  }
}
