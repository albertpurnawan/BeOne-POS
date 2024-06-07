import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_detail.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_adjustment_service.dart';
import 'package:uuid/uuid.dart';

class MOPAdjustmentScreen extends StatefulWidget {
  const MOPAdjustmentScreen({super.key});

  @override
  State<MOPAdjustmentScreen> createState() => _MOPAdjustmentScreenState();
}

class _MOPAdjustmentScreenState extends State<MOPAdjustmentScreen> {
  List<String> mop1Options = [];
  List<String> mop2Options = [];
  String? selectedMOP1;
  String? selectedMOP2;
  double? mop1;
  double? mop2;
  String? mopDocNum;
  String? mopDate;
  String? mopCashier;
  String? mopShift;
  String? mopStore;
  CashierBalanceTransactionModel? shiftSearched;
  bool isLoading = true;
  DateTime now = DateTime.now();
  InvoiceHeaderModel? invFetched;
  TextEditingController mopController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    generateTmpadDocNum();
  }

  Future<void> getMops(CashierBalanceTransactionModel? shift) async {
    final start = shift!.openDate;
    DateTime end;

    if (shift.closedbyId!.isEmpty) {
      end = DateTime.now();
    } else {
      end = shift.closeDate;
    }
    log('$end');

    final mops = await GetIt.instance<AppDatabase>()
        .payMeansDao
        .readByTpmt3BetweenDate(start, end);
    if (mops != null) {
      for (final mop in mops) {
        final desc = mop['description'];
        mop1Options.add(desc);
        mop2Options.add(desc);
      }
    } else {
      mop1Options = [];
      mop2Options = [];
    }
    log("$mop1Options");
    setState(() {});
  }

  Future<CashierBalanceTransactionModel?> getCashierBalanceTransaction(
      String docNum) async {
    final shift = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readByDocNum(docNum, null);
    if (shift.isEmpty) return null;
    final UserModel? userEntity = await GetIt.instance<AppDatabase>()
        .userDao
        .readByDocId(shift[0]!.tousrId!, null);
    if (userEntity == null) return null;
    setState(() {
      shiftSearched = shift[0];
      mopCashier = userEntity.username;
      mopShift = shift[0]!.docNum;
    });
    return shift[0];
  }

  Future<void> generateTmpadDocNum() async {
    final List<MOPAdjustmentHeaderModel> tmpadEntities =
        await GetIt.instance<AppDatabase>().mopAdjustmentHeaderDao.readAll();
    final List<POSParameterEntity?> posParameterEntity =
        await GetIt.instance<AppDatabase>().posParameterDao.readAll();
    final StoreMasterEntity? storeMasterEntity =
        await GetIt.instance<AppDatabase>()
            .storeMasterDao
            .readByDocId(posParameterEntity[0]!.tostrId!, null);
    if (storeMasterEntity == null) throw "Store master not found";
    final generatedDocnum =
        "${storeMasterEntity.storeCode}-${DateFormat('yyMMddHHmmss').format(now)}-${ReceiptHelper.convertIntegerToThreeDigitString(tmpadEntities.length + 1)}-MOPA";
    setState(() {
      mopDocNum = generatedDocnum;
      mopStore = storeMasterEntity.docId;
      isLoading = false;
    });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Wrong shift document number.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    mopController.dispose();
    shiftController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: const Text('MOP Adjustment'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mopDocNum!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 120,
                              child: const VerticalDivider(
                                color: ProjectColors.primary,
                                thickness: 5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: Text(
                                              "Shift",
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 30,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            height: 30,
                                            child: TextFormField(
                                              controller: shiftController,
                                              onChanged: (value) {
                                                setState(() {
                                                  mop1Options = [];
                                                  mop2Options = [];
                                                });
                                              },
                                              onFieldSubmitted: (value) async {
                                                final tcsr1Fetched =
                                                    await getCashierBalanceTransaction(
                                                        value);
                                                if (tcsr1Fetched == null) {
                                                  showAlertDialog(context);
                                                } else {
                                                  await getMops(tcsr1Fetched);
                                                }
                                              },
                                              style: const TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: Text(
                                              "Date",
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                            height: 30,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            height: 30,
                                            child: Text(
                                              Helpers.formatDateNoSeconds(now),
                                              style: const TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: Text(
                                              "Cashier",
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 30,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            height: 30,
                                            child: Text(
                                              mopCashier == null
                                                  ? '-'
                                                  : mopCashier!,
                                              style: TextStyle(
                                                color:
                                                    ProjectColors.mediumBlack,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
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
                        const Divider(
                          height: 20,
                          thickness: 5,
                          color: ProjectColors.primary,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "FROM",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedMOP1,
                                        isExpanded: true,
                                        icon: null,
                                        elevation: 18,
                                        style: const TextStyle(
                                          color: ProjectColors.mediumBlack,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select Means of Payment From';
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedMOP1 = newValue!;
                                          });
                                        },
                                        items: mop1Options
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 420,
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: mopController,
                                        inputFormatters: [
                                          MoneyInputFormatter()
                                        ],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8),
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                            color: ProjectColors.mediumBlack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: ProjectColors.mediumBlack,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter amount for Means of Payment From';
                                          } else if (value == '0') {
                                            return 'Amount should not be 0';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          mop1 = Helpers
                                              .revertMoneyToDecimalFormat(
                                                  mopController.text);
                                          mop2 = mop1;
                                          // _formKey.currentState!.validate();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "TO",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedMOP2,
                                        isExpanded: true,
                                        icon: null,
                                        elevation: 18,
                                        style: const TextStyle(
                                          color: ProjectColors.mediumBlack,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select Means of Payment To';
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedMOP2 = newValue!;
                                          });
                                        },
                                        items: mop2Options
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 420,
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: mopController,
                                        inputFormatters: [
                                          MoneyInputFormatter()
                                        ],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8),
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                            color: ProjectColors.mediumBlack,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: ProjectColors.mediumBlack,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter amount for Means of Payment To';
                                          } else if (value == '0') {
                                            return 'Amount should not be 0';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          mop2 = Helpers
                                              .revertMoneyToDecimalFormat(
                                                  mopController.text);
                                          mop1 = mop2;
                                          // _formKey.currentState!.validate();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 1012,
                          height: 100,
                          child: TextFormField(
                            controller: remarksController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: ProjectColors.mediumBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: const BorderSide(
                                              color: ProjectColors.primary))),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.transparent),
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => ProjectColors.primary
                                          .withOpacity(.2))),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Center(
                                  child: Text(
                                "Cancel",
                                style: TextStyle(color: ProjectColors.primary),
                              )),
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: ProjectColors.primary),
                                  )),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => ProjectColors.primary),
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) =>
                                          Colors.white.withOpacity(.2))),
                              onPressed: () async {
                                setState(() {
                                  _autoValidate = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  final tmpadDocId = const Uuid().v4();
                                  final MOPAdjustmentHeaderModel tmpad =
                                      MOPAdjustmentHeaderModel(
                                    docId: tmpadDocId,
                                    createDate: DateTime.now(),
                                    updateDate: DateTime.now(),
                                    docNum: mopDocNum!,
                                    docDate: now,
                                    docTime: now,
                                    timezone: Helpers.getTimezone(now),
                                    posted: 0,
                                    postDate: now,
                                    postTime: now,
                                    remarks:
                                        "$mopShift - ${remarksController.text}",
                                    tostrId: mopStore,
                                    sync: 0,
                                  );

                                  final tpmt1From =
                                      await GetIt.instance<AppDatabase>()
                                          .meansOfPaymentDao
                                          .readByDescription(
                                              selectedMOP1!, null);
                                  if (tpmt1From == null)
                                    throw "MOP From not found";

                                  final tpmt1To =
                                      await GetIt.instance<AppDatabase>()
                                          .meansOfPaymentDao
                                          .readByDescription(
                                              selectedMOP2!, null);
                                  if (tpmt1To == null) throw "MOP To not found";

                                  final tpmt3From =
                                      await GetIt.instance<AppDatabase>()
                                          .mopByStoreDao
                                          .readByTpmt1Id(tpmt1From.docId, null);
                                  if (tpmt3From == null) {
                                    throw "MOPByStore From not found";
                                  }

                                  final tpmt3To =
                                      await GetIt.instance<AppDatabase>()
                                          .mopByStoreDao
                                          .readByTpmt1Id(tpmt1To.docId, null);
                                  if (tpmt3To == null) {
                                    throw "MOPByStore To not found";
                                  }

                                  final MOPAdjustmentDetailModel mpad1From =
                                      MOPAdjustmentDetailModel(
                                          docId: const Uuid().v4(),
                                          createDate: DateTime.now(),
                                          updateDate: DateTime.now(),
                                          tmpadId: tmpadDocId,
                                          tpmt1Id: tpmt1From.docId,
                                          amount: -mop1!,
                                          tpmt3Id: tpmt3From.docId);

                                  final MOPAdjustmentDetailModel mpad1To =
                                      MOPAdjustmentDetailModel(
                                          docId: const Uuid().v4(),
                                          createDate: DateTime.now(),
                                          updateDate: DateTime.now(),
                                          tmpadId: tmpadDocId,
                                          tpmt1Id: tpmt1To.docId,
                                          amount: mop2!,
                                          tpmt3Id: tpmt3To.docId);

                                  await GetIt.instance<AppDatabase>()
                                      .mopAdjustmentHeaderDao
                                      .create(data: tmpad);
                                  await GetIt.instance<AppDatabase>()
                                      .mopAdjustmentDetailDao
                                      .bulkCreate(data: [mpad1From, mpad1To]);
                                  log("MOP Adjustment Created");

                                  await GetIt.instance<MOPAdjustmentService>()
                                      .sendMOPAdjustment(
                                          tmpad, [mpad1From, mpad1To]);

                                  Navigator.pop(context);
                                }
                              },
                              child: const Center(
                                  child: Text(
                                "Adjust",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 234, 234, 234)),
                              )),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
