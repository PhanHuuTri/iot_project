import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/widgets/errors/error_message_text.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
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
      route: smartMeetingRoute,
      name: I18nKey.smartMeeting,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () {},
      child: ErrorMessageText(
        svgIcon: SvgIcons.smartMeeting,
        message: 'coming soon',
      ),
    );
  }
}
