import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_iot/config/permissions_code.dart';
import 'package:web_iot/core/modules/user_management/models/role_model.dart';
import 'package:web_iot/themes/jt_colors.dart';
import 'package:web_iot/themes/jt_theme.dart';
import '../../../../core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../../widgets/data_table/table_component.dart';
import '../../../../widgets/data_table/table_pagination.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';
import '../../../../widgets/search_field.dart';
import '../../../../core/base/blocs/block_state.dart';
import '../../../../core/modules/user_management/blocs/role/role_bloc.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../main.dart';
import '../../../../widgets/table/dynamic_table.dart';
import 'create_user_dialog.dart';
import 'edit_user_dialog.dart';

class UserList extends StatefulWidget {
  final AccountBloc accountBloc;
  final Function(int, {int? limit}) onFetch;
  final TextEditingController keyword;
  final String route;
  final AccountModel currentUser;

  const UserList({
    Key? key,
    required this.accountBloc,
    required this.onFetch,
    required this.keyword,
    required this.route,
    required this.currentUser,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final _roleBloc = RoleBloc();
  int _page = 0;
  int _limit = 10;
  int _count = 0;
  final columnSpacing = 50.0;
  bool _allowCreate = false;
  bool _allowEdit = false;
  bool _allowDelete = false;

  @override
  void initState() {
    widget.onFetch(1, limit: _limit);
    _roleBloc.getAllRole(params: {});
    _getPerrmisson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildActionsField(),
            _buildTable(),
          ],
        );
      },
    );
  }

  Widget _buildActionsField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              if (_allowCreate)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.add_circle_outline_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      label: Center(
                        child: Text(
                          ScreenUtil.t(I18nKey.createNew)!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      onPressed: () => _showCreatePopup(),
                    ),
                  ),
                ),
              Expanded(
                child: SizedBox(
                  height: 47,
                  child: SearchField(
                    title: ScreenUtil.t(I18nKey.searchAccountPhoneNumber),
                    controller: widget.keyword,
                    onFetch: () {
                      widget.onFetch(1, limit: _limit);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(ScreenUtil.t(I18nKey.itemsPerPage)!),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: JTDropdownButtonFormField<int>(
                height: 34,
                width: 60,
                defaultValue: 10,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 8, 0),
                ),
                dataSource: const [
                  {'name': '10', 'value': 10},
                  {'name': '15', 'value': 15},
                  {'name': '20', 'value': 20},
                ],
                validator: (value) {
                  return null;
                },
                onChanged: (newValue) {
                  setState(() {
                    _limit = newValue;
                    widget.onFetch(1, limit: _limit);
                    isDropDown = false;
                  });
                },
                onSaved: (newValue) {
                  _limit = newValue!;
                  widget.onFetch(1, limit: _limit);
                  isDropDown = false;
                },
                onTap: () {
                  isDropDown = true;
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTable() {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
        width: 60,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.fullName)!,
        width: 250,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.role)!,
        width: 120,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.permission)!,
        width: 250,
        isConstant: true,
      ),
      TableHeader(
        title: 'Email',
        width: 250,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.phoneNumber)!,
        width: 130,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.action)!,
        width: 150,
        isConstant: true,
      ),
    ];

    return Stack(
      children: [
        StreamBuilder(
          stream: widget.accountBloc.allData,
          builder:
              (context, AsyncSnapshot<ApiResponse<AccountListModel>> snapshot) {
            if (snapshot.hasData) {
              final accounts = snapshot.data!.model!.records;
              final meta = snapshot.data!.model!.meta;
              _page = meta.page;
              _count = accounts.length;
              
               return StreamBuilder(
                  stream: _roleBloc.allRole,
                  builder: (context, AsyncSnapshot<ListRoleModel> snapshot) {
                    if (snapshot.hasData) {
                      final roles = snapshot.data!.records;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: LayoutBuilder(
                              builder: (context, size) {
                                return DynamicTable(
                                  columnWidthRatio: tableHeaders,
                                  numberOfRows: accounts.length,
                                  rowBuilder: (index) => _rowFor(
                                    roles: roles,
                                    item: accounts[index],
                                    index: index,
                                    meta: meta,
                                  ),
                                  hasBodyData: true,
                                  tableBorder: Border.all(
                                      color: JTColors.black, width: 1),
                                  headerBorder: TableBorder(
                                    bottom: BorderSide(
                                        color: JTColors.noticeBackground),
                                  ),
                                  headerStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: JTColors.black,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  bodyBorder: TableBorder(
                                    horizontalInside: BorderSide(
                                      color: JTColors.noticeBackground,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (accounts.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(ScreenUtil.t(I18nKey.noData)!),
                              ),
                            ),
                          TablePagination(
                            onFetch: (page) {
                              widget.onFetch(page, limit: _limit);
                            },
                            pagination: meta,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: snapshot.error.toString().trim() ==
                                'request timeout'
                            ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
                            : Text(snapshot.error.toString()),
                      );
                    }
                    return const SizedBox();
                  });
            
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: snapshot.error.toString().trim() == 'request timeout'
                    ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
                    : Text(snapshot.error.toString()),
              );
            }
            return const SizedBox();
          },
        ),
        StreamBuilder(
          stream: widget.accountBloc.allDataState,
          builder: (context, state) {
            if (!state.hasData || state.data == BlocState.fetching) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: JTCircularProgressIndicator(
                    size: 24,
                    strokeWidth: 2.0,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  TableRow _rowFor({
    required AccountModel item,
    required List<RoleModel> roles,
    required Paging meta,
    required int index,
  }) {
    final recordOffset = meta.recordOffset;
    final notAllowActionToAdmin = widget.currentUser.isAdmin && item.isAdmin ||
        widget.currentUser.isAdmin && item.isSuperadmin;
    final allowEditAdmin = !(widget.currentUser.isAdmin && item.isAdmin ||
        widget.currentUser.isAdmin && item.isSuperadmin);
    return TableRow(
      children: [
        tableCellText(
            title: '${recordOffset + index + 1}', alignment: Alignment.center),
        tableCellText(
          title: item.fullName,
        ),
        tableCellText(
          title: getPermission(item),
        ),
        tableCellText(
          child: _buildChip(
            roles: roles,
            user: item,
            allowEdit: allowEditAdmin,
          ),
        ),
        tableCellText(title: item.email),
        tableCellText(
          title: item.phoneNumber,
        ),
        if (_allowEdit || _allowDelete)
          tableCellText(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_allowEdit)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 4, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:notAllowActionToAdmin
                                ? AppColor.dividerColor
                                : AppColor.primary,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextButton(
                          child: Icon(
                            Icons.edit,
                            color:notAllowActionToAdmin
                                ? AppColor.dividerColor
                                : AppColor.primary,
                          ),
                          style: TextButton.styleFrom(
                            fixedSize: const Size(40, 40),
                            backgroundColor: Colors.white,
                          ),
                          onPressed:!notAllowActionToAdmin
                              ? () {
                                  _showEdit(accountModel: item);
                                }
                              : null,
                        ),
                      ),
                    ),
                  if (_allowDelete)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 4, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: notAllowActionToAdmin
                                ? AppColor.dividerColor
                                : AppColor.primary,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextButton(
                          child: Icon(
                            Icons.delete,
                            color: notAllowActionToAdmin
                                ? AppColor.dividerColor
                                : AppColor.primary,
                          ),
                          style: TextButton.styleFrom(
                            fixedSize: const Size(40, 40),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: !notAllowActionToAdmin
                              ? () {
                                  _confirmDelete(id: item.id);
                                }
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildChip({
    required AccountModel user,
    required List<RoleModel> roles,
    required bool allowEdit,
  }) {
    final userRoles = roles.where((e) {
      return user.roles.map((e) => e.id).toList().contains(e.id);
    }).toList();
    final editModel = EditAccountModel.fromModel(user);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var role in userRoles)
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: JTColors.buttonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        role.name,
                        style: JTTextStyle.bodyText1(color: JTColors.white),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: allowEdit
                        ? () {
                            setState(() {
                              userRoles.remove(role);
                              editModel.roles.removeWhere((e) => e == role.id);
                              logDebug(userRoles.length);
                              _editModel(
                                editModel: editModel,
                                id: user.id,
                              );
                            });
                          }
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                      child: Icon(
                        Icons.close,
                        color: JTColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  _editModel({
    required EditAccountModel editModel,
    required String id,
  }) async {
    widget.accountBloc.editObject(editModel: editModel, id: id).then(
      (value) async {
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 400));
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
        widget.onFetch(_count == 1 ? max(_page - 1, 1) : _page, limit: _limit);
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        logDebug(
            'errorMessage: ${error.errorMessage}\nerrorCode: ${error.errorCode}');
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          logDebug(error.toString());
        });
      },
    );
  }

  _getPerrmisson() {
    final listPermissionCodes = widget.currentUser.roles
        .map((e) => e.modules
            .firstWhere((e) => e.name == 'USER_MANAGEMENT')
            .permissions
            .map((e) => e.permissionCode)
            .toList())
        .toList();
    if (widget.currentUser.isSuperadmin) {
      _allowCreate = true;
      _allowEdit = true;
      _allowDelete = true;
    } else {
      for (var permissionCodes in listPermissionCodes) {
        setState(() {
          if (permissionCodes
              .contains(PermissionsCode.userManagementAllRoles)) {
            _allowCreate = true;
            _allowEdit = true;
            _allowDelete = true;
          }
          if (permissionCodes
              .contains(PermissionsCode.userManagementManageUser)) {
            _allowCreate = true;
            _allowEdit = true;
            _allowDelete = true;
          }
        });
      }
    }
  }

  checkDialogPop(BuildContext context) async {
    if (checkRoute(widget.route) != true) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  _showCreatePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        checkDialogPop(context);
        return CreateUserDialog(
          accountBloc: widget.accountBloc,
          roleBloc: _roleBloc,
          onFetch: () {
            widget.onFetch(_page, limit: _limit);
          },
        );
      },
    );
  }

  _showEdit({required AccountModel accountModel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        checkDialogPop(context);
        return EditUserDialog(
          accountBloc: widget.accountBloc,
          onFetch: () {
            widget.onFetch(_page, limit: _limit);
          },
          accountModel: accountModel,
          roleBloc: _roleBloc,
        );
      },
    );
  }

  _confirmDelete({
    required String id,
  }) {
    final _focusNode = FocusNode();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        checkDialogPop(context);
        FocusScope.of(context).requestFocus(_focusNode);
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (RawKeyEvent event) {
            setState(() {
              if (event.logicalKey == LogicalKeyboardKey.enter) {
                Navigator.of(context).pop();
                _deleteObjectById(id: id);
              }
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.of(context).pop();
              }
            });
          },
          child: AlertDialog(
            title: Text(ScreenUtil.t(I18nKey.confirm)! + '!'),
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
            content: Text(
              ScreenUtil.t(I18nKey.areYouSureYouWantToDelete)! +
                  ' ' +
                  ScreenUtil.t(I18nKey.thisUser)!.toLowerCase() +
                  '?',
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
                    _deleteObjectById(id: id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _deleteObjectById({
    required String id,
  }) {
    widget.accountBloc.deleteObject(id: id).then((model) async {
      // Delete successfully
      // a simulated delay
      await Future.delayed(const Duration(milliseconds: 400));
      // Refresh the page
      widget.onFetch(_count == 1 ? max(_page - 1, 1) : _page, limit: _limit);
      // Toasting a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(ScreenUtil.t(I18nKey.deleted)! + ' ${model.email}.')),
      );
    }).catchError((e, stacktrace) async {
      // Failed to delete account
      // a simulated delay
      await Future.delayed(const Duration(milliseconds: 400));
      logDebug(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ScreenUtil.t(I18nKey.errorWhileDelete)!),
        ),
      );
    });
  }
}
