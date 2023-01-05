import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/widgets/errors/error_message_text.dart';

class BuildingManagementScreen extends StatefulWidget {
  const BuildingManagementScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BuildingManagementScreenState();
}

class _BuildingManagementScreenState extends State<BuildingManagementScreen> {
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
      route: buildingManagementRoute,
      name: I18nKey.buildingManagement,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () {},
      child: ErrorMessageText(
        svgIcon: SvgIcons.buildingManagement,
        message: 'coming soon',
      ),
    );
  }
}
