import 'package:flutter/material.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';

import 'debouncer/debouncer.dart';

class SearchField extends StatefulWidget {
  final String? title;
  final TextEditingController controller;
  final Function()? onFetch;
  const SearchField({
    Key? key,
    required this.title,
    required this.controller,
    this.onFetch,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late Debouncer _debouncer;
  @override
  void initState() {
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
    return JTTitleTextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.title,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        prefixIcon: Icon(
          Icons.search_outlined,
          size: 20,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.cancel,
            size: 16,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
          iconSize: 16,
          onPressed: () {
            setState(
              () {
                if (widget.controller.text.isEmpty) return;
                widget.controller.text = '';
                widget.onFetch!();
              },
            );
          },
          padding: EdgeInsets.zero,
        ),
      ),
      style: Theme.of(context).textTheme.bodyText1,
      onChanged: (newValue) {
        _debouncer.debounce(afterDuration: () {
          widget.onFetch!();
        });
      },
    );
  }
}
