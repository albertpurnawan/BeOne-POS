import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/backup_database_usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/navigation_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:pos_fe/features/sales/data/models/money_denomination.dart';
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_open_shift.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/calculate_cash.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/close_shift_success_alert_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirmation_dialog.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/cashier_balance_transactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CloseShiftScreen extends StatefulWidget {
  final String shiftId;
  final String? username;
  const CloseShiftScreen({Key? key, required this.shiftId, this.username}) : super(key: key);

  @override
  State<CloseShiftScreen> createState() => CloseShiftScreenState();
}

class CloseShiftScreenState extends State<CloseShiftScreen> {
  bool _showKeyboard = false;
  bool _shiftEnabled = false;
  final FocusNode _keyboardFocusNode = FocusNode();
  TextEditingController _activeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getDefaultKeyboardPOSParameter();
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _activeController.dispose();
    super.dispose();
  }

  // Future<void> getDefaultKeyboardPOSParameter() async {
  //   try {
  //     final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
  //     if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";

  //     if (mounted) {
  //       setState(() {
  //         _showKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       SnackBarHelper.presentFailSnackBar(context, e.toString());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        title: const Text('Close Shift'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Container(
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
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  CloseShiftForm(
                    shiftId: widget.shiftId,
                    username: widget.username ?? "",
                    currentController: _activeController,
                    onControllerProvided: (controller) {
                      setState(() {
                        _activeController = controller;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          (_showKeyboard)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: KeyboardWidget(
                    controller: _activeController,
                    isNumericMode: true,
                    customLayoutKeys: true,
                    onKeyPress: (key) async {
                      String text = _activeController.text;
                      TextSelection currentSelection = _activeController.selection;
                      int cursorPosition = currentSelection.start;

                      if (key.keyType == VirtualKeyboardKeyType.String) {
                        String inputText = (_shiftEnabled ? key.capsText : key.text) ?? '';
                        text = text.replaceRange(cursorPosition, cursorPosition, inputText);
                        cursorPosition += inputText.length;
                      } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                        switch (key.action) {
                          case VirtualKeyboardKeyAction.Backspace:
                            if (text.isNotEmpty && cursorPosition > 0) {
                              text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                              cursorPosition -= 1;
                            }
                            break;
                          case VirtualKeyboardKeyAction.Return:
                            _activeController.text = _activeController.text.trimRight();

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
                      _activeController.text = text;
                      _activeController.selection = TextSelection.collapsed(offset: cursorPosition);

                      setState(() {});
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CloseShiftForm extends StatefulWidget {
  final String shiftId;
  final String? username;
  final TextEditingController currentController;
  final Function(TextEditingController) onControllerProvided;

  const CloseShiftForm({
    Key? key,
    required this.shiftId,
    this.username,
    required this.currentController,
    required this.onControllerProvided,
  }) : super(key: key);

  @override
  State<CloseShiftForm> createState() => _CloseShiftFormState();
}

class _CloseShiftFormState extends State<CloseShiftForm> {
  late final String shiftId = widget.shiftId;
  CashierBalanceTransactionModel? activeShift;
  late List<InvoiceHeaderModel?> transactions = [];
  late List<InvoiceHeaderModel?> transactionsReturn = [];
  late List<dynamic> transactionsMOP = [];
  late List<PaymentTypeModel> transactionsTopmt = [];
  late List<MeansOfPaymentModel> transactionsTpmt1 = [];
  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  String totalCashAmount = '0';
  String totalNonCash = '0';
  String totalVouchers = '0';
  String totalVouchersUsed = '0';
  String totalSales = '0';
  String expectedCash = "0";
  String calculatedTotalCash = '0';
  String difference = "0";
  bool checkLastShift = false;
  Map<String, dynamic>? denomination;
  UserEntity? closeShiftApproverUser;
  EmployeeEntity? closeShiftApproverEmployee;
  UserEntity? openShiftApproverUser;
  EmployeeEntity? openShiftApproverEmployee;
  bool isPrinting = false;
  late TextEditingController _currentController;

  final tableHeader = ["No", "Means of Payment", "Amount"];
  List<dynamic> tableData = [];

  @override
  void initState() {
    super.initState();
    _currentController = widget.currentController;
    fetchData();
  }

  @override
  void dispose() {
    _currentController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    await fetchActiveShift();
    await fetchInvoices();
    await updateActiveShift();
    await fetchOpenShiftApprover();
    await fetchCloseShiftApprover();
    await checkLastShiftId();
    await fetchMOPByInvoice();
  }

  Future<void> fetchCloseShiftApprover() async {
    try {
      final UserEntity? user = await GetIt.instance<AppDatabase>().userDao.readByUsername(widget.username!, null);

      if (user == null) throw "User not found";
      setState(() {
        closeShiftApproverUser = user;
      });

      if (user.tohemId == null) throw "Employee ID not found in user";
      final EmployeeEntity? employee = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(user.tohemId!, null);

      if (employee == null) throw "Employee not found";
      setState(() {
        closeShiftApproverEmployee = employee;
      });

      return;
    } catch (e) {
      log("$e when fetch close shift approver");
    }
  }

  Future<void> fetchOpenShiftApprover() async {
    try {
      if (activeShift == null) throw "Active shift not found";
      final UserEntity? user = await GetIt.instance<AppDatabase>().userDao.readByDocId(activeShift!.openedbyId!, null);

      if (user == null) throw "User not found";
      setState(() {
        openShiftApproverUser = user;
      });

      if (user.tohemId == null) throw "Employee ID not found in user";
      final EmployeeEntity? employee = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(user.tohemId!, null);

      if (employee == null) throw "Employee not found";
      setState(() {
        openShiftApproverEmployee = employee;
      });

      return;
    } catch (e) {
      log("$e when fetch open shift approver");
    }
  }

  Future<void> fetchActiveShift() async {
    final shift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocId(shiftId, null);
    setState(() {
      activeShift = shift;
      expectedCash = Helpers.parseMoney(shift?.openValue ?? 0);
      difference = Helpers.parseMoney(
          Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) - Helpers.revertMoneyToDecimalFormat(expectedCash));
    });
  }

  Future<void> checkLastShiftId() async {
    final lastShift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readLastValue();
    if (lastShift!.docId == activeShift!.docId) {
      setState(() {
        checkLastShift = true;
      });
    } else {
      setState(() {
        checkLastShift = false;
      });
    }
    log("lastShift 2 - $checkLastShift");
  }

  Future<void> backupDatabase() async {}

  Future<void> fetchInvoices() async {
    final transaction = await GetIt.instance<AppDatabase>().invoiceHeaderDao.readByShift(shiftId);

    for (var i = 0; i < transaction.length; i++) {
      final tinv1s =
          await GetIt.instance<AppDatabase>().invoiceDetailDao.readByToinvId(transaction[i].docId ?? "", null);
      if (tinv1s.isNotEmpty) {
        for (var j = 0; j < tinv1s.length; j++) {
          if (tinv1s[j].refpos3 != null && tinv1s[j].refpos3 != "") {
            setState(() {
              transactionsReturn.add(transaction[i]);
            });
          }
        }
      }
    }
    setState(() {
      transactions = transaction;
    });
  }

  void updateTotalCash(Map<String, String> total) {
    setState(() {
      int totalCash = 0;
      for (String key in total.keys) {
        totalCash += (Helpers.revertMoneyToDecimalFormat(total[key] == "" ? "0" : total[key]!) *
                int.parse(key.replaceAll('k', "000")))
            .round();
      }
      calculatedTotalCash = Helpers.parseMoney(totalCash);
      denomination = total;
      difference = Helpers.parseMoney(
          Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) - Helpers.revertMoneyToDecimalFormat(expectedCash));
    });
  }

  Future<void> updateActiveShift() async {
    if (activeShift != null && transactions.isNotEmpty) {
      double nonCash = 0.0;
      double totalVoucher = 0.0;
      double totalVoucherUsed = 0.0;
      double cashAmount = 0.0;
      double salesAmount = 0.0;
      final DateTime now = DateTime.now();
      final start = activeShift!.openDate.subtract(Duration(hours: DateTime.now().timeZoneOffset.inHours));
      final end = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      );

      final fetched = await GetIt.instance<AppDatabase>().payMeansDao.readByTpmt3BetweenDate(start, end);
      for (final mop in fetched!) {
        String mopStringUp = mop['topmtDesc'].toString().toUpperCase();
        if (mopStringUp != 'TUNAI') {
          if (mopStringUp == 'VOUCHER') {
            totalVoucher += mop['totalamount'];
          } else {
            nonCash += mop['totalamount'];
          }
        } else {
          cashAmount += mop['totalamount'];
        }
      }

      for (final trx in transactions) {
        if (trx != null) {
          salesAmount += trx.grandTotal;
          CashierBalanceTransactionModel data = CashierBalanceTransactionModel(
            docId: activeShift!.docId,
            createDate: activeShift!.createDate,
            updateDate: activeShift!.updateDate,
            tocsrId: activeShift!.tocsrId,
            tousrId: activeShift!.tousrId,
            docNum: activeShift!.docNum,
            openDate: activeShift!.openDate,
            openTime: activeShift!.openTime,
            calcDate: DateTime.now(),
            calcTime: DateTime.now(),
            closeDate: activeShift!.closeDate,
            closeTime: activeShift!.closeTime,
            timezone: activeShift!.timezone,
            openValue: activeShift!.openValue,
            calcValue: activeShift!.calcValue,
            cashValue: cashAmount,
            closeValue: activeShift!.closeValue,
            openedbyId: activeShift!.openedbyId,
            closedbyId: activeShift!.closedbyId,
            approvalStatus: activeShift!.approvalStatus,
            refpos: activeShift!.docId,
            syncToBos: activeShift!.syncToBos,
            closedApproveById: activeShift!.closedApproveById,
          );

          // await GetIt.instance<AppDatabase>()
          //     .cashierBalanceTransactionDao
          //     .update(docId: shiftId, data: data);
          setState(() {
            totalVoucherUsed = salesAmount - cashAmount - nonCash;
            nonCash += totalVoucherUsed;
          });

          setState(() {
            activeShift = data;
            totalNonCash = NumberFormat.decimalPattern().format(nonCash);
            // totalVouchers = NumberFormat.decimalPattern().format(totalVoucher);
            // totalVouchersUsed = NumberFormat.decimalPattern().format(totalVoucherUsed);
            totalSales = NumberFormat.decimalPattern().format(salesAmount);
            totalCashAmount = NumberFormat.decimalPattern().format(cashAmount);
            expectedCash = NumberFormat.decimalPattern().format(data.openValue + (cashAmount));
            difference = Helpers.parseMoney(Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) -
                Helpers.revertMoneyToDecimalFormat(expectedCash));
          });
        }
      }
    }
  }

  Future<void> fetchMOPByInvoice() async {
    for (var i = 0; i < transactions.length; i++) {
      final payMean =
          await GetIt.instance<AppDatabase>().payMeansDao.readByToinvShowTopmt(transactions[i]!.docId.toString());
      if (payMean != null && payMean.isNotEmpty) {
        for (var j = 0; j < payMean.length; j++) {
          transactionsMOP.add(payMean[j]);
        }
      }
    }
    for (var i = 0; i < transactionsMOP.length; i++) {
      final tpmt3 = await GetIt.instance<AppDatabase>().mopByStoreDao.readByDocId(transactionsMOP[i]["tpmt3Id"], null);
      if (tpmt3 == null) throw "Failed retrieve tpmt3";
      final tpmt1 = await GetIt.instance<AppDatabase>().meansOfPaymentDao.readByDocId(tpmt3.tpmt1Id ?? "", null);
      if (tpmt1 == null) throw "Failed retrieve tpmt1";
      final topmt = await GetIt.instance<AppDatabase>().paymentTypeDao.readByDocId(tpmt1.topmtId ?? "", null);
      if (topmt == null) throw "Failed retrieve topmt";
      transactionsTopmt.add(topmt);
      transactionsTpmt1.add(tpmt1);
    }

    setState(() {
      transactionsTopmt = transactionsTopmt
          .fold<Map<String, PaymentTypeModel>>({}, (map, transaction) {
            map[transaction.docId] = transaction;
            return map;
          })
          .values
          .toList();

      transactionsTpmt1 = transactionsTpmt1
          .fold<Map<String, MeansOfPaymentModel>>({}, (map, transaction) {
            map[transaction.docId] = transaction;
            return map;
          })
          .values
          .toList();

      transactionsMOP = transactionsMOP
          .fold<Map<String, dynamic>>({}, (map, transaction) {
            String tpmt1Id = transaction['tpmt1Id'];

            if (map.containsKey(tpmt1Id)) {
              map[tpmt1Id]['amount'] += transaction['amount'];
              map[tpmt1Id]['docids'].add(transaction['docid']);
              map[tpmt1Id]['createdat'] = transaction['createdat'];
              map[tpmt1Id]['description'] = transaction['description'];
              map[tpmt1Id]['topmtId'] = transaction['topmtId'];
            } else {
              map[tpmt1Id] = {
                'tpmt1Id': tpmt1Id,
                'amount': transaction['amount'],
                'docids': [transaction['docid']],
                'createdat': transaction['createdat'],
                'description': transaction['description'],
                'paytypecode': transaction['paytypecode'],
                'topmtId': transaction['topmtId'],
              };
            }
            return map;
          })
          .values
          .toList()
        ..sort((a, b) => a['paytypecode'].compareTo(b['paytypecode']));

      tableData = transactionsMOP
          .asMap()
          .map((index, transaction) {
            return MapEntry(index, [
              (index + 1).toString(),
              transaction['description'] ?? '',
              Helpers.parseMoney(transaction['amount']),
            ]);
          })
          .values
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activeShift == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String formattedOpenDate = Helpers.formatDateNoSeconds(activeShift!.openDate);
    String formattedOpenValue = NumberFormat.decimalPattern().format(activeShift!.openValue.toInt());

    final cashier = prefs.getString('username');

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "Shift",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
              onPressed: isPrinting
                  ? null
                  : () async {
                      try {
                        setState(() {
                          isPrinting = true;
                        });
                        await GetIt.instance<PrintOpenShiftUsecase>().call(params: activeShift, printType: 2);

                        setState(() {
                          isPrinting = false;
                        });
                      } catch (e) {
                        setState(() {
                          isPrinting = false;
                        });
                        if (context.mounted) {
                          SnackBarHelper.presentErrorSnackBar(context, e.toString());
                        }
                      }
                    },
              child: Center(
                child: isPrinting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(
                            // backgroundColor: Colors.white,
                            ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.print_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Reprint\nOpen Shift",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                // TextSpan(
                                //   text: "  (F12)",
                                //   style: TextStyle(fontWeight: FontWeight.w300),
                                // ),
                              ],
                              style: TextStyle(height: 1, fontSize: 10),
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
              ),
            )
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Cashier",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                cashier!,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Opened at",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedOpenDate,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Close Shift Approver",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                closeShiftApproverEmployee?.empName ?? closeShiftApproverUser?.username ?? "N/A",
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "Sales",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Opening Balance",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                formattedOpenValue,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Total Cash Sales",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalCashAmount,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Expected Cash",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ProjectColors.mediumBlack,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                expectedCash,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ProjectColors.mediumBlack,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Total Non Cash Sales",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalNonCash,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Total Sales",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                totalSales,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Number of Invoices (All)",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                transactions.length.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                "Number of Invoices (Return)",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                transactionsReturn.length.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "MOP Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(transactionsTopmt.length, (index) {
                    List<List<dynamic>> tableData = [];

                    final filteredTransactions = transactionsMOP.where((transaction) {
                      return transaction['topmtId'] == transactionsTopmt[index].docId;
                    }).toList();

                    if (filteredTransactions.isNotEmpty) {
                      double totalAmount = filteredTransactions.fold(0, (sum, transaction) {
                        return sum + (transaction['amount'] ?? 0);
                      });

                      tableData = filteredTransactions
                          .asMap()
                          .map((i, transaction) {
                            return MapEntry(i, [
                              (i + 1).toString(),
                              transaction['description'] ?? '',
                              Helpers.parseMoney(transaction['amount']),
                            ]);
                          })
                          .values
                          .toList();

                      tableData.add([
                        '',
                        'Total',
                        Helpers.parseMoney(totalAmount),
                      ]);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactionsTopmt[index].description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 222, 220, 220),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Table Header
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: ProjectColors.primary,
                                        ),
                                        child: Row(
                                          children: tableHeader.map((header) {
                                            return Container(
                                              width: 275,
                                              height: 30,
                                              alignment: Alignment.center,
                                              child: Text(
                                                header,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      // Table Data
                                      Column(
                                        children: tableData.map((row) {
                                          bool isLastRow = row == tableData.last;
                                          return Row(
                                            children: row.map<Widget>((cell) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: const Border.symmetric(
                                                    horizontal: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(255, 222, 220, 220),
                                                    ),
                                                  ),
                                                  color: isLastRow
                                                      ? Color.fromARGB(255, 220, 220, 220)
                                                      : Colors.transparent,
                                                ),
                                                width: 275,
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  cell.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: isLastRow ? FontWeight.bold : FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "Actual Cash",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          color: Colors.grey,
        ),
        CalculateCash(
          setTotal: updateTotalCash,
          onControllerProvided: widget.onControllerProvided,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 300,
              child: Text(
                "Total Actual Cash",
                style: TextStyle(
                  fontSize: 18,
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
                calculatedTotalCash,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Difference",
                  style: TextStyle(
                    height: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Helpers.revertMoneyToDecimalFormat(difference) < 0
                        ? Colors.red
                        : Helpers.revertMoneyToDecimalFormat(difference) > 0
                            ? Colors.orange
                            : Colors.green,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Helpers.revertMoneyToDecimalFormat(difference) < 0
                      ? Icons.warning_amber_rounded
                      : Helpers.revertMoneyToDecimalFormat(difference) > 0
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outlined,
                  color: Helpers.revertMoneyToDecimalFormat(difference) < 0
                      ? Colors.red
                      : Helpers.revertMoneyToDecimalFormat(difference) > 0
                          ? Colors.orange
                          : Colors.green,
                ),
              ],
            ),
            const Expanded(
              child: Text(""),
            ),
            Text(
              difference,
              style: TextStyle(
                height: 1,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Helpers.revertMoneyToDecimalFormat(difference) < 0
                    ? Colors.red
                    : Helpers.revertMoneyToDecimalFormat(difference) > 0
                        ? Colors.orange
                        : Colors.green,
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        const Divider(
          height: 50,
          color: Colors.grey,
        ),
        CustomButton(
          child: const Text("End Shift"),
          onTap: () async {
            try {
              if (activeShift == null) throw "Current shift not found";
              final userId = await GetIt.instance<AppDatabase>().userDao.readByUsername(widget.username!, null);
              if (userId == null) throw "Approver not found in local DB";
              final String? currentUserId = prefs.getString("tousrId");
              if (currentUserId == null) throw "Unauthenticated";
              final CashierBalanceTransactionModel shift = CashierBalanceTransactionModel(
                docId: activeShift!.docId,
                createDate: activeShift!.createDate,
                updateDate: activeShift!.updateDate,
                tocsrId: activeShift!.tocsrId,
                tousrId: activeShift!.tousrId,
                docNum: activeShift!.docNum,
                openDate: activeShift!.openDate,
                openTime: activeShift!.openTime,
                calcDate: DateTime.now(),
                calcTime: DateTime.now(),
                closeDate: DateTime.now(),
                closeTime: DateTime.now(),
                timezone: activeShift!.timezone,
                openValue: activeShift!.openValue,
                calcValue: Helpers.revertMoneyToDecimalFormat(calculatedTotalCash),
                cashValue: activeShift!.cashValue,
                closeValue: Helpers.revertMoneyToDecimalFormat(totalSales),
                openedbyId: activeShift!.openedbyId,
                closedbyId: currentUserId,
                approvalStatus: 1,
                refpos: activeShift!.docId,
                syncToBos: activeShift!.syncToBos,
                closedApproveById: userId.docId,
              );

              List<MoneyDenominationModel> createDenominationList(Map<String, dynamic> denomination) {
                final list = <MoneyDenominationModel>[];
                denomination.forEach((key, value) {
                  if (value.isNotEmpty) {
                    final nominal = int.parse(key.replaceAll('k', '000'));
                    final count = int.parse(value);
                    list.add(MoneyDenominationModel(
                      docId: const Uuid().v4(),
                      createDate: DateTime.now(),
                      updateDate: DateTime.now(),
                      nominal: nominal,
                      count: count,
                      tcsr1Id: activeShift!.docId,
                    ));
                  }
                });
                return list;
              }

              final denominationList = createDenominationList(denomination!);

              final bool? isProceed = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    final double numDifference = Helpers.revertMoneyToDecimalFormat(difference);
                    final String absDifference = Helpers.parseMoney(numDifference.abs());
                    return ConfirmationDialog(
                        primaryMsg: "Are you sure to close current shift?",
                        secondaryMsg: numDifference != 0
                            ? "There is a $absDifference ${numDifference > 0 ? "surplus" : "deficit"} between expected cash and actual cash."
                            : "Great! Actual cash has matched the expected cash.");
                  });

              if (isProceed != true) return;

              await GetIt.instance<AppDatabase>().moneyDenominationDao.bulkCreate(data: denominationList);
              await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.update(docId: shiftId, data: shift);
              try {
                GetIt.instance<CashierBalanceTransactionApi>().sendTransactions(shift);
              } catch (e) {
                log(e.toString());
              }

              final CashierBalanceTransactionEntity? cashierBalanceTransactionEntity =
                  await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocId(shift.docId, null);
              if (cashierBalanceTransactionEntity == null) {
                throw "Close shift failed, current shift not found";
              }
              final PrintCloseShiftUsecaseParams printCloseShiftUsecaseParams = PrintCloseShiftUsecaseParams(
                  cashierBalanceTransactionEntity: cashierBalanceTransactionEntity,
                  totalCashSales: Helpers.revertMoneyToDecimalFormat(totalCashAmount),
                  expectedCash: Helpers.revertMoneyToDecimalFormat(expectedCash),
                  totalNonCashSales: Helpers.revertMoneyToDecimalFormat(totalNonCash),
                  totalSales: Helpers.revertMoneyToDecimalFormat(totalSales),
                  cashReceived: Helpers.revertMoneyToDecimalFormat(calculatedTotalCash),
                  difference: Helpers.revertMoneyToDecimalFormat(calculatedTotalCash) -
                      Helpers.revertMoneyToDecimalFormat(expectedCash),
                  approverName: closeShiftApproverEmployee?.empName ?? closeShiftApproverUser?.username ?? "");
              try {
                GetIt.instance<PrintCloseShiftUsecase>().call(params: printCloseShiftUsecaseParams, printType: 1);
              } catch (e) {
                log("$e");
              }

              if (checkLastShift) {
                await prefs.setBool('isOpen', false);
                await prefs.setString('tcsr1Id', "");
                await GetIt.instance<LogoutUseCase>().call();
                await context.read<ReceiptCubit>().resetReceipt();
                if (context.mounted) {
                  await BackupDatabaseUseCase().call(params: BackupDatabaseParams(context: context));
                }
                await showDialog(
                    context: NavigationHelper.context!,
                    barrierDismissible: false,
                    builder: (context) => PopScope(
                          canPop: false,
                          child: CloseShiftSuccessAlertDialog(
                            closedShift: cashierBalanceTransactionEntity,
                            printCloseShiftUsecaseParams: printCloseShiftUsecaseParams,
                          ),
                        ));
                if (context.mounted) {
                  log('Navigating to welcome route');
                  context.goNamed(RouteConstants.welcome);
                }
              } else {
                if (!context.mounted) return;
                Future.delayed(Durations.short1, () => checkLastShiftId());
                log('Navigating to shifts route');
                context.goNamed(RouteConstants.home);
                await showDialog(
                    context: NavigationHelper.context!,
                    builder: (context) => CloseShiftSuccessAlertDialog(
                          closedShift: cashierBalanceTransactionEntity,
                          printCloseShiftUsecaseParams: printCloseShiftUsecaseParams,
                        ));
              }
            } catch (e) {
              if (!context.mounted) return;
              SnackBarHelper.presentFailSnackBar(context, e.toString());
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
