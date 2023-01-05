import 'package:web_iot/core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'profile_list.dart';
import '../../../../core/modules/user_management/models/account_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _pageState = PageState();
  final _accountBloc = AccountBloc();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: userProfileRoute,
      name: I18nKey.userProfile,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () => () {},
      child: FutureBuilder(
          future: _pageState.currentUser,
          builder: (context, AsyncSnapshot<AccountModel> userSnapshot) {
            return PageContent(
              userSnapshot: userSnapshot,
              pageState: _pageState,
              onFetch: () => () {},
              route: userProfileRoute,
              child: FutureBuilder(
                  future: _accountBloc.getProfile(),
                  builder: (context, AsyncSnapshot<AccountModel> snapshot) {
                    if (snapshot.hasData) {
                      snapshot.data!.password = userSnapshot.data!.password;
                      return Profile(
                        accountBloc: _accountBloc,
                        snapshot: snapshot,
                        route: userProfileRoute,
                      );
                    }
                    return const Card();
                  }),
            );
          }),
    );
  }
}
