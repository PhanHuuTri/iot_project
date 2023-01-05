import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';

class FilterPopoverContent extends StatefulWidget {
  final String? title;
  final List<String>? selected;
  final List<String>? source;
  final Function(List<String>)? onChanged;
  final bool enableSearch;
  final String? searchHintText;
  final bool enableClose;
  final bool multipleSelection;
  final bool selectedOnTop;
  final double itemHeight;
  final String? Function(String)? onDisplayedName;
  final double popoverMaxHeight;

  const FilterPopoverContent({
    Key? key,
    this.title,
    this.selected,
    this.source,
    this.onChanged,
    this.enableSearch = false,
    this.searchHintText,
    this.enableClose = true,
    this.multipleSelection = false,
    this.selectedOnTop = false,
    this.itemHeight = 36.0,
    this.onDisplayedName,
    this.popoverMaxHeight = 320,
  }) : super(key: key);

  @override
  _FilterPopoverContentState createState() => _FilterPopoverContentState();
}

class _FilterPopoverContentState extends State<FilterPopoverContent> {
  final _keyword = TextEditingController();
  final List<String> _selected = [];
  final List<String> _dataSource = [];
  late Debouncer _debouncer;

  @override
  void initState() {
    _selected.addAll(widget.selected!);
    _dataSource.addAll(widget.source!);
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedOnTop) {
      _dataSource.sort((a, b) {
        if (_selected.contains(a) && !_selected.contains(b)) return -1;
        if (!_selected.contains(a) && _selected.contains(b)) return 1;
        return 0;
      });
    }

    return LayoutBuilder(builder: (context, size) {
      final double _searchHeight = widget.enableSearch ? widget.itemHeight : 0;
      final double _deleteHeight = widget.itemHeight;
      final double _confirmHeight =
          widget.multipleSelection ? widget.itemHeight : 0;
      final _actionFieldsHeight =
          _searchHeight + _deleteHeight + _confirmHeight;
      final double _listItemMaxHeight = widget.itemHeight * _dataSource.length;
      final double _listItemMinHeight =
          widget.popoverMaxHeight - _actionFieldsHeight;
      final double _listItemHeight =
          min(_listItemMaxHeight, _listItemMinHeight);

      return SizedBox(
        height: _listItemHeight + _actionFieldsHeight,
        child: Column(
          children: [
            if (widget.enableSearch)
              SizedBox(
                height: widget.itemHeight,
                child: JTTitleTextFormField(
                  controller: _keyword,
                  decoration: InputDecoration(
                    fillColor: AppColor.secondaryLight,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.secondaryLight,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    hintText: widget.searchHintText,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      size: 20,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    suffixIcon: InkWell(
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      ),
                      onTap: () {
                        _debouncer.cancel();
                        _keyword.text = '';
                        setState(() {});
                      },
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  onChanged: (newValue) {
                    _debouncer.debounce(
                      afterDuration: () {
                        setState(() {
                          _dataSource.clear();
                          _dataSource.addAll(widget.source!
                              .where((e) => e.contains(newValue)));
                        });
                      },
                    );
                  },
                ),
              ),
            InkWell(
              onTap: () {
                if (!widget.multipleSelection) Navigator.of(context).pop();
                setState(() {
                  _selected.clear();
                  widget.onChanged!(_selected);
                });
              },
              child: Container(
                height: _deleteHeight,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      ScreenUtil.t(I18nKey.delete)!,
                      style: TextStyle(
                        color: AppColor.subTitle,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _listItemHeight,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _dataSource.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (!widget.multipleSelection) {
                        Navigator.of(context).pop();
                      }
                      final _element = _dataSource[index];
                      setState(() {
                        if (_selected.contains(_element)) {
                          _selected.remove(_element);
                        } else {
                          _selected.add(_element);
                        }
                        if (widget.onChanged != null) {
                          if (_isDataChanged()) widget.onChanged!(_selected);
                        }
                      });
                    },
                    hoverColor: AppColor.secondary2,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: widget.itemHeight,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.onDisplayedName != null
                                  ? widget.onDisplayedName!(_dataSource[index])!
                                  : _dataSource[index],
                              style: const TextStyle(
                                color: AppColor.black,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_selected.contains(_dataSource[index]))
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColor.primary,
                              size: 16,
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.multipleSelection)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: widget.itemHeight,
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(ScreenUtil.t(I18nKey.confirm)!),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onChanged != null) {
                        if (_isDataChanged()) widget.onChanged!(_selected);
                      }
                    },
                  ),
                ),
              )
          ],
        ),
      );
    });
  }

  _isDataChanged() {
    var isChanged = false;
    if (_selected.length != widget.selected!.length) isChanged = true;
    if (!isChanged) {
      for (int i = 0; i < _selected.length; i++) {
        if (_selected[i] != widget.selected![i]) {
          isChanged = true;
          break;
        }
      }
    }
    return isChanged;
  }
}
