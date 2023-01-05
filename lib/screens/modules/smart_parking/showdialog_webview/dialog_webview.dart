import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_iot/config/app_color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiaLogWebView extends StatefulWidget {
  const DiaLogWebView({Key? key}) : super(key: key);

  @override
  State<DiaLogWebView> createState() => _DiaLogWebViewState();
}

class _DiaLogWebViewState extends State<DiaLogWebView> {
  
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    const String url = 'http://cp.kztek.net';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:60,
        leadingWidth: 200,
        leading: Container(
          color: Theme.of(context).buttonTheme.colorScheme!.background,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 35,
                  height: 35,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'C.P GROUP',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: AppColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {
                Navigator.of(context).pop();
              },
              icon:const Icon( Icons.fullscreen_exit_outlined,size: 25,),
              ),
            ),
          )
        ],
      ),
      body: const WebView(
            initialUrl: url,
          ),
    );
  }
}
