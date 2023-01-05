import 'package:flutter/material.dart';
import '../../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../../../core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../../config/svg_constants.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../main.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';
import 'change_password.dart';

class Profile extends StatefulWidget {
  final AccountBloc accountBloc;
  final AsyncSnapshot<AccountModel> snapshot;
  final String route;
  const Profile({
    Key? key,
    required this.accountBloc,
    required this.snapshot,
    required this.route,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  EditAccountModel editModel = EditAccountModel.fromModel(null);
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  bool _isEdited = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  @override
  void initState() {
    JTToast.init(context);
    editModel = EditAccountModel.fromModel(widget.snapshot.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oldPasswordController.selection =
        TextSelection.collapsed(offset: oldPasswordController.text.length);
    newPasswordController.selection =
        TextSelection.collapsed(offset: newPasswordController.text.length);
    checkController.selection =
        TextSelection.collapsed(offset: checkController.text.length);
    return LayoutBuilder(
      builder: (context, size) {
        const double _commonPadding = 16;
        return Card(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              autovalidateMode: _autovalidate,
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: size.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ScreenUtil.t(I18nKey.profile)!,
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SizedBox(
                              width: 132,
                              height: 42,
                              child: _isEdited
                                  ? TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      child: Text(
                                        ScreenUtil.t(I18nKey.saveChange)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          _editUserInfo(
                                              editModel: editModel,
                                              id: widget.snapshot.data!.id);
                                        } else {
                                          setState(() {
                                            _autovalidate = AutovalidateMode
                                                .onUserInteraction;
                                          });
                                        }
                                      },
                                    )
                                  : TextButton.icon(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent),
                                      icon: const Icon(Icons.edit,
                                          color: Colors.black),
                                      label: Text(
                                        ScreenUtil.t(I18nKey.edit)!,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isEdited = true;
                                        });
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _renderError(
                    contentWidth: size.maxWidth,
                    commonPadding: _commonPadding,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 180,
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/logo.png",
                                width: 160,
                                height: 160,
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(vertical: 8.0),
                              //   child: SizedBox(
                              //     width: 160,
                              //     child: TextButton(
                              //       style: TextButton.styleFrom(
                              //         backgroundColor:
                              //             Theme.of(context).disabledColor,
                              //         shape: const StadiumBorder(),
                              //       ),
                              //       child: Text(
                              //         ScreenUtil.t(I18nKey.uploadImage)!,
                              //         style:
                              //             const TextStyle(color: Colors.black),
                              //       ),
                              //       onPressed: () {},
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  width: 160,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).disabledColor,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      ScreenUtil.t(I18nKey.changePassword)!,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          checkDialogPop(context);
                                          return ChangePassword(
                                            currentUser: widget.snapshot.data!,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _renderContent(
                        contentWidth: size.maxWidth - 96 - 180,
                        commonPadding: _commonPadding,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  checkDialogPop(BuildContext context) async {
    if (checkRoute(widget.route) != true) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  // Layout
  Widget _renderContent({
    required double contentWidth,
    required double commonPadding,
  }) {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    final disableStyle = Theme.of(context).textTheme.bodyText2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: commonPadding * 2),
      child: SizedBox(
        width: contentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: contentWidth,
              child: JTTitleTextFormField(
                title: ScreenUtil.t(I18nKey.fullName),
                titleStyle: disableStyle,
                enabled: _isEdited,
                decoration:
                    InputDecoration(hintText: ScreenUtil.t(I18nKey.fullName)),
                initialValue: editModel.fullName,
                style: normalStyle,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return ValidatorText.empty(
                        fieldName: ScreenUtil.t(I18nKey.fullName)!);
                  } else if (value.trim().length > 50) {
                    return ValidatorText.moreThan(
                      fieldName: ScreenUtil.t(I18nKey.fullName)!,
                      moreThan: 50,
                    );
                  } else if (value.trim().length < 5) {
                    return ValidatorText.atLeast(
                      fieldName: ScreenUtil.t(I18nKey.fullName)!,
                      atLeast: 5,
                    );
                  }
                  return null;
                },
                onSaved: (value) => editModel.fullName = value!.trim(),
              ),
            ),
            SizedBox(
              width: contentWidth,
              child: JTTitleTextFormField(
                title: 'Email',
                titleStyle: disableStyle,
                decoration: const InputDecoration(hintText: 'Email'),
                initialValue: editModel.email,
                enabled: false,
                style: normalStyle,
              ),
            ),
            SizedBox(
              width: contentWidth,
              child: JTTitleTextFormField(
                initialValue: editModel.phoneNumber,
                titleStyle: disableStyle,
                enabled: _isEdited,
                keyboardType: TextInputType.phone,
                title: ScreenUtil.t(I18nKey.phoneNumber),
                decoration: InputDecoration(
                    hintText: ScreenUtil.t(I18nKey.phoneNumber)),
                onSaved: (value) {
                  editModel.phoneNumber = value!.trim();
                },
                validator: (value) {
                  if (value!.isEmpty || value.trim().isEmpty) {
                    return ValidatorText.empty(
                        fieldName: ScreenUtil.t(I18nKey.phoneNumber)!);
                  }
                  String pattern =
                      r'^(\+843|\+845|\+847|\+848|\+849|\+841|03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return ScreenUtil.t(I18nKey.invalidPhoneNumber)!;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: contentWidth,
              child: JTTitleTextFormField(
                title: ScreenUtil.t(I18nKey.address),
                titleStyle: disableStyle,
                enabled: _isEdited,
                decoration:
                    InputDecoration(hintText: ScreenUtil.t(I18nKey.address)),
                initialValue: editModel.address,
                style: normalStyle,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return ValidatorText.empty(
                        fieldName: ScreenUtil.t(I18nKey.address)!);
                  } else if (value.trim().length > 300) {
                    return ValidatorText.moreThan(
                      fieldName: ScreenUtil.t(I18nKey.address)!,
                      moreThan: 300,
                    );
                  } else if (value.trim().length < 5) {
                    return ValidatorText.atLeast(
                      fieldName: ScreenUtil.t(I18nKey.address)!,
                      atLeast: 5,
                    );
                  }
                  return null;
                },
                onSaved: (value) => editModel.address = value!.trim(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                child: Text(
                  ScreenUtil.t(I18nKey.role)!.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).disabledColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Wrap(
                  children: [
                    _buildInfoItem(
                      svgIcon: SvgIcons.smartMeeting,
                      title: getPermission(widget.snapshot.data!),
                      subTitle: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildInfoItem({
    IconData? icon,
    required String title,
    required String subTitle,
    SvgIconData? svgIcon,
    double svgIconSize = 28,
  }) {
    return SizedBox(
      width: 146,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: svgIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgIcon(
                        svgIcon,
                        color: Theme.of(context).primaryColor,
                        size: svgIconSize,
                      ),
                    )
                  : Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _renderError({
    required double commonPadding,
    required double contentWidth,
  }) {
    if (_errorMessage.isNotEmpty) {
      return Container(
        height: 50,
        width: contentWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Theme.of(context).errorColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: commonPadding * 2),
          child: Padding(
            child: Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).errorColor),
            ),
            padding: EdgeInsets.all(commonPadding),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  // Actions
  _editUserInfo({
    required EditAccountModel editModel,
    required String id,
  }) async {
    widget.accountBloc.editProfile(editModel: editModel).then(
      (value) async {
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
        setState(() {
          _isEdited = false;
          _errorMessage = '';
          AuthenticationBlocController().authenticationBloc.add(GetUserData());
        });
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          _errorMessage = error.toString();
        });
      },
    );
  }
}
