// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';

class SmartMeetingScreen extends StatefulWidget {
  const SmartMeetingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartMeetingScreenState();
}

class _SmartMeetingScreenState extends State<SmartMeetingScreen> {
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
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 150,
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("Create Room"),
                      ),
                    ],
                  ),
                  onPressed: () {
                    navigateTo(addMeetingRoute);
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                height: 45,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("My Room"),
                      ),
                    ],
                  ),
                  onPressed: () {
                    navigateTo(myMeetingRoute);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 550,
            child: SfCalendar(
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
              ],
            ),
          )
        ],
      ),
    );
  }
}
