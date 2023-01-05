import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final Widget child;
  const CenteredView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: child,
      ),
    );
  }
}
