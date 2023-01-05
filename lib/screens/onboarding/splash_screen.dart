import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_iot/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc? _authenticationBloc;
  @override
  void initState() {
    _authenticationBloc = AuthenticationBlocController().authenticationBloc;
    _authenticationBloc!.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: _authenticationBloc,
        listener: (BuildContext context, AuthenticationState state) {
          // if (state is AppAutheticated) {
          //   navigateTo(accountRoute);
          // }
          if (state is AuthenticationStart) {
            navigateTo(authenticationRoute);
          }
          if (state is UserLogoutState) {
            showNoti = false;
            navigateTo(authenticationRoute);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            return const Center(child: Text(''));
          },
        ),
      ),
    );
  }
}
