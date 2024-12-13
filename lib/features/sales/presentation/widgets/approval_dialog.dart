import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/otp_service.dart';
import 'package:pos_fe/features/sales/data/models/approval_invoice.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/discount_and_rounding_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/otp_submission_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ApprovalDialog extends StatefulWidget {
  final ApprovalType? approvalType;
  final double? initialGrandTotal;
  final double? finalGrandTotal;
  final double? discountValue;
  final String? docnum;
  final double? returnQty;
  final double? returnAmount;
  final List<LineDiscountParameter>? lineDiscountParameters;
  const ApprovalDialog(
      {super.key,
      this.approvalType,
      this.initialGrandTotal,
      this.finalGrandTotal,
      this.discountValue,
      this.docnum,
      this.lineDiscountParameters,
      this.returnQty,
      this.returnAmount});

  @override
  State<ApprovalDialog> createState() => _ApprovalDialogState();
}

class _ApprovalDialogState extends State<ApprovalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _isOTPClicked = false;
  bool _isSendingOTP = false;

  bool _showKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();
  TextEditingController _activeController = TextEditingController();
  FocusNode _activeFocusNode = FocusNode();
  late String remarks;
  late String category;
  late String subject;
  late String body;

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    modularApprovalandOTP(widget.approvalType);
    super.initState();
    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus) {
        setState(() {
          _activeController = _usernameController;
          _activeFocusNode = _usernameFocusNode;
        });
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _activeController = _passwordController;
          _activeFocusNode = _passwordFocusNode;
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _keyboardFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
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

  Future<String> checkPassword(String username, String password) async {
    String hashedPassword = md5.convert(utf8.encode(password)).toString();
    String check = "";
    String category = "nonpositivetrx";
    final UserModel? user = await GetIt.instance<AppDatabase>().userDao.readByUsername(username, null);

    if (user != null) {
      if (widget.approvalType == ApprovalType.returnItem) {
        category = "returnauthorization";
      }
      final tastr = await GetIt.instance<AppDatabase>().authStoreDao.readByTousrId(user.docId, category, null);

      if (tastr != null && tastr.tousrdocid == user.docId) {
        if (tastr.statusActive != 1) {
          check = "Unauthorized";
        } else if (tastr.returnauthorization != 1) {
          check = "Unauthorized";
        } else if (user.password == hashedPassword) {
          check = "Success";
        } else {
          check = "Wrong Password";
        }
      } else {
        check = "Unauthorized";
      }
    } else {
      check = "Unauthorized";
    }
    return check;
  }

  Future<void> onSubmit(BuildContext childContext, BuildContext parentContext) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    String passwordCorrect = await checkPassword(_usernameController.text, _passwordController.text);
    if (passwordCorrect == "Success") {
      await updateReceiptApprovals(childContext);
      parentContext.pop(true);
    } else {
      final message = passwordCorrect == "Wrong Password" ? "Invalid username or password" : "Unauthorized";
      SnackBarHelper.presentErrorSnackBar(childContext, message);
      if (Platform.isWindows) _usernameFocusNode.requestFocus();
    }
  }

  Future<void> updateReceiptApprovals(BuildContext context) async {
    final user = await GetIt.instance<AppDatabase>().userDao.readByUsername(_usernameController.text, null);
    final receiptCubit = context.read<ReceiptCubit>();

    final approval = ApprovalInvoiceModel(
      docId: const Uuid().v4(),
      createDate: DateTime.now(),
      updateDate: null,
      toinvId: receiptCubit.state.docNum,
      tousrId: user!.docId,
      remarks: remarks,
      category: category,
    );
    context.read<ReceiptCubit>().updateApprovals(approval);
  }

  Future<String> createOTP() async {
    try {
      final response = await GetIt.instance<OTPServiceAPi>().createSendOTP(context, null, subject, body);
      return response['Requester'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleOTP(BuildContext childContext) async {
    try {
      setState(() {
        _isOTPClicked = true;
        _isSendingOTP = true;
      });

      await createOTP().then((value) async {
        setState(() {
          _isOTPClicked = false;
          _isSendingOTP = false;
        });

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => OTPSubmissionDialog(
            requester: value,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isOTPClicked = false;
        _isSendingOTP = false;
      });
      SnackBarHelper.presentFailSnackBar(childContext, e.toString());
    }
  }

  Future<void> modularApprovalandOTP(type) async {
    final POSParameterEntity? topos = await GetIt.instance<GetPosParameterUseCase>().call();
    if (topos == null) throw "Failed to retrieve POS Parameter";

    final StoreMasterEntity? store = await GetIt.instance<GetStoreMasterUseCase>().call(params: topos.tostrId);
    if (store == null) throw "Failed to retrieve Store Master";

    final cashierMachine = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(topos.tocsrId!, null);
    if (cashierMachine == null) throw "Failed to retrieve Cash Register";

    final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
    final userId = prefs.getString('tousrId') ?? "";
    final employeeId = prefs.getString('tohemId') ?? "";
    final user = await GetIt.instance<AppDatabase>().userDao.readByDocId(userId, null);
    if (user == null) throw "User Not Found";

    final employee = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(employeeId, null);

    if (type == ApprovalType.discount) {
      final double lineDiscountsTotal = widget.lineDiscountParameters!
          .fold(0, (previousValue, element) => previousValue + element.lineDiscountAmount);
      final int appliedLineDiscountsCount =
          widget.lineDiscountParameters!.where((element) => element.lineDiscountAmount != 0).length;
      final String lineDiscountsString = widget.lineDiscountParameters!
          .where((element) => element.lineDiscountAmount != 0)
          .map((e) =>
              "${e.receiptItemEntity.itemEntity.barcode} - ${e.receiptItemEntity.itemEntity.itemName}\n      Qty. ${Helpers.cleanDecimal(e.receiptItemEntity.quantity, 5)}\n      Total Amount: ${Helpers.parseMoney(e.receiptItemEntity.totalAmount)}\n      Discount: ${Helpers.parseMoney(e.lineDiscountAmount)}\n      Final Total Amount: ${Helpers.parseMoney(e.receiptItemEntity.totalAmount - e.lineDiscountAmount)}")
          .join(",\n\n      ");

      setState(() {
        remarks =
            "Header Discount: ${Helpers.parseMoney(widget.discountValue as num)}; Line Discounts: ${Helpers.parseMoney(lineDiscountsTotal)} ($appliedLineDiscountsCount item(s))";
        category = "001 - Discount & Rounding";
        subject = "OTP RUBY POS Discount or Rounding - [${store.storeCode}]";

        body = '''
          Approval For: Discount or Rounding,
          Store Name: ${store.storeName},
          Cash Register Id: ${(cashierMachine.description == "") ? cashierMachine.idKassa! : cashierMachine.description},
          Cashier Name: ${employee?.empName ?? user.username},
          Header Discount: ${Helpers.parseMoney(widget.discountValue as num)},
          Line Discounts:
            $lineDiscountsString
          ,
          Total Line Discounts: ${Helpers.parseMoney(lineDiscountsTotal)},
          Final Grand Total: ${Helpers.parseMoney(widget.finalGrandTotal as num)},
        ''';
      });
    } else if (type == ApprovalType.returnItem) {
      setState(() {
        remarks = "Return Qty.: ${widget.returnQty.toString()} Return Amount: ${widget.returnAmount.toString()}";
        category = "003 - Return Transaction";
        subject = "OTP RUBY POS Return Transaction - [${store.storeCode}]";

        body = '''
          Approval For: Return Transaction,
          Store Name: ${store.storeName},
          Cash Register Id: ${(cashierMachine.description == "") ? cashierMachine.idKassa! : cashierMachine.description},
          Cashier Name: ${employee?.empName ?? user.username},
          Return Qty: ${widget.returnQty.toString()},
          Return Amount:
            ${widget.returnAmount.toString()}
        ''';
      });
    } else {
      setState(() {
        remarks = "Approval Transaction 0";
        category = "002 - Transaction 0";
        body = '''
          Approval For: Zero or Negative Transaction,
          Store Name: ${store.storeName},
          Cash Register Id: ${(cashierMachine.description == "") ? cashierMachine.idKassa! : cashierMachine.description},
          Cashier Name: ${employee?.empName ?? user.username},
        ''';

        subject = "OTP RUBY POS Zero or Negative Transaction - [${store.storeCode}]";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            onKeyEvent: (node, value) {
              if (value.runtimeType == KeyUpEvent) {
                return KeyEventResult.handled;
              }

              if (value.physicalKey == PhysicalKeyboardKey.enter) {
                onSubmit(childContext, parentContext);
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                parentContext.pop();
              } else if (value.physicalKey == PhysicalKeyboardKey.f11) {
                handleOTP(childContext);
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
                      'Approval',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(360)),
                      ),
                      child: IconButton(
                        focusColor: const Color.fromARGB(255, 110, 0, 0),
                        focusNode: _keyboardFocusNode,
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
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(childContext).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(childContext).size.width * 0.5,
                            child: TextFormField(
                              focusNode: _usernameFocusNode,
                              controller: _usernameController,
                              autofocus: true,
                              keyboardType: TextInputType.none,
                              onFieldSubmitted: (value) async => await onSubmit(childContext, parentContext),
                              validator: (val) => val == null || val.isEmpty ? "Username is required" : null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Username",
                                  hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.person_4,
                                    size: 20,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(childContext).size.width * 0.5,
                            child: TextFormField(
                              focusNode: _passwordFocusNode,
                              controller: _passwordController,
                              obscureText: _obscureText,
                              autofocus: true,
                              keyboardType: TextInputType.none,
                              onFieldSubmitted: (value) async {
                                await onSubmit(childContext, parentContext);
                              },
                              validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                hintText: "Password",
                                hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Use OTP Instead',
                                      style: TextStyle(
                                        color: _isOTPClicked ? Colors.grey : ProjectColors.lightBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          FocusScope.of(childContext).unfocus();
                                          await handleOTP(childContext);
                                        },
                                    ),
                                    TextSpan(
                                      text: " (F11)",
                                      style: TextStyle(
                                          color: _isOTPClicked ? Colors.grey : ProjectColors.lightBlack,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              if (_isSendingOTP)
                                const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          (_showKeyboard)
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: KeyboardWidget(
                                    controller: _activeController,
                                    isNumericMode: false,
                                    customLayoutKeys: true,
                                    focusNodeAndTextController: FocusNodeAndTextController(
                                      focusNode: _activeFocusNode,
                                      textEditingController: _activeController,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(color: ProjectColors.primary))),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                    overlayColor: MaterialStateColor.resolveWith(
                                        (states) => ProjectColors.primary.withOpacity(.2))),
                                onPressed: () {
                                  Navigator.of(childContext).pop();
                                },
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Cancel",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "  (Esc)",
                                          style: TextStyle(fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                      style: TextStyle(color: ProjectColors.primary),
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(color: ProjectColors.primary))),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () async => await onSubmit(childContext, parentContext),
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Confirm",
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "  (Enter)",
                                          style: TextStyle(fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
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

enum ApprovalType {
  discount,
  zeroTransaction,

  closeShift,

  resetDatabase,

  general,
  returnItem,
}
