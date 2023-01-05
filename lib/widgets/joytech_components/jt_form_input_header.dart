import 'package:flutter/material.dart';

class JTFormInputHeader extends StatelessWidget {
  final Widget child;
  const JTFormInputHeader({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 2.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }
}
