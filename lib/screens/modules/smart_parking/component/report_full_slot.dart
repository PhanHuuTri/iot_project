import 'package:flutter/material.dart';
import 'package:web_iot/config/app_color.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/webview/viebview_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/models/webview_model.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../showdialog_webview/dialog_webview.dart';
import 'dart:js' as js;
// import 'package:webviewx/webviewx.dart';

class ReportFullSlot extends StatefulWidget {
  final WebviewBloc webviewBloc;
  final String route;
  final Function(int) changeTab;
  final AccountModel currentUser;
  final Function() fetchToken;
  
  const ReportFullSlot({
    Key? key,
    required this.changeTab,
    required this.route,
    required this.currentUser,
    required this.fetchToken,
    required this.webviewBloc,
  }) : super(key: key);

  @override
  _ReportFullSlotState createState() => _ReportFullSlotState();
}

class _ReportFullSlotState extends State<ReportFullSlot> {
  String url = '';
  //late WebViewXController webviewController;

  @override
  void initState() {
    widget.fetchToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: size.width - 100,
        height: size.height,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              decoration:const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
              ),
              margin: const EdgeInsets.only(left: 25),
              child: IconButton(
                padding:const EdgeInsets.all(0) ,
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const DiaLogWebView();
                    },
                  );
                },
                icon: const Icon(
                  Icons.fullscreen_outlined,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            //title: const Center(child: Text('Web View')),
            actions: [
              Container(
                decoration:const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
              ),
                margin: const EdgeInsets.only(right: 25),
                child: IconButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    js.context.callMethod('open', [url]);
                  },
                  icon:const Icon(
                    Icons.trending_flat,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
          body: StreamBuilder(
              stream: widget.webviewBloc.token,
              builder: (context,
                  AsyncSnapshot<ApiResponse<WebViewModel?>> snapshot) {
                if (snapshot.hasData) {
                  url = snapshot.data!.model!.data;
                  return WebView(
                    initialUrl: url,
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: JTCircularProgressIndicator(
                      size: 20,
                      strokeWidth: 1.5,
                      color: AppColor.primary,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
