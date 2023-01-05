import 'package:web_iot/routes/route_names.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_iot/screens/layout_template/sidebar_scaffold.dart';
import 'package:web_iot/widgets/center_view/center_view.dart';
import 'package:web_iot/widgets/joytech_components/jt_incicator.dart';
import '../../core/base/blocs/block_state.dart';
import '../../core/modules/user_management/models/account_model.dart';

class PageTemplate extends StatelessWidget {
  final String route;
  final String? subRoute;
  final String name;
  final String? subName;
  final Widget child;
  final Widget? navigate;
  final Stream<BlocState>? stream;
  final PageState? pageState;
  final void Function(AccountModel) onUserFetched;
  final void Function() onFetch;

  PageTemplate({
    Key? key,
    required this.route,
    required this.name,
    required this.child,
    this.subRoute,
    this.navigate,
    this.subName,
    this.stream,
    this.pageState,
    required this.onUserFetched,
    required this.onFetch,
  }) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SidebarScaffold(
      key: globalKey,
      route: route,
      subRoute: subRoute,
      onFetch: onFetch,
      body: CenteredView(
        child: Container(
          padding: EdgeInsets.zero,
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
              bloc: AuthenticationBlocController().authenticationBloc,
              listener: (BuildContext context, AuthenticationState state) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                if (state is SetUserData) {
                  pageState!.currentUser = Future.value(
                    state.currentUser,
                  );
                  App.of(context)!.setLocale(
                    supportedLocales
                        .firstWhere((e) => e.languageCode == state.currentLang),
                  );
                  onUserFetched(state.currentUser);
                }
              },
              child: _renderLayout(context)),
        ),
      ),
    );
  }

  Widget _renderLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return SizedBox(
          height: size.maxHeight,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 54),
                child: Stack(
                  children: [
                    Container(
                      color: Theme.of(context).disabledColor,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return child;
                        },
                      ),
                    ),
                    navigate ?? const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                width: size.maxWidth,
                height: 54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      height: 53,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: subRoute == null
                                ? null
                                : () => navigateTo(route),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              name.isNotEmpty ? ScreenUtil.t(name)! : name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                          if (subName != null && subName!.isNotEmpty)
                            Text(
                              '/',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                            ),
                          if (subName != null && subName!.isNotEmpty)
                            TextButton(
                              onPressed: null,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                ScreenUtil.t(subName!)!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          if (stream != null)
                            StreamBuilder(
                                stream: stream,
                                builder: (context, state) {
                                  if (state.hasData &&
                                      state.data == BlocState.fetching) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: JTCircularProgressIndicator(
                                        size: 20,
                                        strokeWidth: 1.5,
                                        color: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .color!,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                }),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PageContent extends StatelessWidget {
  final AsyncSnapshot<AccountModel> userSnapshot;
  final PageState pageState;
  final void Function()? onFetch;
  final Widget child;
  final String route;
  const PageContent({
    Key? key,
    required this.userSnapshot,
    required this.pageState,
    required this.child,
    this.onFetch,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!userSnapshot.hasData) {
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
    } else {
      final currentUserRoles = userSnapshot.data!.roles
          .map((e) => e.modules.map((m) => m.name).toList())
          .toList();
      for (var modules in currentUserRoles) {
        //debugPrint(modules[0] + " " + modules[1] + " " + modules[2] + " " + modules[3] );
        if (_checkRole(route: route, modules: modules)) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Column(
              children: [
                const Icon(
                  Icons.report_gmailerrorred_outlined,
                  size: 120,
                ),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    ScreenUtil.t(I18nKey.doNotHavePermissionToAccess)!,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ],
            ),
          );
        }
      }
    }
    if (!pageState.isInitData) {
      if (onFetch != null) onFetch!();
      pageState.isInitData = true;
    }
    return child;
  }
}

bool _checkRole({required String route, required List<String> modules}) {
  switch (route) {
    case userManagementRoute:
      return !modules.contains("USER_MANAGEMENT");
    case smartParkingRoute:
      return !modules.contains("SMART_PARKING");
    case faceRecognitionRoute:
      return !modules.contains("FACE_RECOGNITION");
    case healthyCheckRoute:
    return !modules.contains("HEALTHY CHECK");
    default:
      return false;
  }
}

class PageState {
  bool isInitData = false;
  Future<AccountModel>? currentUser;
}
