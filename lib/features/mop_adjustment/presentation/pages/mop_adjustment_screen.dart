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
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';

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
  String? mop1;
  String? mop2;
  String? docNum;
  String? date;
  String? cashier;
  String? shift;
  bool isLoading = true;
  InvoiceHeaderModel? invFetched;
  TextEditingController mop1Controller = TextEditingController();
  TextEditingController mop2Controller = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMops();
    generateTmpad();
  }

  Future<void> getMops() async {
    final mops =
        await GetIt.instance<AppDatabase>().meansOfPaymentDao.readAll();
    for (final mop in mops) {
      final desc = mop.description;
      mop1Options.add(desc);
      mop2Options.add(desc);
    }

    setState(() {});
  }

  Future<void> generateTmpad() async {
    final DateTime now = DateTime.now();
    final List<MOPAdjustmentHeaderModel> tmpadEntities =
        await GetIt.instance<AppDatabase>().mopAdjustmentHeaderDao.readAll();
    final List<POSParameterEntity?> posParameterEntity =
        await GetIt.instance<AppDatabase>().posParameterDao.readAll();
    final StoreMasterEntity? storeMasterEntity =
        await GetIt.instance<AppDatabase>()
            .storeMasterDao
            .readByDocId(posParameterEntity[0]!.tostrId!, null);
    if (storeMasterEntity == null) throw "Store master not found";
    final CashierBalanceTransactionModel? activeShift =
        await GetIt.instance<AppDatabase>()
            .cashierBalanceTransactionDao
            .readLastValue();
    if (activeShift == null) throw "Active Shift not found";
    final UserModel? userEntity = await GetIt.instance<AppDatabase>()
        .userDao
        .readByDocId(activeShift.tousrId!, null);
    if (userEntity == null) throw "User not found";
    final generatedDocnum =
        "${storeMasterEntity.storeCode}-${DateFormat('yyMMddHHmmss').format(now)}-${ReceiptHelper.convertIntegerToThreeDigitString(tmpadEntities.length + 1)}-MOPA";
    setState(() {
      docNum = generatedDocnum;
      shift = activeShift.docNum;
      cashier = userEntity.username;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    mop1Controller.dispose();
    mop2Controller.dispose();
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
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Text(
                          docNum!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ProjectColors.mediumBlack,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
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
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 30,
                                  child: Text(
                                    Helpers.formatDateNoSeconds(DateTime.now()),
                                    style: const TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    "Cashier",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
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
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 30,
                                  child: Text(
                                    cashier!,
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    "Shift",
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
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
                                      color: ProjectColors.mediumBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: Text(
                                    shift!,
                                    style: TextStyle(
                                      color: ProjectColors.mediumBlack,
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
                      const Divider(
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
                                  "MOP 1",
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
                                    child: DropdownButton<String>(
                                      value: selectedMOP1,
                                      isExpanded: true,
                                      icon: null,
                                      elevation: 18,
                                      style: const TextStyle(
                                        color: ProjectColors.mediumBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                    child: TextField(
                                      controller: mop1Controller,
                                      inputFormatters: [MoneyInputFormatter()],
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
                                      onChanged: (value) {
                                        mop1 = mop1Controller.text;
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
                                  "MOP 2",
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
                                    child: DropdownButton<String>(
                                      value: selectedMOP2,
                                      isExpanded: true,
                                      icon: null,
                                      elevation: 18,
                                      style: const TextStyle(
                                        color: ProjectColors.mediumBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                    child: TextField(
                                      controller: mop2Controller,
                                      inputFormatters: [MoneyInputFormatter()],
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
                                      onChanged: (value) {
                                        mop1 = mop2Controller.text;
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
                        child: TextField(
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
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(
                                            color: ProjectColors.primary))),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.transparent),
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        ProjectColors.primary.withOpacity(.2))),
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
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => ProjectColors.primary),
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.white.withOpacity(.2))),
                            onPressed: () {
                              // do sumthing
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
    );
  }
}
