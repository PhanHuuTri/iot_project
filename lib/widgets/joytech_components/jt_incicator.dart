import 'package:flutter/material.dart';

class JTCircularProgressIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  const JTCircularProgressIndicator({
    Key? key,
    this.size = 44,
    required this.color,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch().copyWith(primary: color)),
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
