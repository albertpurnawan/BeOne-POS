import 'package:flutter/material.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyboardWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(VirtualKeyboardKey)? onKeyPress;
  const KeyboardWidget({super.key, required this.controller, this.onKeyPress});

  @override
  State<KeyboardWidget> createState() => _KeyboardWidgetState();
}

class _KeyboardWidgetState extends State<KeyboardWidget> {
  bool shiftEnabled = false;
  bool isNumericMode = false;

  late TextEditingController _controllerText;

  @override
  void initState() {
    _controllerText = TextEditingController();
    super.initState();
  }

  void _defaultOnKeyPress(VirtualKeyboardKey key) {
    String text = widget.controller.text;

    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + ((shiftEnabled ? key.capsText : key.text) ?? '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.isNotEmpty) {
            text = text.substring(0, text.length - 1);
          }
          break;
        case VirtualKeyboardKeyAction.Return:
          if (shiftEnabled) {
            FocusScope.of(context).nextFocus();
          } else {
            text = text + '\n';
          }
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + (key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
          break;
      }
    }

    widget.controller.text = text;
    widget.controller.selection = TextSelection.collapsed(offset: text.length);

    setState(() {});
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
                color: const Color.fromARGB(255, 239, 239, 239),
              ),
              child: VirtualKeyboard(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.7,
                textColor: ProjectColors.primary,
                textController: _controllerText,
                customLayoutKeys: CustomKeyboardLayoutKeys(
                    [shiftEnabled ? VirtualKeyboardDefaultLayouts.Arabic : VirtualKeyboardDefaultLayouts.English]),
                defaultLayouts: const [VirtualKeyboardDefaultLayouts.English, VirtualKeyboardDefaultLayouts.Arabic],
                //reverseLayout :true,
                type: isNumericMode ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
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
  CustomKeyboardLayoutKeys(this.defaultLayouts);

  @override
  int getLanguagesCount() => defaultLayouts.length;

  @override
  List<List> getLanguage(int index) {
    switch (defaultLayouts[index]) {
      case VirtualKeyboardDefaultLayouts.English:
        return _defaultEnglishLayout;
      case VirtualKeyboardDefaultLayouts.Arabic:
        return _defaultShiftLayout;
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
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', VirtualKeyboardKeyAction.Backspace],
  // Row 3
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ':', '"', VirtualKeyboardKeyAction.Return],
  // Row 4
  [VirtualKeyboardKeyAction.Shift, 'z', 'x', 'c', 'v', 'b', 'n', 'm', '<', '>', '?', VirtualKeyboardKeyAction.Shift],
  // Row 5
  [VirtualKeyboardKeyAction.SwithLanguage, '~', VirtualKeyboardKeyAction.Space, '_', '+', '|']
];
