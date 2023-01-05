import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/face_recog/models/face_user_model.dart';
import '../../../../../core/modules/face_recog/blocs/face_user/face_user_bloc.dart';
import '../../../../../main.dart';
import '../../../../../widgets/joytech_components/joytech_components.dart';

class EditUserRoles extends StatefulWidget {
  final FaceUserModel faceUserModel;
  final List<FaceRoleModel> faceRoles;
  final FaceUserBloc faceUserBloc;
  final Function() onFetch;
  const EditUserRoles({
    Key? key,
    required this.faceUserModel,
    required this.faceRoles,
    required this.faceUserBloc,
    required this.onFetch,
  }) : super(key: key);

  @override
  State<EditUserRoles> createState() => _EditUserRolesState();
}

class _EditUserRolesState extends State<EditUserRoles> {
  final _formKey = GlobalKey<FormState>();
  final double _dialogMaxWidth = 400;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  bool _processing = false;
  late EditFaceRoleModel editModel;

  @override
  void initState() {
    JTToast.init(context);
    editModel = EditFaceRoleModel.fromModel(widget.faceUserModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      const double _commonPadding = 16;
      const double _dialogWidth = 696.0;
      const double _dialogHeight = 228.0;
      return AlertDialog(
        scrollable: true,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _commonPadding,
                vertical: 20,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ScreenUtil.t(I18nKey.editUserRole)!,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const Divider(thickness: 0.25, height: 0.25),
          ],
        ),
        titleTextStyle: Theme.of(context).textTheme.headline4,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: _dialogWidth,
          constraints: const BoxConstraints(maxHeight: _dialogHeight),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _renderError(
                      contentWidth: _dialogWidth,
                      commonPadding: _commonPadding,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _renderContent(
                      contentWidth: _dialogWidth,
                      commonPadding: _commonPadding,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          Padding(
            child: _renderActions(contentWidth: _dialogWidth),
            padding: const EdgeInsets.symmetric(
              horizontal: _commonPadding / 2,
              vertical: _commonPadding,
            ),
          ),
        ],
      );
    });
  }

  Widget _renderContent({
    required double contentWidth,
    required double commonPadding,
  }) {
    final user = widget.faceUserModel;
    final email = user.email.isNotEmpty ? ' (${user.email})' : '';
    final title = user.name + email;

    List<Map<String, dynamic>> roleSource = [
      {'name': ScreenUtil.t(I18nKey.pick), 'value': '', 'isDefault': true},
    ];
    for (var role in widget.faceRoles) {
      roleSource.add(
        {'name': role.name, 'value': role.id},
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
          ),
        ),
        Divider(color: AppColor.buttonBackground),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            child: JTDropdownButtonFormField<String>(
              title: ScreenUtil.t(I18nKey.grantAccess),
              titleStyle: const TextStyle(
                color: AppColor.black,
                fontWeight: FontWeight.w500,
              ),
              defaultValue: editModel.id,
              dataSource: roleSource,
              decoration: InputDecoration(
                fillColor: AppColor.secondaryLight,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.secondaryLight,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  isDropDown = false;
                  editModel.id = newValue;
                  editModel.name = roleSource
                      .firstWhere((e) => e['value'] == newValue)['name'];
                });
              },
              onSaved: (newValue) {
                isDropDown = false;
              },
              onTap: () {
                isDropDown = true;
              },
            ),
          ),
        ),
      ],
    );
  }

  _renderActions({required double contentWidth}) {
    final children = _actions(contentWidth: contentWidth);
    if (contentWidth >= _dialogMaxWidth) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  _actions({required double contentWidth}) {
    return <Widget>[
      Container(
        constraints: const BoxConstraints(
          minHeight: 36,
          minWidth: 82,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).errorColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                ScreenUtil.t(I18nKey.cancel)!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      contentWidth >= _dialogMaxWidth
          ? const SizedBox(width: 16)
          : const SizedBox(),
      Container(
        constraints: const BoxConstraints(
          minHeight: 36,
          minWidth: 82,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          child: _processing
              ? JTCircularProgressIndicator(
                  size: 16,
                  strokeWidth: 2.0,
                  color: Theme.of(context).textTheme.button!.color!,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      ScreenUtil.t(I18nKey.saveChange)!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
          onPressed: _processing
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _editModel(
                      editModel: editModel,
                      id: widget.faceUserModel.userId,
                    );
                  } else {
                    setState(() {
                      _autovalidate = AutovalidateMode.onUserInteraction;
                    });
                  }
                },
        ),
      ),
    ];
  }

  Widget _renderError({
    required double contentWidth,
    required double commonPadding,
  }) {
    if (_errorMessage.isNotEmpty) {
      return SizedBox(
        height: 50,
        width: contentWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: commonPadding * 2),
          child: Container(
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
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).errorColor),
              ),
              padding: EdgeInsets.all(commonPadding),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  _editModel({
    required EditFaceRoleModel editModel,
    required String id,
  }) async {
    setState(() {
      _processing = true;
    });
    widget.faceUserBloc.editObject(editModel: editModel, id: id).then(
      (value) async {
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 400));
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
        widget.onFetch();
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _processing = false;
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          _processing = false;
          _errorMessage = error.toString();
        });
      },
    );
  }
}
