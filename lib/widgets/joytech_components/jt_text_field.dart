import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import 'jt_form_input_header.dart';

export 'package:flutter/services.dart'
    show
        TextInputType,
        TextInputAction,
        TextCapitalization,
        SmartQuotesType,
        SmartDashesType;

class JTTextField extends StatelessWidget {
  const JTTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    ToolbarOptions? toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
  })  : assert(textAlign != null),
        assert(readOnly != null),
        assert(autofocus != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(autocorrect != null),
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(enableSuggestions != null),
        assert(enableInteractiveSelection != null),
        assert(scrollPadding != null),
        assert(dragStartBehavior != null),
        assert(selectionHeightStyle != null),
        assert(selectionWidthStyle != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
            !identical(textInputAction, TextInputAction.newline) ||
                maxLines == 1 ||
                !identical(keyboardType, TextInputType.text),
            'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.'),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(
                    selectAll: true,
                    paste: true,
                  )
                : const ToolbarOptions(
                    copy: true,
                    cut: true,
                    selectAll: true,
                    paste: true,
                  )),
        super(key: key);

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final InputDecoration? decoration;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization? textCapitalization;

  final TextStyle? style;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextAlignVertical? textAlignVertical;

  final TextDirection? textDirection;

  final bool? autofocus;

  final String? obscuringCharacter;

  final bool obscureText;

  final bool? autocorrect;

  final SmartDashesType? smartDashesType;

  final SmartQuotesType? smartQuotesType;

  final bool? enableSuggestions;

  final int? maxLines;

  final int? minLines;

  final bool expands;

  final bool? readOnly;

  final ToolbarOptions? toolbarOptions;

  final bool? showCursor;

  static const int? noMaxLength = -1;

  final int? maxLength;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final List<TextInputFormatter>? inputFormatters;

  final bool? enabled;

  final double? cursorWidth;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final Color? cursorColor;

  final ui.BoxHeightStyle? selectionHeightStyle;

  final ui.BoxWidthStyle? selectionWidthStyle;

  final Brightness? keyboardAppearance;

  final EdgeInsets? scrollPadding;

  final bool? enableInteractiveSelection;

  final TextSelectionControls? selectionControls;

  final DragStartBehavior? dragStartBehavior;

  bool? get selectionEnabled => enableInteractiveSelection;

  final GestureTapCallback? onTap;

  final MouseCursor? mouseCursor;

  final InputCounterWidgetBuilder? buildCounter;

  final ScrollPhysics? scrollPhysics;

  final ScrollController? scrollController;

  final Iterable<String>? autofillHints;

  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Họ và Tên'),
      TextField(
        key: key,
        controller: controller,
        focusNode: focusNode,
        decoration: decoration,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization!,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign!,
        textAlignVertical: textAlignVertical,
        textDirection: textDirection,
        readOnly: readOnly!,
        toolbarOptions: toolbarOptions,
        showCursor: showCursor,
        autofocus: autofocus!,
        obscuringCharacter: obscuringCharacter!,
        obscureText: obscureText,
        autocorrect: autocorrect!,
        smartDashesType: smartDashesType,
        smartQuotesType: smartQuotesType,
        enableSuggestions: enableSuggestions!,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        maxLength: maxLength,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        onAppPrivateCommand: onAppPrivateCommand,
        inputFormatters: inputFormatters,
        enabled: enabled,
        cursorWidth: cursorWidth!,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        selectionHeightStyle: selectionHeightStyle!,
        selectionWidthStyle: selectionWidthStyle!,
        keyboardAppearance: keyboardAppearance,
        scrollPadding: scrollPadding!,
        dragStartBehavior: dragStartBehavior!,
        enableInteractiveSelection: enableInteractiveSelection!,
        selectionControls: selectionControls,
        onTap: onTap,
        mouseCursor: mouseCursor,
        buildCounter: buildCounter,
        scrollController: scrollController,
        scrollPhysics: scrollPhysics,
        autofillHints: autofillHints,
        restorationId: restorationId,
      ),
    ]);
  }
}

class JTTitleTextFormField extends FormField<String> {
  final String? title;
  final TextStyle? titleStyle;
  final double height;

  JTTitleTextFormField({
    Key? key,
    this.title,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    this.height = 48,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool? autofocus = false,
    bool? readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String? obscuringCharacter = '•',
    bool? obscureText = false,
    bool? autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions = true,
    @Deprecated('Use autoValidateMode parameter which provide more specific '
        'behaviour related to auto validation. '
        'This feature was deprecated after v1.19.0.')
        bool? autovalidate = false,
    bool? maxLengthEnforced = true,
    int? maxLines = 1,
    int? minLines,
    bool? expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding = const EdgeInsets.all(20.0),
    bool? enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
  })  : assert(initialValue == null || controller == null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(enableSuggestions != null),
        assert(autovalidate != null),
        assert(
            autovalidate == false ||
                autovalidate == true && autovalidateMode == null,
            'autovalidate and autovalidateMode should not be used together.'),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          !expands! || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText! || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        assert(enableInteractiveSelection != null),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidate!
              ? AutovalidateMode.always
              : (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return title == null || title.isEmpty
                ? TextField(
                  controller: state._effectiveController,
                  focusNode: focusNode,
                  decoration: effectiveDecoration.copyWith(
                      errorText: field.errorText),
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  style: style,
                  strutStyle: strutStyle,
                  textAlign: textAlign!,
                  textAlignVertical: textAlignVertical,
                  textDirection: textDirection,
                  textCapitalization: textCapitalization!,
                  autofocus: autofocus!,
                  toolbarOptions: toolbarOptions,
                  readOnly: readOnly!,
                  showCursor: showCursor,
                  obscuringCharacter: obscuringCharacter!,
                  obscureText: obscureText!,
                  autocorrect: autocorrect!,
                  smartDashesType: smartDashesType ??
                      (obscureText
                          ? SmartDashesType.disabled
                          : SmartDashesType.enabled),
                  smartQuotesType: smartQuotesType ??
                      (obscureText
                          ? SmartQuotesType.disabled
                          : SmartQuotesType.enabled),
                  enableSuggestions: enableSuggestions!,
                  maxLines: maxLines,
                  minLines: minLines,
                  expands: expands!,
                  maxLength: maxLength,
                  onChanged: onChangedHandler,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onFieldSubmitted,
                  inputFormatters: inputFormatters,
                  enabled: enabled ?? decoration?.enabled ?? true,
                  cursorWidth: cursorWidth,
                  cursorHeight: cursorHeight,
                  cursorRadius: cursorRadius,
                  cursorColor: cursorColor,
                  scrollPadding: scrollPadding!,
                  scrollPhysics: scrollPhysics,
                  keyboardAppearance: keyboardAppearance,
                  enableInteractiveSelection: enableInteractiveSelection!,
                  selectionControls: selectionControls,
                  buildCounter: buildCounter,
                  autofillHints: autofillHints,
                )
                : Column(
                    children: [
                      JTFormInputHeader(
                        child: Text(title, style: titleStyle),
                      ),
                      SizedBox(
                        height: height,
                        child: TextField(
                          controller: state._effectiveController,
                          focusNode: focusNode,
                          decoration: effectiveDecoration.copyWith(
                              errorText: field.errorText),
                          keyboardType: keyboardType,
                          textInputAction: textInputAction,
                          style: style,
                          strutStyle: strutStyle,
                          textAlign: textAlign!,
                          textAlignVertical: textAlignVertical,
                          textDirection: textDirection,
                          textCapitalization: textCapitalization!,
                          autofocus: autofocus!,
                          toolbarOptions: toolbarOptions,
                          readOnly: readOnly!,
                          showCursor: showCursor,
                          obscuringCharacter: obscuringCharacter!,
                          obscureText: obscureText!,
                          autocorrect: autocorrect!,
                          smartDashesType: smartDashesType ??
                              (obscureText
                                  ? SmartDashesType.disabled
                                  : SmartDashesType.enabled),
                          smartQuotesType: smartQuotesType ??
                              (obscureText
                                  ? SmartQuotesType.disabled
                                  : SmartQuotesType.enabled),
                          enableSuggestions: enableSuggestions!,
                          maxLines: maxLines,
                          minLines: minLines,
                          expands: expands!,
                          maxLength: maxLength,
                          onChanged: onChangedHandler,
                          onTap: onTap,
                          onEditingComplete: onEditingComplete,
                          onSubmitted: onFieldSubmitted,
                          inputFormatters: inputFormatters,
                          enabled: enabled ?? decoration?.enabled ?? true,
                          cursorWidth: cursorWidth,
                          cursorHeight: cursorHeight,
                          cursorRadius: cursorRadius,
                          cursorColor: cursorColor,
                          scrollPadding: scrollPadding!,
                          scrollPhysics: scrollPhysics,
                          keyboardAppearance: keyboardAppearance,
                          enableInteractiveSelection:
                              enableInteractiveSelection!,
                          selectionControls: selectionControls,
                          buildCounter: buildCounter,
                          autofillHints: autofillHints,
                        ),
                      ),
                    ],
                  );
          },
        );

  final TextEditingController? controller;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].

  @override
  _TextFormFieldState createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  JTTitleTextFormField get widget => super.widget as JTTitleTextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(JTTitleTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue ?? '';
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
  }
}

class JTTitleButtonFormField extends FormField<String> {
  final String? title;
  final TextStyle? titleStyle;
  final Function? onPressed;

  JTTitleButtonFormField({
    Key? key,
    this.title,
    this.titleStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    this.onPressed,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool? autofocus = false,
    bool? readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String? obscuringCharacter = '•',
    bool? obscureText = false,
    bool? autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions = true,
    @Deprecated('Use autoValidateMode parameter which provide more specific '
        'behaviour related to auto validation. '
        'This feature was deprecated after v1.19.0.')
        bool? autovalidate = false,
    bool? maxLengthEnforced = true,
    int? maxLines = 1,
    int? minLines,
    bool? expands = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double? cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding = const EdgeInsets.all(20.0),
    bool? enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
  })  : assert(initialValue == null || controller == null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(enableSuggestions != null),
        assert(autovalidate != null),
        assert(
            autovalidate == false ||
                autovalidate == true && autovalidateMode == null,
            'autovalidate and autovalidateMode should not be used together.'),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          !expands! || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText! || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        assert(enableInteractiveSelection != null),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? decoration?.enabled ?? true,
          autovalidateMode: autovalidate!
              ? AutovalidateMode.always
              : (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<String> field) {
            final _ButtonFormFieldState state = field as _ButtonFormFieldState;
            final InputDecoration effectiveDecoration = (decoration ??
                    const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return title == null || title.isEmpty
                ? Container(
                    child: Stack(
                      children: [
                        TextField(
                          controller: state._effectiveController,
                          focusNode: focusNode,
                          decoration: effectiveDecoration.copyWith(
                              errorText: field.errorText),
                          keyboardType: keyboardType,
                          textInputAction: textInputAction,
                          style: style,
                          strutStyle: strutStyle,
                          textAlign: textAlign!,
                          textAlignVertical: textAlignVertical,
                          textDirection: textDirection,
                          textCapitalization: textCapitalization!,
                          autofocus: autofocus!,
                          toolbarOptions: toolbarOptions,
                          readOnly: readOnly! || onPressed != null,
                          showCursor: showCursor,
                          obscuringCharacter: obscuringCharacter!,
                          obscureText: obscureText!,
                          autocorrect: autocorrect!,
                          smartDashesType: smartDashesType ??
                              (obscureText
                                  ? SmartDashesType.disabled
                                  : SmartDashesType.enabled),
                          smartQuotesType: smartQuotesType ??
                              (obscureText
                                  ? SmartQuotesType.disabled
                                  : SmartQuotesType.enabled),
                          enableSuggestions: enableSuggestions!,
                          maxLines: maxLines,
                          minLines: minLines,
                          expands: expands!,
                          maxLength: maxLength,
                          onChanged: onChangedHandler,
                          onTap: onTap,
                          onEditingComplete: onEditingComplete,
                          onSubmitted: onFieldSubmitted,
                          inputFormatters: inputFormatters,
                          enabled: enabled ?? decoration?.enabled ?? true,
                          cursorWidth: cursorWidth!,
                          cursorHeight: cursorHeight,
                          cursorRadius: cursorRadius,
                          cursorColor: cursorColor,
                          scrollPadding: scrollPadding!,
                          scrollPhysics: scrollPhysics,
                          keyboardAppearance: keyboardAppearance,
                          enableInteractiveSelection:
                              enableInteractiveSelection!,
                          selectionControls: selectionControls,
                          buildCounter: buildCounter,
                          autofillHints: autofillHints,
                        ),
                        onPressed == null
                            ? const SizedBox()
                            : Positioned.fill(
                                child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      onPressed();
                                    },
                                    child: const Text(''),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    constraints: const BoxConstraints(minHeight: 48),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      JTFormInputHeader(
                        child: Text(title, style: titleStyle),
                      ),
                      Container(
                        child: Stack(
                          children: [
                            TextField(
                              controller: state._effectiveController,
                              focusNode: focusNode,
                              decoration: effectiveDecoration.copyWith(
                                  errorText: field.errorText),
                              keyboardType: keyboardType,
                              textInputAction: textInputAction,
                              style: style,
                              strutStyle: strutStyle,
                              textAlign: textAlign!,
                              textAlignVertical: textAlignVertical,
                              textDirection: textDirection,
                              textCapitalization: textCapitalization!,
                              autofocus: autofocus!,
                              toolbarOptions: toolbarOptions,
                              readOnly: readOnly! || onPressed != null,
                              showCursor: showCursor,
                              obscuringCharacter: obscuringCharacter!,
                              obscureText: obscureText!,
                              autocorrect: autocorrect!,
                              smartDashesType: smartDashesType ??
                                  (obscureText
                                      ? SmartDashesType.disabled
                                      : SmartDashesType.enabled),
                              smartQuotesType: smartQuotesType ??
                                  (obscureText
                                      ? SmartQuotesType.disabled
                                      : SmartQuotesType.enabled),
                              enableSuggestions: enableSuggestions!,
                              maxLines: maxLines,
                              minLines: minLines,
                              expands: expands!,
                              maxLength: maxLength,
                              onChanged: onChangedHandler,
                              onTap: onTap,
                              onEditingComplete: onEditingComplete,
                              onSubmitted: onFieldSubmitted,
                              inputFormatters: inputFormatters,
                              enabled: enabled ?? decoration?.enabled ?? true,
                              cursorWidth: cursorWidth!,
                              cursorHeight: cursorHeight,
                              cursorRadius: cursorRadius,
                              cursorColor: cursorColor,
                              scrollPadding: scrollPadding!,
                              scrollPhysics: scrollPhysics,
                              keyboardAppearance: keyboardAppearance,
                              enableInteractiveSelection:
                                  enableInteractiveSelection!,
                              selectionControls: selectionControls,
                              buildCounter: buildCounter,
                              autofillHints: autofillHints,
                            ),
                            onPressed == null
                                ? const SizedBox()
                                : Positioned.fill(
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                        ),
                                        onPressed: () {
                                          onPressed();
                                        },
                                        child: const Text(''),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        constraints: const BoxConstraints(minHeight: 48),
                      ),
                    ],
                  );
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  @override
  _ButtonFormFieldState createState() => _ButtonFormFieldState();
}

class _ButtonFormFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  JTTitleButtonFormField get widget => super.widget as JTTitleButtonFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(JTTitleButtonFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue ?? '';
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
  }
}
