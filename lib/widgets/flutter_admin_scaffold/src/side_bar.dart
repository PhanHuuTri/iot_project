import 'dart:math';
import 'package:flutter/material.dart';
import 'menu_item.dart' as mi;
import 'side_bar_item.dart';

double sideBarScrollOffset = 0.0;

class SideBar extends StatefulWidget {
  const SideBar({
    Key? key,
    required this.items,
    required this.selectedRoute,
    this.onSelected,
    this.width = 240.0,
    this.iconColor,
    this.activeIconColor,
    this.textStyle = const TextStyle(
      color: Color(0xFF337ab7),
      fontSize: 12,
    ),
    this.activeTextStyle = const TextStyle(
      color: Color(0xFF337ab7),
      fontSize: 12,
    ),
    this.parentTextStyle = const TextStyle(
      color: Color(0xFF337ab7),
      fontSize: 12,
    ),
    this.parentActiveTextStyle = const TextStyle(
      color: Color(0xFF337ab7),
      fontSize: 12,
    ),
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.activeBackgroundColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
    this.header,
    this.footer,
  }) : super(key: key);

  final List<mi.MenuItem> items;
  final String selectedRoute;
  final void Function(mi.MenuItem item)? onSelected;
  final double width;
  final Color? iconColor;
  final Color? activeIconColor;
  final TextStyle textStyle;
  final TextStyle activeTextStyle;
  final TextStyle parentTextStyle;
  final TextStyle parentActiveTextStyle;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color borderColor;
  final Widget? header;
  final Widget? footer;

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  double? _sideBarWidth;
  final _scrollController = ScrollController(
    initialScrollOffset: sideBarScrollOffset,
  );

  @override
  void initState() {
    super.initState();
    _sideBarWidth = widget.width;
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        sideBarScrollOffset = _scrollController.offset;
      } else {
        sideBarScrollOffset = 0.0;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _sideBarWidth = min(mediaQuery.size.width * 0.7, widget.width);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _sideBarWidth,
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          Expanded(
            child: Material(
              color: widget.backgroundColor,
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SideBarItem(
                          items: widget.items,
                          index: index,
                          onSelected: widget.onSelected!,
                          selectedRoute: widget.selectedRoute,
                          depth: 0,
                          iconColor: widget.iconColor!,
                          activeIconColor: widget.activeIconColor!,
                          textStyle: widget.textStyle,
                          activeTextStyle: widget.activeTextStyle,
                          backgroundColor: widget.backgroundColor,
                          activeBackgroundColor: widget.activeBackgroundColor,
                          borderColor: widget.borderColor,
                          parentTextStyle: widget.parentTextStyle,
                          parentActiveTextStyle: widget.parentActiveTextStyle,
                        ),
                      ],
                    );
                  },
                  itemCount: widget.items.length,
                ),
              ),
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }
}
