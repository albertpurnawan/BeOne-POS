import 'package:flutter/services.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!RegExp(r"\d+(\.\d+)?").hasMatch(newValue.text)) {
      return oldValue;
    }

    if (newValue.text.isEmpty) {
      return const TextEditingValue(
          text: "0", selection: TextSelection.collapsed(offset: 1));
    }

    return newValue;
  }
}

class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final value =
        Helpers.parseMoney(Helpers.revertMoneyToDecimalFormat(newValue.text));

    return TextEditingValue(
        text: value, selection: TextSelection.collapsed(offset: value.length));
  }
}

class MoneyInputFormatterDouble extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int dotCounts = newValue.text.split("").where((e) => e == ".").length;

    if (dotCounts > 1) {
      return TextEditingValue(
          text: oldValue.text,
          selection: TextSelection.collapsed(offset: oldValue.text.length));
    }

    if (newValue.text != "" &&
        newValue.text[newValue.text.length - 1] == "." &&
        dotCounts == 1) {
      return TextEditingValue(
          text: newValue.text,
          selection: TextSelection.collapsed(offset: newValue.text.length));
    }
    final value = Helpers.parseMoney(
        Helpers.revertMoneyToDecimalFormatDouble(newValue.text));

    return TextEditingValue(
        text: value, selection: TextSelection.collapsed(offset: value.length));
  }
}
