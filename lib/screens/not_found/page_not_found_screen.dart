import 'package:flutter/material.dart';

class PageNotFoundScreen extends StatefulWidget {
  final String route;
  const PageNotFoundScreen(this.route, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends State<PageNotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      child: Column(
        children: [
          const Icon(
            Icons.report_gmailerrorred_outlined,
            size: 120,
          ),
          const SizedBox(height: 60),
          Text(
            'Không tìm thấy trang!',
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}
