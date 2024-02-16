import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/clickable_ripple.dart';
import 'package:pos_fe/core/widgets/field_label.dart';

class CustomInput extends StatefulWidget {
  const CustomInput(
      {Key? key,
      this.label,
      this.hint,
      this.controller,
      this.validator,
      this.focusNode,
      this.obscureText,
      this.keyboardType,
      this.type,
      this.prefixIcon,
      this.suffixIcon,
      this.isCollapsed,
      this.isDense,
      this.textAlign,
      this.onChanged,
      this.inputFormatters,
      this.maxLines = 1,
      this.onEditingComplete,
      this.autofocus,
      this.textInputAction})
      : super(key: key);

  final String? label, hint;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChanged;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  final bool? obscureText, isCollapsed, isDense, autofocus;
  final TextInputType? keyboardType;
  final CustomInputType? type;
  final Widget? prefixIcon, suffixIcon;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final TextInputAction? textInputAction;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  FocusNode? _focusNode;
  bool? _obscureText;

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _obscureText ??=
        widget.obscureText ?? widget.type == CustomInputType.password;

    if (_focusNode == null) {
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode!.addListener(() {
        setState(() {});
      });
    }

    return FieldLabel(
      color: _focusNode!.hasFocus ? theme.colorScheme.primary : null,
      label: widget.label,
      child: TextFormField(
        textInputAction: widget.textInputAction,
        autofocus: widget.autofocus ?? false,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        controller: widget.controller,
        obscureText: _obscureText!,
        validator: widget.validator,
        focusNode: _focusNode,
        inputFormatters: widget.inputFormatters,
        textAlign: widget.textAlign ?? TextAlign.left,
        keyboardType: widget.keyboardType,
        maxLines: _obscureText! ? 1 : widget.maxLines,
        decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.type == CustomInputType.password
                ? ClickableRipple(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText!;
                      });
                    },
                    child: Icon(_obscureText!
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )
                : widget.suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            isCollapsed: widget.isCollapsed ?? false,
            isDense: widget.isDense,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: ProjectColors.mediumBlack))),
      ),
    );
  }
}

enum CustomInputType { text, password }
