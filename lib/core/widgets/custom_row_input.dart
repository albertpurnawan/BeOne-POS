import 'package:flutter/material.dart';
import 'package:pos_fe/core/widgets/field_label.dart';

class CustomRowInput extends StatefulWidget {
  const CustomRowInput({
    Key? key,
    required this.leftText,
    this.controller,
    this.validator,
    this.isCollapsed,
    this.isDense,
    this.autofocus,
    this.keyboardType,
    this.onChanged,
    this.label,
    this.hint,
    this.maxLines = 1,
    this.onEditingComplete,
    this.focusNode,
    this.textAlign,
    this.textInputAction,
  }) : super(key: key);

  final String leftText;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool? isCollapsed, isDense, autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String? value)? onChanged;
  final String? label, hint;
  final void Function()? onEditingComplete;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextAlign? textAlign;

  @override
  State<CustomRowInput> createState() => _CustomRowInputState();
}

class _CustomRowInputState extends State<CustomRowInput> {
  FocusNode? _focusNode;

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_focusNode == null) {
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode!.addListener(() {
        setState(() {});
      });
    }

    return FieldLabel(
      color: _focusNode!.hasFocus ? theme.colorScheme.primary : null,
      label: widget.label,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Text(
                widget.leftText,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 18),
                    autofocus: widget.autofocus ?? false,
                    onEditingComplete: widget.onEditingComplete,
                    onChanged: widget.onChanged,
                    controller: widget.controller,
                    validator: widget.validator,
                    focusNode: _focusNode,
                    textAlign: widget.textAlign ?? TextAlign.right,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    maxLines: widget.maxLines,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 5),
                      isCollapsed: widget.isCollapsed ?? false,
                      isDense: widget.isDense,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

enum CustomInputType { text }
