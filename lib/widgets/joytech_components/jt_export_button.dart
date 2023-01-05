import 'package:flutter/material.dart';
import '../../main.dart';

class JTExportButton extends StatelessWidget {
  final bool enable;
  final Function()? onPressed;
  const JTExportButton({
    Key? key,
    required this.enable,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: enable
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.print_rounded,
              color: enable
                  ? Theme.of(context).primaryColor
                  : AppColor.dividerColor,
              size: 25,
            ),
            const SizedBox(width: 8),
            Text(
              ScreenUtil.t(I18nKey.export)!,
              style: enable
                  ? Theme.of(context).textTheme.bodyText1
                  : Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.dividerColor),
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
