import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_detail.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/mop_adjustment_service.dart';
import 'package:uuid/uuid.dart';

class MOPAdjustmentScreen extends StatefulWidget {
  const MOPAdjustmentScreen({super.key});

  @override
  State<MOPAdjustmentScreen> createState() => _MOPAdjustmentScreenState();
}

class _MOPAdjustmentScreenState extends State<MOPAdjustmentScreen> {
  final TextEditingController _shiftDocnumController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final _focusNode = FocusNode();
  List<CashierBalanceTransactionModel>? shiftsFound;
  List<dynamic>? mopsList;
  CashierBalanceTransactionModel? selectedShift;
  String? username;
  String? idKassa;
  List<String> mop1Options = [];
  List<String> mop2Options = [];
  String? selectedMOP1;
  String? selectedMOP2;
  double? amountChanged;
  String? mopDocNum;
  String? mopDate;
  String? mopCashier;
  String? mopShift;
  String? mopStore;
  double? maxAmount;
  String errMsg = "Invalid amount";
  bool isErr = false;

  bool isLoading = true;
  bool showMOPField = false;
  DateTime now = DateTime.now();
  InvoiceHeaderModel? invFetched;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    generateTmpadDocNum();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _shiftDocnumController.dispose();
    _amountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<List<CashierBalanceTransactionModel>?> _searchShift(String docNum) async {
    final shifts = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readByDocNum(docNum, null);
    return shifts;
  }

  Future<UserModel> _getUser(String tousrId) async {
    final user = await GetIt.instance<AppDatabase>().userDao.readByDocId(tousrId, null);
    return user!;
  }

  Future<CashRegisterModel> _getCashier(String tocsrId) async {
    final cashier = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(tocsrId, null);
    return cashier!;
  }

  Future<Map<CashierBalanceTransactionModel, Map<String, dynamic>>> _fetchSearchResultsWithDetails() async {
    final searchResults = shiftsFound!;

    final userFutures = searchResults.map((shift) => _getUser(shift.tousrId!));
    final cashierFutures = searchResults.map((shift) => _getCashier(shift.tocsrId!));

    final users = await Future.wait(userFutures);
    final cashiers = await Future.wait(cashierFutures);

    final resultMap = Map<CashierBalanceTransactionModel, Map<String, dynamic>>.fromIterables(
      searchResults,
      List.generate(
          searchResults.length,
          (index) => {
                'user': users[index],
                'cashier': cashiers[index],
              }),
    );

    return resultMap;
  }

  void _handleShiftSelected(CashierBalanceTransactionModel? shift) async {
    await getMops(shift);
    if (shift != null) {
      final user = await _getUser(shift.tousrId!);
      final cashier = await _getCashier(shift.tocsrId!);
      setState(() {
        username = user.username;
        idKassa = cashier.idKassa;
        _shiftDocnumController.text = "";
        shiftsFound = null;
        selectedShift = shift;
        showMOPField = true;
      });
    }
  }

  Future<void> getMops(CashierBalanceTransactionModel? shift) async {
    final start = shift!.openDate.subtract(Duration(hours: DateTime.now().timeZoneOffset.inHours));
    DateTime end;

    if (shift.closedbyId!.isEmpty) {
      end = DateTime.now();
    } else {
      end = shift.closeDate.subtract(Duration(hours: DateTime.now().timeZoneOffset.inHours));
    }

    final allMops = await GetIt.instance<AppDatabase>().meansOfPaymentDao.readAll();
    for (final mop in allMops) {
      mop2Options.add(mop.description);
    }

    final mops = await GetIt.instance<AppDatabase>().payMeansDao.readByTpmt3BetweenDate(start, end);

    log("mops - $mops");
    if (mops != null) {
      setState(() {
        mopsList = mops;
      });
      for (final mop in mops) {
        final desc = mop['description'];
        mop1Options.add(desc);
      }
    } else {
      mop1Options = [];
    }

    mop1Options = mop1Options.toSet().toList();
    mop2Options = mop2Options.toSet().toList();
  }

  Future<void> generateTmpadDocNum() async {
    final List<MOPAdjustmentHeaderModel> tmpadEntities =
        await GetIt.instance<AppDatabase>().mopAdjustmentHeaderDao.readAll();
    final List<POSParameterEntity?> posParameterEntity = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
    final StoreMasterEntity? storeMasterEntity =
        await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(posParameterEntity[0]!.tostrId!, null);
    if (storeMasterEntity == null) throw "Store master not found";
    final generatedDocnum =
        "${storeMasterEntity.storeCode}-${DateFormat('yyMMddHHmmss').format(now)}-${ReceiptHelper.convertIntegerToThreeDigitString(tmpadEntities.length + 1)}-MOPA";
    setState(() {
      mopDocNum = generatedDocnum;
      mopStore = storeMasterEntity.docId;
      isLoading = false;
    });
  }

  double? getMaxAmount(String selectedMOP) {
    if (mopsList == null) return null;
    final selectedMop = mopsList!.firstWhere(
      (mop) => mop['description'] == selectedMOP,
      orElse: () => {} as Map<String, Object?>,
    );
    return selectedMop.isEmpty ? null : (selectedMop['amount'] as double?);
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

  // Future<void> getAmountByEDCAndBetweenDate(CashierBalanceTransactionModel shift) async {
  //   final result =
  //       await GetIt.instance<AppDatabase>().payMeansDao.readByTpmt3BetweenDate(shift.openDate, shift.closeDate);
  //   log("result - $result");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 234, 234, 234),
        appBar: AppBar(
          backgroundColor: ProjectColors.primary,
          foregroundColor: Colors.white,
          title: const Text('MOP Adjustment'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.98,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _inputShiftDocnum(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    if (shiftsFound != null && shiftsFound!.isNotEmpty)
                      Expanded(
                        child: _searchResult(onShiftSelected: _handleShiftSelected),
                      ),
                    if (showMOPField)
                      SizedBox(
                        child: _mopFields(),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (showMOPField)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: _actionButtons(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _inputShiftDocnum() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Search Shift",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _focusNode,
                      textAlign: TextAlign.center,
                      controller: _shiftDocnumController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "Type Shift Document Number",
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.mediumBlack, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) async {
                        final shiftsSearched = await _searchShift(value);
                        setState(() {
                          shiftsFound = shiftsSearched;
                          showMOPField = false;
                          selectedMOP1 = "";
                          selectedMOP2 = "";
                          mop1Options = [];
                          mop2Options = [];
                        });
                      },
                      onEditingComplete: () async {
                        final shiftsSearched = await _searchShift(_shiftDocnumController.text);
                        setState(() {
                          shiftsFound = shiftsSearched;
                          showMOPField = false;
                          selectedMOP1 = "";
                          selectedMOP2 = "";
                          mop1Options = [];
                          mop2Options = [];
                          maxAmount = 0;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 11, horizontal: 20)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          side: const BorderSide(color: ProjectColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        )),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => ProjectColors.primary,
                        ),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2)),
                      ),
                      onPressed: () async {
                        final shiftsSearched = await _searchShift(_shiftDocnumController.text);
                        setState(() {
                          shiftsFound = shiftsSearched;
                          showMOPField = false;
                          selectedMOP1 = "";
                          selectedMOP2 = "";
                          mop1Options = [];
                          mop2Options = [];
                        });
                      },
                      child: const Icon(
                        Icons.search_outlined,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchResult({required Function(CashierBalanceTransactionModel?) onShiftSelected}) {
    return FutureBuilder<Map<CashierBalanceTransactionModel, Map<String, dynamic>>>(
      future: _fetchSearchResultsWithDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final searchResultsWithDetails = snapshot.data!;
          return ListView.builder(
            itemCount: searchResultsWithDetails.length,
            itemBuilder: (context, index) {
              final shift = searchResultsWithDetails.keys.elementAt(index);
              final user = searchResultsWithDetails[shift]!['user'] as UserModel;
              final cashier = searchResultsWithDetails[shift]!['cashier'] as CashRegisterModel;

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Card(
                  color: ProjectColors.background,
                  shadowColor: ProjectColors.background,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      onShiftSelected(shift);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    textColor: Colors.black,
                    title: Text(
                      shift.docNum,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: SizedBox(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Helpers.dateEEddMMMyyy(shift.openDate),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            user.username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.point_of_sale_outlined,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            cashier.idKassa!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _mopFields() {
    final shiftDocnum = selectedShift!.docNum;
    selectedMOP1 = selectedMOP1 != null && mop1Options.contains(selectedMOP1)
        ? selectedMOP1
        : (mop1Options.isNotEmpty ? mop1Options.first : null);
    selectedMOP2 = selectedMOP2 != null && mop2Options.contains(selectedMOP2)
        ? selectedMOP2
        : (mop2Options.isNotEmpty ? mop2Options.first : null);

    if (selectedMOP1 != null) {
      setState(() {
        maxAmount = getMaxAmount(selectedMOP1!);
        log("maxAmount1231232 - $maxAmount");
      });
    }
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Center(
                          child: Text(
                        shiftDocnum,
                        style: const TextStyle(
                            color: ProjectColors.mediumBlack, fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month_outlined, color: Colors.black, size: 18.0),
                                const SizedBox(width: 10),
                                Text(
                                  Helpers.dateEEddMMMyyy(selectedShift!.openDate),
                                  style: const TextStyle(
                                    color: ProjectColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.account_circle_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  username ?? "",
                                  style: const TextStyle(
                                    color: ProjectColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.point_of_sale_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  idKassa ?? "",
                                  style: const TextStyle(
                                    color: ProjectColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "From",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedMOP1,
                      isExpanded: true,
                      icon: null,
                      elevation: 18,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "",
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.mediumBlack, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                          maxAmount = getMaxAmount(newValue);
                        });
                      },
                      items: mop1Options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "To",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedMOP2,
                      isExpanded: true,
                      icon: null,
                      elevation: 18,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: "",
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.mediumBlack, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: ProjectColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select Means of Payment From';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMOP2 = newValue!;
                        });
                      },
                      items: mop2Options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                )),
              ],
            ),
            if (selectedMOP1 == null)
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "There's no transactions found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ProjectColors.primary),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Amount",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: Builder(
                              builder: (BuildContext context) {
                                return TextFormField(
                                  controller: _amountController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [MoneyInputFormatter()],
                                  style: const TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: "",
                                    hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                    prefix: selectedMOP1 != null ? Text("Max Amount: $maxAmount") : null,
                                    suffix: isErr
                                        ? Text(
                                            errMsg,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w700,
                                                color: ProjectColors.swatch),
                                          )
                                        : null,
                                  ),
                                  onChanged: (value) {
                                    amountChanged = Helpers.revertMoneyToDecimalFormat(_amountController.text);
                                    if (amountChanged! > maxAmount!) {
                                      setState(() {
                                        isErr = true;
                                        errMsg = "Invalid amount";
                                      });
                                    } else if (isErr) {
                                      setState(() {
                                        isErr = false;
                                      });
                                    }
                                  },
                                  onEditingComplete: () {
                                    amountChanged = Helpers.revertMoneyToDecimalFormat(_amountController.text);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Remarks",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: TextFormField(
                              controller: _remarksController,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 18),
                              minLines: 4,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: "",
                                hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
            child: TextButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
              overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: ProjectColors.primary),
              )),
              backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
          onPressed: () async {
            setState(() {
              _autoValidate = true;
            });
            if (_formKey.currentState!.validate()) {
              final tmpadDocId = const Uuid().v4();
              final MOPAdjustmentHeaderModel tmpad = MOPAdjustmentHeaderModel(
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
                remarks: "$mopShift - ${_remarksController.text}",
                tostrId: mopStore,
                sync: 0,
              );

              final tpmt1From =
                  await GetIt.instance<AppDatabase>().meansOfPaymentDao.readByDescription(selectedMOP1!, null);
              if (tpmt1From == null) {
                throw "MOP From not found";
              }

              final tpmt1To =
                  await GetIt.instance<AppDatabase>().meansOfPaymentDao.readByDescription(selectedMOP2!, null);
              if (tpmt1To == null) throw "MOP To not found";

              final tpmt3From = await GetIt.instance<AppDatabase>().mopByStoreDao.readByTpmt1Id(tpmt1From.docId, null);
              if (tpmt3From == null) {
                throw "MOPByStore From not found";
              }

              final tpmt3To = await GetIt.instance<AppDatabase>().mopByStoreDao.readByTpmt1Id(tpmt1To.docId, null);
              if (tpmt3To == null) {
                throw "MOPByStore To not found";
              }
              final MOPAdjustmentDetailModel mpad1From = MOPAdjustmentDetailModel(
                  docId: const Uuid().v4(),
                  createDate: DateTime.now(),
                  updateDate: DateTime.now(),
                  tmpadId: tmpadDocId,
                  tpmt1Id: tpmt1From.docId,
                  amount: -amountChanged!,
                  tpmt3Id: tpmt3From.docId);

              final MOPAdjustmentDetailModel mpad1To = MOPAdjustmentDetailModel(
                  docId: const Uuid().v4(),
                  createDate: DateTime.now(),
                  updateDate: DateTime.now(),
                  tmpadId: tmpadDocId,
                  tpmt1Id: tpmt1To.docId,
                  amount: amountChanged!,
                  tpmt3Id: tpmt3To.docId);

              await GetIt.instance<AppDatabase>().mopAdjustmentHeaderDao.create(data: tmpad);
              await GetIt.instance<AppDatabase>().mopAdjustmentDetailDao.bulkCreate(data: [mpad1From, mpad1To]);

              await GetIt.instance<MOPAdjustmentService>().sendMOPAdjustment(tmpad, [mpad1From, mpad1To]);

              Navigator.pop(context);
            }
          },
          child: const Center(
              child: Text(
            "Adjust",
            style: TextStyle(color: Color.fromARGB(255, 234, 234, 234)),
          )),
        )),
      ],
    );
  }
}
