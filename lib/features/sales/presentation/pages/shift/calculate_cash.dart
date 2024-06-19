import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateCash extends StatefulWidget {
  final Function(Map<String, dynamic>) setTotal;

  const CalculateCash({super.key, required this.setTotal});

  @override
  State<CalculateCash> createState() => _CalculateCashState();
}

class _CalculateCashState extends State<CalculateCash> {
  final int maxLength = 10;
  late TextEditingController controller100k;
  late TextEditingController controller50k;
  late TextEditingController controller20k;
  late TextEditingController controller10k;
  late TextEditingController controller5k;
  late TextEditingController controller2k;
  late TextEditingController controller1k;
  late TextEditingController controller1kC;
  late TextEditingController controller500;
  late TextEditingController controller200;
  late TextEditingController controller100;
  late TextEditingController controller50;
  final prefs = GetIt.instance<SharedPreferences>();

  String _totalCash = '0';

  @override
  void initState() {
    super.initState();
    controller100k = TextEditingController();
    controller50k = TextEditingController();
    controller20k = TextEditingController();
    controller10k = TextEditingController();
    controller5k = TextEditingController();
    controller2k = TextEditingController();
    controller1k = TextEditingController();
    controller500 = TextEditingController();
    controller200 = TextEditingController();
    controller100 = TextEditingController();
    controller50 = TextEditingController();
    _changeTotalCash([]);
  }

  @override
  void dispose() {
    controller100k.dispose();
    controller50k.dispose();
    controller20k.dispose();
    controller10k.dispose();
    controller5k.dispose();
    controller2k.dispose();
    controller1k.dispose();
    controller500.dispose();
    controller200.dispose();
    controller100.dispose();
    controller50.dispose();
    super.dispose();
  }

  void _changeTotalCash(List values) {
    widget.setTotal({
      '100k': controller100k.text,
      '50k': controller50k.text,
      '20k': controller20k.text,
      '10k': controller10k.text,
      '5k': controller5k.text,
      '1k': controller1k.text,
      '500': controller500.text,
      '200': controller200.text,
      '100': controller100.text,
      '50': controller50.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    // double calculateContainerWidth(int maxLength, double fontSize) {
    //   return (maxLength * 10) + (fontSize * 2);
    // }

    // double containerWidth = calculateContainerWidth(maxLength, 20);

    String total100k = calculateTotal100k(
        controller100k.text.isEmpty ? '0' : controller100k.text);
    String total50k = calculateTotal50k(
        controller50k.text.isEmpty ? '0' : controller50k.text);
    String total20k = calculateTotal20k(
        controller20k.text.isEmpty ? '0' : controller20k.text);
    String total10k = calculateTotal10k(
        controller10k.text.isEmpty ? '0' : controller10k.text);
    String total5k =
        calculateTotal5k(controller5k.text.isEmpty ? '0' : controller5k.text);
    String total2k =
        calculateTotal2k(controller2k.text.isEmpty ? '0' : controller2k.text);
    String total1k =
        calculateTotal1k(controller1k.text.isEmpty ? '0' : controller1k.text);
    String total500 = calculateTotal500(
        controller500.text.isEmpty ? '0' : controller500.text);
    String total200 = calculateTotal200(
        controller200.text.isEmpty ? '0' : controller200.text);
    String total100 = calculateTotal100(
        controller100.text.isEmpty ? '0' : controller100.text);
    String total50 =
        calculateTotal50(controller50.text.isEmpty ? '0' : controller50.text);

    List cashes = [
      total100k,
      total50k,
      total20k,
      total10k,
      total5k,
      total2k,
      total1k,
      total500,
      total200,
      total100,
      total50,
    ];

    _totalCash = calculateTotalCash(cashes);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 100,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller100k,
                onChanged: (value) {
                  setState(() {
                    total100k = calculateTotal100k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total100k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 50,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller50k,
                onChanged: (value) {
                  setState(() {
                    total50k = calculateTotal50k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total50k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 20,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller20k,
                onChanged: (value) {
                  setState(() {
                    total20k = calculateTotal20k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total20k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 10,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller10k,
                onChanged: (value) {
                  setState(() {
                    total10k = calculateTotal10k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total10k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 5,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller5k,
                onChanged: (value) {
                  setState(() {
                    total5k = calculateTotal5k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total5k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 2,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller2k,
                onChanged: (value) {
                  setState(() {
                    total2k = calculateTotal2k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total2k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 1,000",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller1k,
                onChanged: (value) {
                  setState(() {
                    total1k = calculateTotal1k(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total1k,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 500",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller500,
                onChanged: (value) {
                  setState(() {
                    total500 = calculateTotal500(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total500,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 200",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller200,
                onChanged: (value) {
                  setState(() {
                    total200 = calculateTotal200(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total200,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 100",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller100,
                onChanged: (value) {
                  setState(() {
                    total100 = calculateTotal100(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total100,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Rp 50",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller50,
                onChanged: (value) {
                  setState(() {
                    total50 = calculateTotal50(value);
                    _changeTotalCash([
                      total100k,
                      total50k,
                      total20k,
                      total10k,
                      total5k,
                      total2k,
                      total1k,
                      total500,
                      total200,
                      total100,
                      total50,
                    ]);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.only(bottom: 8.0),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 300,
              child: Text(
                total50,
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Total Cash",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const Expanded(
              child: Text(""),
            ),
            SizedBox(
              width: 300,
              child: Text(
                _totalCash,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const Divider(
          height: 50,
          color: Colors.grey,
        ),
      ],
    );
  }
}

String calculateTotal100k(String text) {
  int? quantity100k = int.tryParse(text);
  int total100kValue = quantity100k != null ? (100000 * quantity100k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total100k = formatter.format(total100kValue);

  // widget.setTotal(total100k);
  return total100k;
}

String calculateTotal50k(String text) {
  int? quantity50k = int.tryParse(text);
  int total50kValue = quantity50k != null ? (50000 * quantity50k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total50k = formatter.format(total50kValue);

  return total50k;
}

String calculateTotal20k(String text) {
  int? quantity20k = int.tryParse(text);
  int total20kValue = quantity20k != null ? (20000 * quantity20k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total20k = formatter.format(total20kValue);

  return total20k;
}

String calculateTotal10k(String text) {
  int? quantity10k = int.tryParse(text);
  int total10kValue = quantity10k != null ? (10000 * quantity10k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total10k = formatter.format(total10kValue);

  return total10k;
}

String calculateTotal5k(String text) {
  int? quantity5k = int.tryParse(text);
  int total5kValue = quantity5k != null ? (5000 * quantity5k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total5k = formatter.format(total5kValue);

  return total5k;
}

String calculateTotal2k(String text) {
  int? quantity2k = int.tryParse(text);
  int total2kValue = quantity2k != null ? (2000 * quantity2k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total2k = formatter.format(total2kValue);

  return total2k;
}

String calculateTotal1k(String text) {
  int? quantity1k = int.tryParse(text);
  int total1kValue = quantity1k != null ? (1000 * quantity1k) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total1k = formatter.format(total1kValue);

  return total1k;
}

String calculateTotal500(String text) {
  int? quantity500 = int.tryParse(text);
  int total500Value = quantity500 != null ? (500 * quantity500) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total500 = formatter.format(total500Value);

  return total500;
}

String calculateTotal200(String text) {
  int? quantity200 = int.tryParse(text);
  int total200Value = quantity200 != null ? (200 * quantity200) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total200 = formatter.format(total200Value);

  return total200;
}

String calculateTotal100(String text) {
  int? quantity100 = int.tryParse(text);
  int total100Value = quantity100 != null ? (100 * quantity100) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total100 = formatter.format(total100Value);

  return total100;
}

String calculateTotal50(String text) {
  int? quantity50 = int.tryParse(text);
  int total50Value = quantity50 != null ? (50 * quantity50) : 0;

  NumberFormat formatter = NumberFormat.decimalPattern();
  String total50 = formatter.format(total50Value);

  return total50;
}

String calculateTotalCash(List cashes) {
  double total = 0;
  for (String cash in cashes) {
    total += double.tryParse(cash.replaceAll(',', '')) ?? 0;
  }
  NumberFormat formatter = NumberFormat.decimalPattern();
  String totalCash = formatter.format(total);
  return totalCash;
}
