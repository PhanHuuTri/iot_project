import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? error;
  final double padding;

  const ErrorMessage({Key? key, this.error, required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error != null && error!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Theme.of(context).errorColor,
            width: 1,
          ),
        ),
        child: Padding(
          child: Text(
            error!,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).errorColor),
          ),
          padding: EdgeInsets.all(padding),
        ),
      );
    }
    return const SizedBox();
  }
}
