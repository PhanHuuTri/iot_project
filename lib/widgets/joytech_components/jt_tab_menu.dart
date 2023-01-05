import 'package:flutter/material.dart';
import '../../main.dart';
import 'dart:js' as js;

class JTTabMenu extends StatefulWidget {
  final Function(int) changeTab;
  final List<String> tabs;
  final String? token;
  final int currentTab;

  const JTTabMenu({
    Key? key,
    required this.changeTab,
    required this.tabs,
    required this.currentTab, required this.token,
  }) : super(key: key);

  @override
  State<JTTabMenu> createState() => _JTTabMenuState();
}

class _JTTabMenuState extends State<JTTabMenu> {
  final _tabMenuScroll = ScrollController();
  List<bool> tabsHover = [];

  @override
  void initState() {
    tabsHover = widget.tabs.map((e) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: _tabMenuScroll,
          itemCount: widget.tabs.length,
          itemBuilder: (context, index) {
            bool isSelected = widget.currentTab == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              onEnd: () {},
              height: 40,
              curve: Curves.elasticInOut,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.0,
                    color: isSelected ? AppColor.primary : AppColor.white,
                  ),
                ),
              ),
              child: 
              (widget.tabs[index]!= 'Trang web')?InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      widget.tabs[index],
                      style: TextStyle(
                        color: isSelected || tabsHover[index]
                            ? AppColor.primary
                            : AppColor.dividerColor,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  widget.changeTab(index);
                },
                onHover: (value) {
                  setState(() {
                    tabsHover[index] = value;
                  });
                },
              ):
              IconButton(
                tooltip: ScreenUtil.t(I18nKey.setting),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Icon(Icons.settings,size: 25,color: Colors.green,),
                  ),
                ),
                onPressed: () {
                  js.context.callMethod('open', [widget.token]);
                },
                
              ),
            );
          });
    });
  }
}
