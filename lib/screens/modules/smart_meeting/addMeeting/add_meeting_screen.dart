import 'package:flutter/material.dart';
import 'package:web_iot/core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/widgets/errors/error_message_text.dart';
import '../../../../main.dart';

class AddMeetingScreen extends StatefulWidget {
  const AddMeetingScreen({Key? key}) : super(key: key);

  @override
  _AddMeetingScreenState createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _pageState = PageState();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      route: addMeetingRoute,
      name: I18nKey.smartMeeting,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () {},
      child: ErrorMessageText(
        svgIcon: SvgIcons.healthyCheck,
        message: ScreenUtil.t(I18nKey.comingSoon)!,
      ),
    );
  }
}
