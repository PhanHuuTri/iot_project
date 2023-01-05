import 'package:flutter/material.dart';
import '../../main.dart';

class ConfirmExportDialog extends StatefulWidget {
  final Function()? onPressed;
  const ConfirmExportDialog({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<ConfirmExportDialog> createState() => _ConfirmExportDialogState();
}

class _ConfirmExportDialogState extends State<ConfirmExportDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(ScreenUtil.t(I18nKey.confirm)! + '!'),
      titleTextStyle:
          Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black),
      content: Text(
        ScreenUtil.t(I18nKey.confirmExport)!,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: [
        SizedBox(
          height: 36,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ScreenUtil.t(I18nKey.cancel)!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(
          height: 36,
          child: TextButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ScreenUtil.t(I18nKey.yes)!,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onPressed!();
            },
          ),
        ),
      ],
    );
  }
}
