import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown(
      {Key? key,
      required this.items,
      this.onChanged,
      this.initialValue,
      this.controller,
      this.focusNode,
      this.isExpanded = false,
      this.hint})
      : super(key: key);

  final List<DropdownMenuItem<T>> items;
  final CustomDropdownController? controller;
  final void Function(T? value)? onChanged;
  final T? initialValue;
  final FocusNode? focusNode;
  final bool isExpanded;
  final String? hint;

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  CustomDropdownController? _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller ??= widget.controller ?? CustomDropdownController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller!._widget = this;
  }

  void update() => setState(() {});

  void onChanged(T? val) {
    _controller!.value = val;

    if (widget.onChanged != null) widget.onChanged!(val);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null && _controller!.value == null) {
      _controller!._value = widget.initialValue;
    }

    return DropdownButton<T>(
        isDense: true,
        isExpanded: widget.isExpanded,
        focusNode: _focusNode,
        items: widget.items,
        hint: widget.hint == null ? null : Text(widget.hint!),
        value: _controller!.value,
        onChanged: onChanged,
        underline: const SizedBox());
  }
}

class CustomDropdownController<T> {
  T? _value;
  late _CustomDropdownState<T> _widget;

  set value(T? value) {
    _value = value;
    _widget.update();
  }

  T? get value => _value;
}
