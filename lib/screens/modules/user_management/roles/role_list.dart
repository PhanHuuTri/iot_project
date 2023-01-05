import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_iot/core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../../config/permissions_code.dart';
import '../../../../core/base/blocs/block_state.dart';
import '../../../../core/modules/user_management/blocs/role/role_bloc.dart';
import 'package:web_iot/widgets/data_table/data_tabe_jt.dart';
import 'package:web_iot/widgets/data_table/table_pagination.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import 'package:web_iot/widgets/search_field.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../core/modules/user_management/models/role_model.dart';
import '../../../../main.dart';
import '../../../../routes/route_names.dart';
import '../../../../widgets/data_table/table_component.dart';
import '../../../../widgets/table_columns/table_column_date_time.dart';

class RoleList extends StatefulWidget {
  final RoleBloc roleBloc;
  final Function(int) onFetch;
  final TextEditingController keyword;
  final String route;
  final AccountModel currentUser;

  const RoleList({
    Key? key,
    required this.roleBloc,
    required this.onFetch,
    required this.keyword,
    required this.route,
    required this.currentUser,
  }) : super(key: key);

  @override
  _RoleListState createState() => _RoleListState();
}

class _RoleListState extends State<RoleList> {
  int _page = 0;
  int _count = 0;
  final double columnSpacing = 50;
  final _accountBloc = AccountBloc();
  bool _allowCreate = false;
  bool _allowEdit = false;
  bool _allowDelete = false;

  @override
  void initState() {
    widget.onFetch(1);
    _getPerrmisson();
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    super.dispose();
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
            Padding(
              padding: const EdgeInsets.only(top: 16),
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
                          onPressed: () => navigateTo(createRoleRoute),
                        ),
                      ),
                    ),
                  Expanded(
                    child: SizedBox(
                      height: 47,
                      child: SearchField(
                        title: ScreenUtil.t(I18nKey.searchRole),
                        controller: widget.keyword,
                        onFetch: () {
                          widget.onFetch(1);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                StreamBuilder(
                  stream: widget.roleBloc.allData,
                  builder: (context, AsyncSnapshot<RoleListModel> snapshot) {
                    if (snapshot.hasData) {
                      final roles = snapshot.data!.records;
                      final meta = snapshot.data!.meta;
                      _page = meta.page;
                      _count = roles.length;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: LayoutBuilder(builder: (context, size) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: DataTableJT(
                                  tableColumns: _buildTableColumns(size: size),
                                  tableRows:
                                      _buildTableRows(roles: roles, meta: meta),
                                ),
                              );
                            }),
                          ),
                          if (roles.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(ScreenUtil.t(I18nKey.noData)!),
                              ),
                            ),
                          TablePagination(
                            onFetch: widget.onFetch,
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
                  },
                ),
                StreamBuilder(
                  stream: widget.roleBloc.allDataState,
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
                )
              ],
            ),
          ],
        );
      },
    );
  }

  List<DataColumn> _buildTableColumns({required BoxConstraints size}) {
    final List<TableHeader> tableHeaders = [
      TableHeader(
          title: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
          width: 45,
          isConstant: true),
      TableHeader(title: ScreenUtil.t(I18nKey.roleName)!, width: 300),
      TableHeader(title: ScreenUtil.t(I18nKey.module)!, width: 300),
      TableHeader(
          title: ScreenUtil.t(I18nKey.dateCreated)!,
          width: 220,
          isConstant: true),
      TableHeader(
          title: ScreenUtil.t(I18nKey.dateUpdated)!,
          width: 220,
          isConstant: true),
      TableHeader(
          title: ScreenUtil.t(I18nKey.action)!, width: 130, isConstant: true),
    ];
    double totalUnits = 0;
    double totalConstant = 0;
    if (!_allowEdit && !_allowDelete) {
      tableHeaders.removeWhere((e) => e.title == ScreenUtil.t(I18nKey.action)!);
    }
    for (var item in tableHeaders) {
      totalUnits += item.isConstant ? 0 : item.width;
    }
    final width = size.maxWidth;
    var unit = ((width - totalConstant - columnSpacing) / totalUnits);

    return List.generate(tableHeaders.length, (i) {
      final item = tableHeaders[i];
      final itemAlignment =
          item.title == ScreenUtil.t(I18nKey.no)!.toUpperCase()
              ? Alignment.center
              : Alignment.centerLeft;

      return DataColumn(
        label: SizedBox(
          width: item.isConstant
              ? item.width + columnSpacing
              : max(unit * item.width / 2, item.width) + columnSpacing,
          child: Align(
            alignment: itemAlignment,
            child: Padding(
              padding: itemAlignment != Alignment.centerLeft
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<List<DataCell>> _buildTableRows(
      {required List<RoleModel> roles, required Paging meta}) {
    return List.generate(roles.length, (i) {
      final item = roles[i];
      final recordOffset = meta.recordOffset;

      return <DataCell>[
        rowCellData(
            title: '${recordOffset + i + 1}', alignment: Alignment.center),
        rowCellData(
          title: item.name,
        ),
        rowCellData(
          child: Wrap(
            children: [
              for (var module in item.modules)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _displayModules(module.name),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        rowCellData(
          child: TableColumnDateTime(
            value: item.createdTime,
            displayedFormat: ScreenUtil.t(I18nKey.formatDMY)!,
          ),
        ),
        rowCellData(
          child: TableColumnDateTime(
            value: item.updatedTime,
            displayedFormat: ScreenUtil.t(I18nKey.formatDMY)!,
          ),
        ),
        if (_allowEdit || _allowDelete)
          rowCellData(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_allowEdit)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextButton(
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                      style: TextButton.styleFrom(
                        fixedSize: const Size(40, 40),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        navigateTo(editRoleRoute + '/' + item.id);
                      },
                    ),
                  ),
                if (_allowDelete)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextButton(
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor,
                      ),
                      style: TextButton.styleFrom(
                        fixedSize: const Size(40, 40),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _confirmDelete(id: item.id);
                      },
                    ),
                  ),
              ],
            ),
          ),
      ];
    });
  }

  String _displayModules(String moduleName) {
    if (moduleName == 'USER_MANAGEMENT') {
      return ScreenUtil.t(I18nKey.userManagement)!;
    }
    if (moduleName == 'SMART_PARKING') {
      return ScreenUtil.t(I18nKey.smartParking)!;
    }
    if (moduleName == 'FACE_RECOGNITION') {
      return ScreenUtil.t(I18nKey.faceRecognition)!;
    } else {
      return '';
    }
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
              .contains(PermissionsCode.userManagementManageRole)) {
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
                  ScreenUtil.t(I18nKey.thisRole)!.toLowerCase() +
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
    widget.roleBloc.deleteObject(id: id).then((delStore) async {
      // Delete successfully
      // a simulated delay
      await Future.delayed(const Duration(milliseconds: 400));
      // Refresh the page
      widget.onFetch(_count == 1 ? max(_page - 1, 1) : _page);
      // Toasting a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(ScreenUtil.t(I18nKey.deleted)! + ' ${delStore.name}.')),
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
