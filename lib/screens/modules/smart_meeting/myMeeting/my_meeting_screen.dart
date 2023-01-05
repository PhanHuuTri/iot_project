import 'package:flutter/material.dart';
import 'package:web_iot/core/authentication/bloc/authentication_bloc_controller.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/widgets/errors/error_message_text.dart';
import '../../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';

class MyMeetingScreen extends StatefulWidget {
  const MyMeetingScreen({Key? key}) : super(key: key);

  @override
  _MyMeetingScreenState createState() => _MyMeetingScreenState();
}

class _MyMeetingScreenState extends State<MyMeetingScreen> {
  final _pageState = PageState();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: myMeetingRoute,
      name: myMeetingRoute,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () {},
      child: ErrorMessageText(
        svgIcon: SvgIcons.healthyCheck,
        message: 'coming soon',
      ),
    );
  }
}
