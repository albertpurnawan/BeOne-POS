// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_user.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_open_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OpenShiftDialog extends StatefulWidget {
  const OpenShiftDialog({super.key});

  @override
  State<OpenShiftDialog> createState() => _OpenShiftDialogState();
}

class _OpenShiftDialogState extends State<OpenShiftDialog> {
  late SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  POSParameterModel? posParameter;
  CashRegisterEntity? cashRegister;
  UserEntity? user;
  bool isProcessingOpenShift = false;

  bool _showKeyboard = true;
  final TextEditingController _openValueController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  // late Timer _timer;
  ValueNotifier<String> formattedDate = ValueNotifier<String>(Helpers.formatDate(DateTime.now()));

  @override
  void initState() {
    super.initState();
    populateData();
    getDefaultKeyboardPOSParameter();
  }

  Future<void> populateData() async {
    try {
      final posParametersRes = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      if (posParametersRes.isEmpty) throw "POS Parameter not found";

      final cashRegisterRes =
          await GetIt.instance<GetCashRegisterUseCase>().call(params: posParametersRes[0].tocsrId ?? "");
      if (cashRegisterRes == null) throw "Cash Register not found";

      final tousrId = prefs.getString("tousrId");
      if (tousrId == null) throw "User ID not found";

      final userRes = await GetIt.instance<GetUserUseCase>().call(params: tousrId);
      if (userRes == null) throw "User not found";

      setState(() {
        posParameter = posParametersRes[0];
        cashRegister = cashRegisterRes;
        user = userRes;
      });
    } catch (e) {
      context.pop();
      ErrorHandler.presentErrorSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    _openValueController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
  }

  Future<void> _insertCashierBalanceTransaction(CashierBalanceTransactionModel value) async {
    await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.create(data: value);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            title: Container(
              decoration: const BoxDecoration(
                color: ProjectColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
              ),
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Open Shift',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(360)),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _showKeyboard = !_showKeyboard;
                        });
                      },
                      tooltip: 'Toggle Keyboard',
                    ),
                  ),
                ],
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 234, 234),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.0)),
              ),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Store',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        '${posParameter?.storeName}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Cash Register',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        cashRegister?.description ?? "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Cashier',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        user?.username ?? "",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Opened at',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 8,
                                      child: ValueListenableBuilder(
                                        valueListenable: formattedDate,
                                        builder: (context, value, child) {
                                          return Text(
                                            value,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.fromBorderSide(BorderSide(color: ProjectColors.primary)),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Opening Balance',
                                        style: TextStyle(
                                          color: ProjectColors.mediumBlack,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
                                        constraints: const BoxConstraints(maxWidth: 600),
                                        child: TextFormField(
                                          onEditingComplete: () async {},
                                          controller: _openValueController,
                                          focusNode: _amountFocusNode,
                                          autofocus: true,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              setState(() {
                                                isProcessingOpenShift = false;
                                              });
                                              return 'Please enter a value';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            labelText: "Amount",
                                            hintText: "Enter Amount of Opening Balance",
                                            hintStyle: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                            prefixIcon: Icon(Icons.monetization_on_outlined),
                                            border: OutlineInputBorder(),
                                          ),
                                          inputFormatters: [MoneyInputFormatter()],
                                          keyboardType: TextInputType.none,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      (_showKeyboard)
                                          ? Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: KeyboardWidget(
                                                controller: _openValueController,
                                                isNumericMode: true,
                                                customLayoutKeys: true,
                                                textFormatter: MoneyInputFormatter(),
                                                focusNodeAndTextController: FocusNodeAndTextController(
                                                  focusNode: _amountFocusNode,
                                                  textEditingController: _openValueController,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                          child: TextButton(
                                            style: ButtonStyle(
                                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    side: const BorderSide(color: ProjectColors.primary))),
                                                backgroundColor: MaterialStateColor.resolveWith(
                                                  (states) => const Color.fromARGB(255, 234, 234, 234),
                                                ),
                                                overlayColor: MaterialStateColor.resolveWith(
                                                    (states) => Colors.black.withOpacity(.2))),
                                            onPressed: () {
                                              context.pop(null);
                                            },
                                            child: const Center(
                                                child: Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: ProjectColors.primary, fontWeight: FontWeight.w700),
                                            )),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                        child: CustomButton(
                                          padding: const EdgeInsets.all(0),
                                          onTap: isProcessingOpenShift
                                              ? null
                                              : () async {
                                                  try {
                                                    setState(() {
                                                      isProcessingOpenShift = true;
                                                    });
                                                    if (!formKey.currentState!.validate()) return;

                                                    final inputText = _openValueController.text.replaceAll(',', '');
                                                    final double inputValue = double.tryParse(inputText) ?? 0.0;

                                                    final store = await GetIt.instance<AppDatabase>()
                                                        .storeMasterDao
                                                        .readByDocId(posParameter?.tostrId ?? "", null);
                                                    final storeCode = store!.storeCode;
                                                    final date = DateTime.now();

                                                    String formattedDate = DateFormat('yyMMddHHmmss').format(date);
                                                    final countShift = await GetIt.instance<AppDatabase>()
                                                        .cashierBalanceTransactionDao
                                                        .readByDate(date);

                                                    final number =
                                                        ((countShift!.length) + 1).toString().padLeft(3, '0');
                                                    final docnum = '$storeCode-$formattedDate-$number-S';

                                                    final shiftId = const Uuid().v4();

                                                    final CashierBalanceTransactionModel shift =
                                                        CashierBalanceTransactionModel(
                                                      docId: shiftId,
                                                      createDate: DateTime.now(),
                                                      updateDate: DateTime.now(),
                                                      tocsrId: cashRegister?.docId,
                                                      tousrId: user?.docId,
                                                      docNum: docnum,
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
                                                      openedbyId: user?.docId,
                                                      closedbyId: "",
                                                      approvalStatus: 0,
                                                      refpos: shiftId,
                                                      syncToBos: null,
                                                      closedApproveById: null,
                                                    );
                                                    await _insertCashierBalanceTransaction(shift);
                                                    final CashierBalanceTransactionEntity?
                                                        cashierBalanceTransactionEntity =
                                                        await GetIt.instance<AppDatabase>()
                                                            .cashierBalanceTransactionDao
                                                            .readByDocId(shift.docId, null);
                                                    if (cashierBalanceTransactionEntity == null)
                                                      throw "Open Shift Fail";

                                                    final prefs = GetIt.instance<SharedPreferences>();
                                                    await prefs.setString('tcsr1Id', shift.docId);
                                                    await prefs.setBool('isOpen', true);

                                                    final printOpenShiftUsecase =
                                                        GetIt.instance<PrintOpenShiftUsecase>();
                                                    await printOpenShiftUsecase.call(params: shift, printType: 1);
                                                    await GetIt.instance<OpenCashDrawerUseCase>().call();

                                                    context.pop(shift);
                                                  } catch (e) {
                                                    context.pop(null);
                                                    await prefs.setBool('isOpen', false);
                                                    await prefs.setString('tcsr1Id', "");
                                                    SnackBarHelper.presentErrorSnackBar(context, e.toString());
                                                  }
                                                },
                                          child: isProcessingOpenShift
                                              ? const SizedBox(
                                                  height: 16,
                                                  width: 16,
                                                  child: CircularProgressIndicator(),
                                                )
                                              : const Text("Open Shift"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
