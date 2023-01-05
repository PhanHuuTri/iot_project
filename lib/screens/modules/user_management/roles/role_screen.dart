import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import '../../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../../../core/modules/user_management/blocs/role/role_bloc.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import 'role_list.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final _pageState = PageState();
  final int _limit = 10;
  final _roleBloc = RoleBloc();
  final _keywordController = TextEditingController();
  List<List<String>> listPermissionCodes = [];

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    _fetchDataOnPage(roleIndex);
    super.initState();
  }

  @override
  void dispose() {
    _roleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: userManagementRoute,
      name: I18nKey.userManagement,
      subName: I18nKey.roleList,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () => _fetchDataOnPage(roleIndex),
      child: FutureBuilder(
        future: _pageState.currentUser,
        builder: (context, AsyncSnapshot<AccountModel> snapshot) => PageContent(
          userSnapshot: snapshot,
          pageState: _pageState,
          onFetch: () => _fetchDataOnPage(roleIndex),
          route: userManagementRoute,
          child: LayoutBuilder(builder: (context, size) {
            if (snapshot.hasData) {
              return RoleList(
                roleBloc: _roleBloc,
                onFetch: _fetchDataOnPage,
                keyword: _keywordController,
                route: roleRoute,
                currentUser: snapshot.data!,
              );
            } else {
              return const SizedBox();
            }
          }),
        ),
      ),
    );
  }

  _fetchDataOnPage(int page) {
    roleIndex = page;
    roleSearchString = _keywordController.text;
    Map<String, dynamic> params = {
      'limit': _limit,
      'page': roleIndex,
      'search_string': roleSearchString,
    };
    _roleBloc.fetchAllData(params: params);
  }
}
