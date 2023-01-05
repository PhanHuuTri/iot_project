import 'package:web_iot/core/modules/user_management/blocs/account/account_bloc.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../../core/modules/user_management/blocs/role/role_bloc.dart';
import '../../../core/modules/user_management/models/account_model.dart';
import 'roles/role_create_screen.dart';
import 'roles/role_list.dart';
import 'user_list/user_list.dart';

class UserManagementScreen extends StatefulWidget {
  final int? tab;
  final String? id;
  const UserManagementScreen({
    Key? key,
    this.tab,
    this.id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _pageState = PageState();
  final int _limit = 10;
  final _accountBloc = AccountBloc();
  final _roleBloc = RoleBloc();
  final _userSearchController = TextEditingController();
  final _roleSearchController = TextEditingController();
  List<List<String>> listPermissionCodes = [];

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    _roleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: userManagementRoute,
      name: widget.tab != null ? I18nKey.userManagement : I18nKey.role,
      subName: _getSubName(),
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () => _fetchUserDataOnPage(userManagementIndex),
      child: FutureBuilder(
        future: _pageState.currentUser,
        builder: (context, AsyncSnapshot<AccountModel> snapshot) => PageContent(
          userSnapshot: snapshot,
          pageState: _pageState,
          onFetch: () => _fetchUserDataOnPage(userManagementIndex),
          route: userManagementRoute,
          child: LayoutBuilder(builder: (context, size) {
            if (snapshot.hasData) {
              if (widget.tab != null) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 16, 17),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTab(),
                          widget.tab == 0
                              ? UserList(
                                  accountBloc: _accountBloc,
                                  onFetch: _fetchUserDataOnPage,
                                  keyword: _userSearchController,
                                  route: userManagementRoute,
                                  currentUser: snapshot.data!,
                                )
                              : RoleList(
                                  roleBloc: _roleBloc,
                                  onFetch: _fetchRoleDataOnPage,
                                  keyword: _roleSearchController,
                                  route: roleRoute,
                                  currentUser: snapshot.data!,
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return RoleCreateEditScreen(id: widget.id);
              }
            } else {
              return const SizedBox();
            }
          }),
        ),
      ),
    );
  }

  String? _getSubName() {
    if (widget.tab != null) {
      if (widget.tab == 1) {
        return I18nKey.roleList;
      }
      return null;
    } else {
      if (widget.id != null) {
        return I18nKey.edit;
      } else {
        return I18nKey.createNew;
      }
    }
  }

  _changeTab(int tab) {
    if (tab == 0) {
      navigateTo(userManagementRoute);
    } else {
      navigateTo(roleRoute);
    }
  }

  Widget _buildTab() {
    final List<String> tabs = [
      ScreenUtil.t(I18nKey.account)!,
      ScreenUtil.t(I18nKey.roleList)!,
    ];
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++)
          Padding(
            padding: EdgeInsets.fromLTRB(i == 0 ? 0 : 8, 0, 8, 0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.0,
                    color: widget.tab == i ? AppColor.primary : AppColor.white,
                  ),
                ),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: widget.tab == i
                        ? AppColor.primary
                        : AppColor.dividerColor,
                  ),
                ),
                onPressed: () {
                  _changeTab(i);
                },
              ),
            ),
          ),
      ],
    );
  }

  _fetchUserDataOnPage(int page, {int? limit}) {
    userManagementIndex = page;
    userManagementSearchString = _userSearchController.text;
    Map<String, dynamic> params = {
      'limit': limit ?? _limit,
      'page': userManagementIndex,
      'search_string': userManagementSearchString,
    };
    _accountBloc.fetchAllData(params: params);
  }

  _fetchRoleDataOnPage(int page, {int? limit}) {
    roleIndex = page;
    roleSearchString = _roleSearchController.text;
    Map<String, dynamic> params = {
      'limit': limit ?? _limit,
      'page': roleIndex,
      'search_string': roleSearchString,
    };
    _roleBloc.fetchAllData(params: params);
  } 
}
