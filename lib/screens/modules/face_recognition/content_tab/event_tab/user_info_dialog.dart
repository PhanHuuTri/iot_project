import 'package:flutter/material.dart';
import '../../../../../main.dart';

class UserInfoDialog extends StatefulWidget {
  final List<UserInfoField> userInfos;
  const UserInfoDialog({Key? key, required this.userInfos}) : super(key: key);

  @override
  State<UserInfoDialog> createState() => _UserInfoDialogState();
}

class _UserInfoDialogState extends State<UserInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 431,
            constraints: const BoxConstraints(minHeight: 229),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    ScreenUtil.t(I18nKey.faceRecoUserInfo)!,
                    style: const TextStyle(
                      color: AppColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Divider(thickness: 0.5, height: 0.5),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/logo.png",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 431 - 80 - 32 - 24,
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          children: [
                            for (var userInfo in widget.userInfos)
                              _buildInfoField(
                                header: userInfo.fieldHeader,
                                title: userInfo.info,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 36,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColor.primary,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              ScreenUtil.t(I18nKey.close)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoField({
    required String header,
    required String title,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 34,
        minWidth: 133,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontSize: 12, color: AppColor.dividerColor),
          ),
          Text(title),
        ],
      ),
    );
  }
}

class UserInfoField {
  final String fieldHeader;
  final String info;
  UserInfoField({
    required this.fieldHeader,
    required this.info,
  });
}
