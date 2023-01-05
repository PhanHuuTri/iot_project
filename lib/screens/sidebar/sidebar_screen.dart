import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/widgets/errors/error_message_text.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';

class SideBarScreen extends StatefulWidget {
  const SideBarScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  // Filters
  final _pageState = PageState();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: sideBarRoute,
      name: '',
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () {},
      child: const ErrorMessageText(
        icon: Icons.aspect_ratio_outlined,
        message: 'Vui lòng chọn 1 module ở menu bên trái',
      ),
    );
  }
}
