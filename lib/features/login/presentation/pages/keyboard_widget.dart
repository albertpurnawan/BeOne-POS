import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyboardWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isNumericMode;
  final void Function(VirtualKeyboardKey)? onKeyPress;
  final void Function()? onChanged;
  final void Function()? onChangedBackspace;
  final void Function()? onSubmit;
  final bool customLayoutKeys;
  final bool? isShiftEnabled;
  final double? height;
  final FocusNodeAndTextController? focusNodeAndTextController;
  final TextInputFormatter? textFormatter;
  final bool enableNewLine;

  const KeyboardWidget({
    super.key,
    required this.controller,
    required this.isNumericMode,
    this.onKeyPress,
    this.onChanged,
    this.onChangedBackspace,
    this.onSubmit,
    this.height,
    this.isShiftEnabled,
    this.focusNodeAndTextController,
    this.textFormatter,
    required this.customLayoutKeys,
    this.enableNewLine = false,
  });

  @override
  State<KeyboardWidget> createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends State<KeyboardWidget> {
  bool _isNumericMode = false;
  double _height = 0;

  // Timer? _backspaceTimer;

  bool _shiftEnabled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isNumericMode = widget.isNumericMode;
      _height = widget.height ?? 250;
    });
  }

  @override
  void didUpdateWidget(KeyboardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isNumericMode != widget.isNumericMode) {
      setState(() {
        _isNumericMode = widget.isNumericMode;
      });
    }
  }

  // void _startBackspaceRepeater(VoidCallback onBackspace) {
  //   _stopBackspaceRepeater();

  //   onBackspace();

  //   _backspaceTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
  //     onBackspace();
  //   });
  // }

  // void _stopBackspaceRepeater() {
  //   _backspaceTimer?.cancel();
  //   _backspaceTimer = null;
  // }

  void _defaultPostKeyPress(VirtualKeyboardKey key) {
    String text = widget.focusNodeAndTextController?.textEditingController.text ?? widget.controller.text;
    TextSelection currentSelection =
        widget.focusNodeAndTextController?.textEditingController.selection ?? widget.controller.selection;
    int cursorPosition = currentSelection.start;

    if (key.keyType == VirtualKeyboardKeyType.String) {
      (widget.onChanged != null) ? widget.onChanged!() : null;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Return:
          if (widget.onSubmit != null) {
            widget.onSubmit!();
          }
          if (text.isNotEmpty && cursorPosition > 0 && widget.enableNewLine == false) {
            text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
            cursorPosition -= 1;
          }
          break;
        case VirtualKeyboardKeyAction.Backspace:
          if (widget.onChangedBackspace != null) {
            widget.onChangedBackspace!();
          } else {
            (widget.onChanged != null) ? widget.onChanged!() : null;
          }
          break;
        case VirtualKeyboardKeyAction.Shift:
          setState(() {
            _shiftEnabled = !_shiftEnabled;
          });
          break;
        case VirtualKeyboardKeyAction.Space:
        case VirtualKeyboardKeyAction.SwithLanguage:
        default:
          (widget.onChanged != null) ? widget.onChanged!() : null;
          break;
      }
    }

    if (widget.textFormatter != null) {
      TextEditingValue formattedValue = widget.textFormatter!.formatEditUpdate(
        TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: cursorPosition),
        ),
        TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: cursorPosition),
        ),
      );
      widget.focusNodeAndTextController?.textEditingController.text = formattedValue.text;
      widget.focusNodeAndTextController?.textEditingController.selection = formattedValue.selection;

      setState(() {});
    } else {
      widget.focusNodeAndTextController?.textEditingController.text = text;
      widget.focusNodeAndTextController?.textEditingController.selection =
          TextSelection.collapsed(offset: cursorPosition);

      setState(() {});
    }
  }

  void _defaultPreKeyPress(VirtualKeyboardKey key) {
    if (widget.focusNodeAndTextController != null) {
      if (!widget.focusNodeAndTextController!.focusNode.hasFocus) {
        widget.focusNodeAndTextController?.focusNode.requestFocus();
      }

      TextEditingController controller = widget.focusNodeAndTextController!.textEditingController;
      TextSelection currentSelection = controller.selection;

      widget.focusNodeAndTextController?.textEditingController.value = TextEditingValue(
        text: controller.text,
        selection: currentSelection.isValid
            ? currentSelection
            : TextSelection.collapsed(
                offset: controller.text.length,
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FocusScope(
        canRequestFocus: false,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 245, 245, 245),
              ),
              child: VirtualKeyboard(
                height: _height,
                width: MediaQuery.of(context).size.width * 1,
                textColor: ProjectColors.primary,
                textController: widget.focusNodeAndTextController?.textEditingController ?? widget.controller,
                customLayoutKeys: widget.customLayoutKeys
                    ? CustomKeyboardLayoutKeys([
                        (_shiftEnabled == true)
                            ? VirtualKeyboardDefaultLayouts.Arabic
                            : VirtualKeyboardDefaultLayouts.English
                      ], _shiftEnabled)
                    : null,
                defaultLayouts: const [VirtualKeyboardDefaultLayouts.English, VirtualKeyboardDefaultLayouts.Arabic],
                //reverseLayout :true,
                type: _isNumericMode ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
                postKeyPress: _defaultPostKeyPress,
                preKeyPress: _defaultPreKeyPress,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomKeyboardLayoutKeys extends VirtualKeyboardLayoutKeys {
  List<VirtualKeyboardDefaultLayouts> defaultLayouts;
  bool isShiftEnabled;
  CustomKeyboardLayoutKeys(this.defaultLayouts, this.isShiftEnabled);

  @override
  int getLanguagesCount() => defaultLayouts.length;

  @override
  List<List> getLanguage(int index) {
    switch (defaultLayouts[index]) {
      case VirtualKeyboardDefaultLayouts.English:
        return isShiftEnabled ? _defaultShiftLayout : _defaultEnglishLayout;
      case VirtualKeyboardDefaultLayouts.Arabic:
        return _defaultArabicLayout;
      default:
    }
    return _defaultEnglishLayout;
  }
}

const List<List> _defaultEnglishLayout = [
  // Row 1
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  // Row 2
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', VirtualKeyboardKeyAction.Backspace],
  // Row 3
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', VirtualKeyboardKeyAction.Return],
  // Row 4
  [VirtualKeyboardKeyAction.Shift, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', VirtualKeyboardKeyAction.Shift],
  // Row 5
  [VirtualKeyboardKeyAction.SwithLanguage, '`', VirtualKeyboardKeyAction.Space, '-', '=', '\\']
];

const List<List> _defaultShiftLayout = [
  // Row 1
  ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')'],
  // Row 2
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', VirtualKeyboardKeyAction.Backspace],
  // Row 3
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', VirtualKeyboardKeyAction.Return],
  // Row 4
  [VirtualKeyboardKeyAction.Shift, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', VirtualKeyboardKeyAction.Shift],
  // Row 5
  [VirtualKeyboardKeyAction.SwithLanguage, '~', VirtualKeyboardKeyAction.Space, '_', '+', '|']
];

const List<List> _defaultArabicLayout = [
  // Row 1
  ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')'],
  // Row 2
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', VirtualKeyboardKeyAction.Backspace],
  // Row 3
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', VirtualKeyboardKeyAction.Return],
  // Row 4
  [VirtualKeyboardKeyAction.Shift, 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', VirtualKeyboardKeyAction.Shift],
  // Row 5
  [VirtualKeyboardKeyAction.SwithLanguage, '~', VirtualKeyboardKeyAction.Space, '_', '+', '|']
];

class FocusNodeAndTextController {
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  FocusNodeAndTextController({
    required this.focusNode,
    required this.textEditingController,
  });
}
