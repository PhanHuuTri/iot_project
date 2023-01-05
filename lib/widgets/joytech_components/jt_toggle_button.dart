import 'package:flutter/material.dart';
import 'package:web_iot/widgets/joytech_components/jt_form_input_header.dart';

class JTToggleButton extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? enabledMessage;
  final String? disabledMessage;
  final TextStyle? enabledStyle;
  final TextStyle? disabledStyle;
  final bool initialValue;
  final Function(bool?)? onChanged;
  const JTToggleButton({
    Key? key,
    this.title,
    this.titleStyle,
    this.initialValue = false,
    this.enabledMessage,
    this.disabledMessage,
    this.enabledStyle,
    this.disabledStyle,
    this.onChanged,
  }) : super(key: key);

  @override
  _JTToggleButtonState createState() => _JTToggleButtonState();
}

class _JTToggleButtonState extends State<JTToggleButton> {
  _JTToggleButtonState() {
    _isSwitch = widget.initialValue;
  }

  bool _isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return widget.title == null || widget.title!.isEmpty
        ? Container(
            child: Row(
              children: [
                Switch(
                  value: _isSwitch,
                  onChanged: (value) {
                    setState(() {
                      _isSwitch = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
                  activeTrackColor: Theme.of(context)
                      .textTheme
                      .button!
                      .color!
                      .withOpacity(0.2),
                  activeColor: Theme.of(context).textTheme.button!.color!,
                  inactiveTrackColor: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .color!
                      .withOpacity(0.2),
                  inactiveThumbColor:
                      Theme.of(context).textTheme.bodyText2!.color,
                ),
                widget.enabledMessage != null && widget.disabledMessage != null
                    ? Text(
                        _isSwitch ? widget.enabledMessage! : widget.disabledMessage!,
                        style: _isSwitch
                            ? widget.enabledStyle ?? Theme.of(context).textTheme.button
                            : widget.disabledStyle ??
                                Theme.of(context).textTheme.bodyText2,
                      )
                    : const SizedBox(),
                const Spacer(),
              ],
            ),
            constraints: const BoxConstraints(minHeight: 48),
          )
        : Column(
            children: [
              JTFormInputHeader(
                child: Text(widget.title!, style: widget.titleStyle),
              ),
              Container(
                child: Row(
                  children: [
                    Switch(
                      value: _isSwitch,
                      onChanged: (value) {
                        setState(() {
                          _isSwitch = value;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                      },
                      activeTrackColor: Theme.of(context)
                          .textTheme
                          .button!
                          .color!
                          .withOpacity(0.2),
                      activeColor: Theme.of(context).textTheme.button!.color,
                      inactiveTrackColor: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .color!
                          .withOpacity(0.2),
                      inactiveThumbColor:
                          Theme.of(context).textTheme.bodyText2!.color,
                    ),
                    widget.enabledMessage != null && widget.disabledMessage != null
                        ? Text(
                            _isSwitch ? widget.enabledMessage! : widget.disabledMessage!,
                            style: _isSwitch
                                ? widget.enabledStyle ??
                                    Theme.of(context).textTheme.button
                                : widget.disabledStyle ??
                                    Theme.of(context).textTheme.bodyText2,
                          )
                        : const SizedBox(),
                    const Spacer(),
                  ],
                ),
                constraints: const BoxConstraints(minHeight: 48),
              ),
            ],
          );
  }
}
