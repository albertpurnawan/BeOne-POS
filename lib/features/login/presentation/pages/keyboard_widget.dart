import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyboardWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isNumericMode;
  final void Function(VirtualKeyboardKey)? onKeyPress;
  final bool customLayoutKeys;
  final bool? isShiftEnabled;
  final double? height;
  const KeyboardWidget({
    super.key,
    required this.controller,
    required this.isNumericMode,
    this.onKeyPress,
    this.height,
    this.isShiftEnabled,
    required this.customLayoutKeys,
  });

  @override
  State<KeyboardWidget> createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends State<KeyboardWidget> {
  bool _shiftEnabled = false;
  bool _isNumericMode = false;
  double _height = 0;

  // Timer? _backspaceTimer;

  late TextEditingController _controllerText;

  @override
  void initState() {
    super.initState();
    _controllerText = TextEditingController();
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

  void _defaultOnKeyPress(VirtualKeyboardKey key) {
    String text = widget.controller.text;
    TextSelection currentSelection = widget.controller.selection;
    int cursorPosition = currentSelection.start;

    if (key.keyType == VirtualKeyboardKeyType.String) {
      String inputText = (_shiftEnabled ? key.capsText : key.text) ?? '';
      text = text.replaceRange(cursorPosition, cursorPosition, inputText);
      cursorPosition += inputText.length;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          // _startBackspaceRepeater(() {
          if (text.isNotEmpty && cursorPosition > 0) {
            text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
            cursorPosition -= 1;
          }
          // });
          break;

        case VirtualKeyboardKeyAction.Return:
          if (_shiftEnabled) {
            FocusScope.of(context).nextFocus();
          } else {
            text = text.replaceRange(cursorPosition, cursorPosition, '\n');
            cursorPosition += 1;
          }
          break;

        case VirtualKeyboardKeyAction.Space:
          text = text.replaceRange(cursorPosition, cursorPosition, ' ');
          cursorPosition += 1;
          break;

        case VirtualKeyboardKeyAction.Shift:
          _shiftEnabled = !_shiftEnabled;
          break;

        default:
          break;
      }
    }

    widget.controller.text = text;
    widget.controller.selection = TextSelection.collapsed(offset: cursorPosition);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log("${widget.isShiftEnabled}");
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
                textController: _controllerText,
                customLayoutKeys: widget.customLayoutKeys
                    ? CustomKeyboardLayoutKeys([
                        (widget.isShiftEnabled != null && widget.isShiftEnabled == true)
                            ? VirtualKeyboardDefaultLayouts.Arabic
                            : VirtualKeyboardDefaultLayouts.English
                      ], _shiftEnabled)
                    : null,
                defaultLayouts: const [VirtualKeyboardDefaultLayouts.English, VirtualKeyboardDefaultLayouts.Arabic],
                //reverseLayout :true,
                type: _isNumericMode ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
                postKeyPress: (widget.onKeyPress != null) ? widget.onKeyPress : _defaultOnKeyPress,
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
