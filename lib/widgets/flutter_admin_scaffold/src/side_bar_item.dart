import 'package:flutter/material.dart';
import 'package:web_iot/config/svg_constants.dart';
import '../../../main.dart';
import 'jt_expansion_tile.dart';
import 'menu_item.dart' as mi;

class SideBarItem extends StatelessWidget {
  const SideBarItem({
    Key? key,
    required this.items,
    required this.index,
    this.onSelected,
    this.selectedRoute,
    this.depth = 0,
    this.iconColor,
    this.activeIconColor,
    required this.textStyle,
    this.activeTextStyle,
    this.parentTextStyle,
    this.parentActiveTextStyle,
    required this.backgroundColor,
    required this.activeBackgroundColor,
    required this.borderColor,
  }) : super(key: key);

  final List<mi.MenuItem> items;
  final int index;
  final void Function(mi.MenuItem item)? onSelected;
  final String? selectedRoute;
  final int depth;
  final Color? iconColor;
  final Color? activeIconColor;
  final TextStyle textStyle;
  final TextStyle? activeTextStyle;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color borderColor;
  final TextStyle? parentTextStyle;
  final TextStyle? parentActiveTextStyle;
  bool get isLast => index == items.length - 1;

  @override
  Widget build(BuildContext context) {
    if (depth > 0 && isLast) {
      return SizedBox(child: _buildTiles(context, items[index]));
    }
    return _buildTiles(context, items[index]);
  }

  Widget _buildTiles(BuildContext context, mi.MenuItem item) {
    bool selected = _isSelected(selectedRoute!, [item]);
    final List<String> expandedItems = [
      ScreenUtil.t(I18nKey.module)!.toUpperCase(),
      ScreenUtil.t(I18nKey.adminControl)!.toUpperCase(),
    ];
    if (item.children.isEmpty) {
      return Ink(
        height: item.title != ScreenUtil.t(I18nKey.adminControl)! ? 54 : 48,
        decoration: BoxDecoration(
          border: selected
              ? Border(
                  left: BorderSide(
                    color: borderColor,
                    width: 4,
                  ),
                )
              : null,
          color: selected ? activeBackgroundColor : backgroundColor,
        ),
        child: ListTile(
            contentPadding: _getTilePadding(depth),
            leading: _buildIcon(item, selected),
            title: Transform.translate(
              offset: const Offset(-20, 0),
              child: _buildTitle(item, selected),
            ),
            selected: selected,
            hoverColor: activeBackgroundColor.withOpacity(0.15),
            tileColor: Colors.transparent,
            selectedTileColor: Colors.transparent,
            onTap: () {
              if (onSelected != null) {
                onSelected!(item);
              }
            }),
      );
    }

    int index = 0;
    final childrenTiles = item.children.map((child) {
      return SideBarItem(
        items: item.children,
        index: index++,
        onSelected: onSelected,
        selectedRoute: selectedRoute,
        depth: depth,
        iconColor: iconColor,
        activeIconColor: activeIconColor,
        textStyle: textStyle,
        activeTextStyle: activeTextStyle,
        backgroundColor: backgroundColor,
        activeBackgroundColor: activeBackgroundColor,
        borderColor: borderColor,
      );
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: JTExpansionTile(
        tilePadding: _getTilePadding(depth),
        leading: _buildLeading(item),
        title: null,
        initiallyExpanded: expandedItems.contains(item.title) || selected,
        children: childrenTiles,
        onExpansionChanged: (value) {
          if (onSelected != null) {
            onSelected!(item);
          }
        },
      ),
    );
  }

  bool _isSelected(String route, List<mi.MenuItem> items) {
    for (final item in items) {
      if (item.route == route) {
        return true;
      }
      if (item.children.isNotEmpty) {
        return _isSelected(route, item.children);
      }
    }
    return false;
  }

  Widget _buildLeading(mi.MenuItem item, [bool selected = false]) {
    return item.icon == null
        ? _buildTitle(item, selected)
        : _buildIcon(item, selected);
  }

  Widget _buildIcon(mi.MenuItem item, [bool selected = false]) {
    final activeColor = item.children.isNotEmpty
        ? parentActiveTextStyle!.color
        : activeIconColor ?? activeTextStyle!.color;
    final color = item.children.isNotEmpty
        ? parentTextStyle!.color
        : iconColor ?? textStyle.color;
    return item.icon != null
        ? Icon(
            item.icon,
            size: 20,
            color: selected ? activeColor : color,
          )
        : item.svgIcon != null
            ? SvgIcon(
                item.svgIcon!,
                size: 22,
                color: selected ? activeColor : color,
              )
            : const SizedBox();
  }

  Widget _buildTitle(mi.MenuItem item, [bool selected = false]) {
    final activeStyle =
        item.children.isNotEmpty ? parentActiveTextStyle : activeTextStyle;
    final style = item.children.isNotEmpty ? parentTextStyle : textStyle;
    return Text(
      item.title,
      style: selected ? activeStyle : style,
    );
  }

  EdgeInsets _getTilePadding(int depth) {
    return EdgeInsets.only(
      left: 22.0 + 10.0 * depth,
      right: 0.0,
    );
  }
}
