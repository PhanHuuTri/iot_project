import 'package:flutter/material.dart';
import 'package:web_iot/config/app_color.dart';

class JTTabButton extends StatefulWidget {
  final List<String> tabTitles;
  final Function(int)? changeTab;
  final Color? color;
  final int currentTab;
  final int selectedTab;

  const JTTabButton({
    Key? key,
    this.changeTab,
    this.color,
    required this.tabTitles,
    required this.currentTab,
    required this.selectedTab,
  }) : super(key: key);

  @override
  _JTTabButtonState createState() => _JTTabButtonState();
}

class _JTTabButtonState extends State<JTTabButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var i = 0; i < widget.tabTitles.length; i++)
              _buildTab(
                title: widget.tabTitles[i],
                index: i,
                onPressed: () {
                  widget.changeTab!(i);
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTab({
    required String title,
    Function()? onPressed,
    required int index,
  }) {
    final tabColor = index == widget.selectedTab
        ? Theme.of(context).primaryColor
        : widget.color ?? AppColor.dividerColor;
    return Container(
      height: 28,
      decoration: BoxDecoration(
        border: Border(
          bottom: index == widget.selectedTab
              ? BorderSide(
                  width: 2.0,
                  color: tabColor,
                )
              : BorderSide.none,
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            title,
            style: TextStyle(
              color: tabColor,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
