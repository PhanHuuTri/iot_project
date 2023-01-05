import 'dart:math';
import 'package:web_iot/core/modules/user_management/blocs/account/account_bloc.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../core/modules/user_management/models/account_model.dart';
import '../../main.dart';
import 'package:flutter/material.dart';

class LanguageDialog extends StatefulWidget {
  final double dialogWidth;
  final AsyncSnapshot<AccountModel> snapshot;
  const LanguageDialog({
    Key? key,
    this.dialogWidth = 500,
    required this.snapshot,
  }) : super(key: key);
  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  final settinglistItemScroll = ScrollController();
  final _accountBloc = AccountBloc();
  TextEditingController feedbackController = TextEditingController();
  String _errorMessage = '';
  late EditAccountModel _editModel;
  final List<String> languages = [
    ScreenUtil.t(I18nKey.vietnamese)!,
    ScreenUtil.t(I18nKey.english)!,
    // ScreenUtil.t(I18nKey.thai)!,
  ];

  @override
  void initState() {
    _editModel = EditAccountModel.fromModel(widget.snapshot.data);
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return LayoutBuilder(
      builder: (context, size) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            width: widget.dialogWidth,
            height: min((supportedLocales.length + 1) * 60.0, 600),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      ScreenUtil.t(I18nKey.language)!,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ),
                const Divider(thickness: 0.5, height: 0.5),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: widget.dialogWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Theme.of(context).errorColor,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        child: Text(
                          _errorMessage,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).errorColor),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: supportedLocales.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 60,
                        child: Column(
                          children: [
                            InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 8,
                                      ),
                                      child: SizedBox(
                                          height: 50,
                                          child: Center(
                                              child: Text(languages[index]))),
                                    ),
                                    const Spacer(),
                                    _editModel.lang ==
                                            supportedLocales[index].languageCode
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 19,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _editModel.lang =
                                      supportedLocales[index].languageCode;
                                  _errorMessage = '';
                                });
                              },
                            ),
                            if (index < supportedLocales.length - 1)
                              const Divider(thickness: 0.1, height: 0.1),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(8),
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
            const SizedBox(width: 16),
            SizedBox(
              height: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    ScreenUtil.t(I18nKey.saveChange)!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  _changeUserLang(editModel: _editModel);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _changeUserLang({required EditAccountModel editModel}) {
    _accountBloc.editProfile(editModel: editModel).then(
      (value) {
        AuthenticationBlocController().authenticationBloc.add(
              UserLanguage(lang: value.lang),
            );
        Navigator.of(context).pop();
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          logDebug(error);
          _errorMessage = error.toString();
        });
      },
    );
  }
}
