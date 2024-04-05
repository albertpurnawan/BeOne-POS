import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/settings/domain/usecases/get_pos_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OpenShiftScreen extends StatefulWidget {
  const OpenShiftScreen({super.key});

  @override
  State<OpenShiftScreen> createState() => _OpenShiftScreenState();
}

class _OpenShiftScreenState extends State<OpenShiftScreen> {
  late Timer _timer;
  String formattedDate = Helpers.formatDate(DateTime.now());
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();

  Future<POSParameterEntity?> getPosParameter() async {
    return GetIt.instance<GetPosParameterUseCase>().call();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        formattedDate = Helpers.formatDate(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ProjectColors.swatch,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return FutureBuilder<POSParameterEntity?>(
      future: getPosParameter(),
      builder: (context, snapshot) {
        final storeName = snapshot.data?.storeName ?? 'Loading...';
        final cashier = prefs.getString('username');

        return Scaffold(
          backgroundColor: Colors.white,
          body: ScrollWidget(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height / 2) - 350,
                ),
                Text(
                  'Opening Shift - $storeName',
                  style: const TextStyle(
                    color: ProjectColors.swatch,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cashier: $cashier',
                  style: const TextStyle(
                    color: ProjectColors.mediumBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Start: $formattedDate',
                  style: const TextStyle(
                    color: ProjectColors.mediumBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Opening Balance:',
                  style: TextStyle(
                    color: ProjectColors.swatch,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const StartShiftForm(),
                const SizedBox(height: 25),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ), // Adjust the borderRadius value as needed
                        ),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StartShiftForm extends StatefulWidget {
  const StartShiftForm({Key? key}) : super(key: key);

  @override
  State<StartShiftForm> createState() => _StartShiftFormState();
}

class _StartShiftFormState extends State<StartShiftForm> {
  late TextEditingController openValueController;
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();

  Future<String> getStoreName() async {
    final String? storeId = prefs.getString("tostrId");
    final store = await GetIt.instance<AppDatabase>()
        .storeMasterDao
        .readByDocId(storeId!);
    final storeName = store!.storeName;
    return storeName;
  }

  void _insertCashierBalanceTransaction(
      CashierBalanceTransactionModel value) async {
    await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .create(data: value);
  }

  @override
  void initState() {
    super.initState();
    openValueController = TextEditingController();
    getStoreName();
  }

  @override
  void dispose() {
    super.dispose();
    openValueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: openValueController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                // final isNumeric = double.tryParse(value);
                // if (isNumeric == null) {
                //   return 'Please enter a valid number';
                // }
                return null;
              },
              // label: "Openvalue",
              inputFormatters: [MoneyInputFormatter()],
              keyboardType: TextInputType.number,
              hint: "Enter Amount of Opening Balance",
              prefixIcon: const Icon(Icons.monetization_on_outlined),
            ),
          ),
          const SizedBox(height: 75),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomButton(
              child: const Text("Open Shift"),
              onTap: () async {
                if (!formKey.currentState!.validate()) return;

                final prefs = GetIt.instance<SharedPreferences>();
                await prefs.setBool('isOpen', true);

                final double inputValue =
                    double.tryParse(openValueController.text) ?? 0.0;

                final CashierBalanceTransactionModel shift =
                    CashierBalanceTransactionModel(
                  docId: const Uuid().v4(),
                  createDate: DateTime.now(),
                  updateDate: DateTime.now(),
                  tocsrId: "4ca46d3e-30ff-4441-98f8-3fdcf81dc230",
                  tousrId: "fab056fa-b206-4360-8c35-568407651827",
                  docNum: "", // need edit
                  openDate: DateTime.now(),
                  openTime: DateTime.now(),
                  calcDate: DateTime.utc(1970, 1, 1),
                  calcTime: DateTime.utc(1970, 1, 1),
                  closeDate: DateTime.utc(1970, 1, 1),
                  closeTime: DateTime.utc(1970, 1, 1),
                  timezone: "GMT+07",
                  openValue: inputValue,
                  calcValue: 0,
                  cashValue: 0,
                  closeValue: 0,
                  openedbyId: "",
                  closedbyId: "",
                  approvalStatus: 0,
                );
                _insertCashierBalanceTransaction(shift);

                await prefs.setString('tcsr1Id', shift.docId);

                if (!context.mounted) return;
                if (context.mounted) context.pushNamed(RouteConstants.home);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const SalesPage()),
                // );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class StartShiftFormFields extends StatelessWidget {
  const StartShiftFormFields({
    Key? key,
    this.validator,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    required this.label,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  final String? Function(String? val)? validator;
  final Widget? prefix, prefixIcon, suffix, suffixIcon;
  final String label;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(Object context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(bottom: 10),
          prefixIcon: prefixIcon,
          prefix: prefix,
          suffixIcon: suffixIcon,
          suffix: suffix,
          labelText: label),
    );
  }
}
