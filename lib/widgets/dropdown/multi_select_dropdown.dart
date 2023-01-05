import 'package:flutter/material.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import 'package:web_iot/widgets/popover/dynamic_popover.dart';

class MultiSelectDropdown extends StatelessWidget {
  final String? title;
  final List<String> selected;
  final List<String> source;
  final List<String>? sourceDisplay;
  final double contentWidth;
  final Function(List<String>)? onChanged;
  final bool multipleSelection;
  final String? defaultHint;
  final bool enableClearing;
  final bool isEnabled;
  final String Function(String)? displayedValue;
  final bool needConfirm;
  final String? route;
  final bool enableSearch;
  final Function()? refeshMessage;
  final Color? backgroundColor;

  const MultiSelectDropdown({
    Key? key,
    this.title,
    this.selected = const [],
    this.source = const [],
    this.contentWidth = 236,
    this.onChanged,
    this.multipleSelection = true,
    this.defaultHint,
    this.enableClearing = true,
    this.isEnabled = true,
    this.displayedValue,
    this.needConfirm = false,
    this.route,
    this.enableSearch = true,
    this.refeshMessage,
    this.sourceDisplay,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxColor = backgroundColor ??
        Theme.of(context).buttonTheme.colorScheme!.background;
    return SizedBox(
      width: contentWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title!.isNotEmpty)
            JTFormInputHeader(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: ListTile(
                  title: selected.isEmpty || source.isEmpty || selected.isEmpty
                      ? Text(
                          defaultHint!,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          displayedValue != null
                              ? displayedValue!(selected[0])
                              : selected[0],
                          style: isEnabled
                              ? Theme.of(context).textTheme.bodyText1
                              : Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  trailing: source.isEmpty
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: JTCircularProgressIndicator(
                            size: 14,
                            strokeWidth: 1.0,
                            color: Theme.of(context).textTheme.button!.color!,
                          ),
                        )
                      : SizedBox(
                          height: 44,
                          width: selected.length < 10
                              ? 46
                              : selected.length < 100
                                  ? 58
                                  : 66,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (selected.length > 1)
                                Text(
                                  '(+${selected.length - 1})',
                                  style: Theme.of(context).textTheme.bodyText2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Icon(
                                Icons.filter_alt_outlined,
                                size: 20,
                                color: isEnabled
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color,
                              )
                            ],
                          ),
                        ),
                ),
              ),
              Positioned.fill(
                child: DropdownTextButton(
                  isEnabled: isEnabled,
                  needConfirm: needConfirm,
                  title: title,
                  source: source,
                  selected: selected,
                  contentWidth: contentWidth,
                  onChanged: onChanged,
                  multipleSelection: multipleSelection,
                  enableClearing: enableClearing,
                  displayedValue: displayedValue,
                  route: route,
                  enableSearch: enableSearch,
                  refeshMessage: refeshMessage,
                  sourceDisplay: sourceDisplay,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DropdownTextButton extends StatelessWidget {
  final bool isEnabled;
  final bool? needConfirm;
  final String? title;
  final List<String>? source;
  final List<String>? sourceDisplay;
  final List<String>? selected;
  final double? contentWidth;
  final Function(List<String>)? onChanged;
  final bool? multipleSelection;
  final bool? enableClearing;
  final String Function(String)? displayedValue;
  final String? route;
  final bool? enableSearch;
  final Function()? refeshMessage;

  const DropdownTextButton({
    Key? key,
    required this.isEnabled,
    this.needConfirm,
    this.title,
    this.source,
    this.selected,
    this.contentWidth,
    this.onChanged,
    this.multipleSelection,
    this.enableClearing,
    this.displayedValue,
    this.route,
    this.enableSearch,
    this.refeshMessage,
    this.sourceDisplay,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
      ),
      onPressed: isEnabled
          ? () {
              if (source == null) return;
              DynamicPopover.dropdown(
                context: context,
                titleHeight: 0.0,
                itemHeight: 34.0,
                contentWidth: contentWidth!,
                source: source!,
                needConfirm: needConfirm!,
                whenComplete: () {
                  if (refeshMessage != null) {
                    refeshMessage!();
                  }
                },
                bodyBuilder: (context, titleHeight, itemHeight) {
                  return ReportDropdownContent(
                    title: title,
                    selected: selected,
                    source: source,
                    enableSearch: source!.length > 8 && enableSearch!,
                    searchHintText: 'Tìm kiếm...',
                    multipleSelection: multipleSelection!,
                    onChanged: onChanged,
                    enableClearing: enableClearing!,
                    titleHeight: titleHeight,
                    itemHeight: itemHeight,
                    displayedValue: displayedValue,
                    needConfirm: needConfirm!,
                    sourceDisplay: sourceDisplay,
                  );
                },
                enableClearing: enableClearing!,
              );
            }
          : null,
      child: const Text(''),
    );
  }
}

class ReportDropdownContent extends StatefulWidget {
  final String? title;
  final List<String>? selected;
  final List<String>? source;
  final List<String>? sourceDisplay;
  final Function(List<String>)? onChanged;
  final bool enableSearch;
  final String? searchHintText;
  final bool multipleSelection;
  final bool selectedOnTop;
  final bool enableClearing;
  final bool needConfirm;
  final double titleHeight;
  final double itemHeight;
  final String Function(String)? displayedValue;
  const ReportDropdownContent({
    Key? key,
    this.title,
    this.selected,
    this.source,
    this.onChanged,
    this.enableSearch = false,
    this.searchHintText,
    this.multipleSelection = false,
    this.selectedOnTop = false,
    this.enableClearing = true,
    this.needConfirm = false,
    this.titleHeight = 44.0,
    this.itemHeight = 36.0,
    this.displayedValue,
    this.sourceDisplay,
  }) : super(key: key);

  @override
  _ReportDropdownContentState createState() => _ReportDropdownContentState();
}

class _ReportDropdownContentState extends State<ReportDropdownContent> {
  final _keyword = TextEditingController();
  final List<String> _selected = [];
  late Debouncer _debouncer;

  @override
  void initState() {
    _selected.addAll(widget.selected!);
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.debounce();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    final List<String> _dataSource = [];
    _dataSource.addAll(widget.source!);
    if (widget.selectedOnTop) {
      _dataSource.sort((a, b) {
        if (_selected.contains(a) && !_selected.contains(b)) return -1;
        if (!_selected.contains(a) && _selected.contains(b)) return 1;
        return 0;
      });
    }
    for (int i = 0; i < _dataSource.length; i++) {
      if (_keyword.text.isEmpty) {
        children.add(
          InkWell(
            onTap: () {
              if (!widget.multipleSelection) {
                Navigator.of(context).pop();
              }
              final _element = _dataSource[i];
              setState(() {
                if (widget.multipleSelection) {
                  if (_selected.contains(_element)) {
                    _selected.remove(_element);
                  } else {
                    _selected.add(_element);
                  }
                } else {
                  _selected.clear();
                  _selected.add(_element);
                }
              });
              if (widget.onChanged != null &&
                  (!widget.needConfirm || !widget.multipleSelection)) {
                widget.onChanged!(_selected);
              }
            },
            child: Container(
              height: widget.itemHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.displayedValue != null
                          ? widget.displayedValue!(_dataSource[i])
                          : _dataSource[i],
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _selected.contains(_dataSource[i])
                      ? SizedBox(
                          width: 24,
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).textTheme.button!.color,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      }
    }
    final _titleAndDivider =
        widget.titleHeight > 0 ? widget.titleHeight + 1 : 0.0;
    final _searchHeight = widget.enableSearch ? widget.itemHeight : 0;
    final _clearHeight = widget.enableClearing ? widget.itemHeight : 0;
    final _confirm = widget.needConfirm ? widget.itemHeight : 0.0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: _titleAndDivider + _clearHeight + _searchHeight,
              bottom: _confirm,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              children: children,
            ),
          ),
          if (widget.titleHeight > 0)
            SizedBox(
              height: widget.titleHeight,
              child: Center(
                child: Text(
                  widget.title!,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          if (widget.titleHeight > 0)
            Padding(
              padding: EdgeInsets.only(top: widget.titleHeight),
              child: const Divider(),
            ),
          widget.enableSearch
              ? Padding(
                  padding: EdgeInsets.only(top: _titleAndDivider),
                  child: SizedBox(
                    height: widget.itemHeight,
                    child: JTTitleTextFormField(
                      controller: _keyword,
                      decoration: InputDecoration(
                        hintText: widget.searchHintText,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        suffixIcon: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                          ),
                          child: Icon(
                            Icons.cancel,
                            size: 14,
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                          onPressed: () {
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
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox(),
          widget.enableClearing
              ? Padding(
                  padding: EdgeInsets.only(
                    top: _titleAndDivider + _searchHeight,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!widget.multipleSelection) {
                        Navigator.of(context).pop();
                      }
                      setState(() => _selected.clear());
                      if (widget.onChanged != null &&
                          (!widget.needConfirm || !widget.multipleSelection)) {
                        widget.onChanged!(_selected);
                      }
                    },
                    child: Container(
                      height: widget.itemHeight,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Xoá bộ lọc',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.clear,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          if (widget.enableClearing)
            Padding(
              padding: EdgeInsets.only(
                top: _titleAndDivider + _searchHeight + _clearHeight,
              ),
              child: const Divider(),
            ),
          if (widget.needConfirm)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: _confirm,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text('Xác nhận'),
                  onPressed: () {
                    if (widget.onChanged != null &&
                        widget.needConfirm &&
                        widget.multipleSelection) {
                      Navigator.of(context).pop();
                      widget.onChanged!(_selected);
                    }
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
