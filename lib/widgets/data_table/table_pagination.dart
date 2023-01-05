import 'package:flutter/material.dart';
import '../../core/base/models/common_model.dart';

enum PagingButtonStyle { first, previous, number, next, last }

class TablePagination extends StatelessWidget {
  final Function(int) onFetch;
  final Paging pagination;
  final bool onLeft;
  const TablePagination({
    Key? key,
    required this.onFetch,
    required this.pagination,
    this.onLeft = false,
  }) : super(key: key);

  final double _buttonSize = 36;

  @override
  Widget build(BuildContext context) {
    final pages = pagesList();
    if (pages.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!onLeft) const Spacer(),
          if (pagination.totalPage > 5)
            _pageButtonFor(style: PagingButtonStyle.first, context: context),
          if (pagination.totalPage > 5) const SizedBox(width: 4),
          _pageButtonFor(style: PagingButtonStyle.previous, context: context),
          const SizedBox(width: 4),
          for (var index in pages)
            Row(
              children: [
                _pageButtonFor(
                  style: PagingButtonStyle.number,
                  index: index,
                  context: context,
                ),
                const SizedBox(width: 4)
              ],
            ),
          _pageButtonFor(style: PagingButtonStyle.next, context: context),
          if (pagination.totalPage > 5) const SizedBox(width: 4),
          if (pagination.totalPage > 5)
            _pageButtonFor(style: PagingButtonStyle.last, context: context),
          if (onLeft) const Spacer(),
        ],
      ),
    );
  }

  List<int> pagesList() {
    if (pagination.totalPage <= 5) {
      return [for (var i = 1; i <= pagination.totalPage; i += 1) i];
    }
    var min = pagination.page - 2 > 0 ? pagination.page - 2 : 1;
    var max = min + 4 <= pagination.totalPage ? min + 4 : pagination.totalPage;
    min = max == pagination.totalPage ? max - 4 : min;
    return [for (int i = min; i <= max; i++) i];
  }

  _pageButtonFor({
    int? index,
    required PagingButtonStyle style,
    required BuildContext context,
  }) {
    return ButtonTheme(
      minWidth: _buttonSize,
      height: _buttonSize,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: _buttonColor(
            index: index,
            style: style,
            context: context,
          ),
          shape: _shapeBorder(style: style, context: context, index: index),
          minimumSize: Size(_buttonSize, _buttonSize),
          padding: EdgeInsets.zero,
        ),
        onPressed: _actionFor(style, index),
        child: _buttonContent(
          index: index,
          style: style,
          context: context,
        ),
      ),
    );
  }

  _actionFor(PagingButtonStyle style, int? index) {
    switch (style) {
      case PagingButtonStyle.next:
        if (_isEnabled(style)) return () => onFetch(pagination.nextPage);
        break;
      case PagingButtonStyle.previous:
        if (_isEnabled(style)) return () => onFetch(pagination.previousPage);
        break;
      case PagingButtonStyle.first:
        if (_isEnabled(style)) return () => onFetch(1);
        break;
      case PagingButtonStyle.last:
        if (_isEnabled(style)) return () => onFetch(pagination.totalPage);
        break;
      default:
        return () => onFetch(index!);
    }
    return null;
  }

  Widget _buttonContent({
    int? index,
    required PagingButtonStyle style,
    required BuildContext context,
  }) {
    switch (style) {
      case PagingButtonStyle.next:
      case PagingButtonStyle.previous:
      case PagingButtonStyle.first:
      case PagingButtonStyle.last:
        final color = _isEnabled(style)
            ? Theme.of(context).buttonTheme.colorScheme!.background
            : Theme.of(context).dividerColor;
        return _iconFor(style, color);
      default:
        final textStyle = pagination.page == index
            ? Theme.of(context).textTheme.button!.copyWith(
                color: Theme.of(context).buttonTheme.colorScheme!.background)
            : Theme.of(context).textTheme.bodyText2;
        return Text(index.toString(), style: textStyle);
    }
  }

  _iconFor(PagingButtonStyle style, Color color) {
    switch (style) {
      case PagingButtonStyle.next:
        return Icon(Icons.arrow_forward_ios_outlined, color: color, size: 12);
      case PagingButtonStyle.previous:
        return Icon(Icons.arrow_back_ios_outlined, color: color, size: 12);
      case PagingButtonStyle.first:
        return Icon(Icons.first_page, color: color, size: 18);
      case PagingButtonStyle.last:
        return Icon(Icons.last_page, color: color, size: 18);
      default:
        return null;
    }
  }

  Color _buttonColor({
    required PagingButtonStyle style,
    int? index,
    required BuildContext context,
  }) {
    final iconColor = _isEnabled(style)
        ? Theme.of(context).buttonTheme.colorScheme!.primary
        : Colors.transparent;
    switch (style) {
      case PagingButtonStyle.number:
        final color = pagination.page == index
            ? Theme.of(context).buttonTheme.colorScheme!.primary
            : Colors.transparent;
        return color;
      case PagingButtonStyle.next:
        return iconColor;
      case PagingButtonStyle.previous:
        return iconColor;
      case PagingButtonStyle.first:
        return iconColor;
      case PagingButtonStyle.last:
        return iconColor;
      default:
        return Colors.transparent;
    }
  }

  _shapeBorder({
    required PagingButtonStyle style,
    required BuildContext context,
    int? index,
  }) {
    final color = _isEnabled(style) || pagination.page == index
        ? Theme.of(context).buttonTheme.colorScheme!.primary
        : Theme.of(context).dividerColor;
        
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
      side: BorderSide(color: color, width: 1),
    );
  }

  bool _isEnabled(PagingButtonStyle style) {
    switch (style) {
      case PagingButtonStyle.previous:
        return pagination.canGoPrevious;
      case PagingButtonStyle.next:
        return pagination.canGoNext;
      case PagingButtonStyle.first:
        return pagination.page > 1;
      case PagingButtonStyle.last:
        return pagination.page < pagination.totalPage;
      default:
        return false;
    }
  }
}
