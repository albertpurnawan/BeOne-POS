import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/otp_service.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/widgets/otp_unlock_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnlockInvoice extends StatefulWidget {
  const UnlockInvoice({super.key});

  @override
  State<UnlockInvoice> createState() => _UnlockInvoiceState();
}

class _UnlockInvoiceState extends State<UnlockInvoice> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceDocNumTextController = TextEditingController();
  final _fullDocNumTextController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final prefs = GetIt.instance<SharedPreferences>();
  final _invoiceDocNumFocusNode = FocusNode();
  final _fullDocNumFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  List<InvoiceDetailModel>? invoiceFound;
  InvoiceDetailModel? selectedInvoice;
  bool showInvoice = false;
  bool _obscureText = true;
  bool _isOTPClicked = false;
  bool _isSendingOTP = false;
  String fullDocnum = "";

  @override
  void initState() {
    super.initState();
    _invoiceDocNumFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _invoiceDocNumTextController.dispose();
    _fullDocNumTextController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _invoiceDocNumFocusNode.dispose();
    _fullDocNumFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  Future<List<InvoiceDetailModel>?> _searchInvoiceDetail(String docNum) async {
    final invoiceDetail = await GetIt.instance<AppDatabase>().invoiceDetailDao.readByRefpos2(docNum, null);
    return invoiceDetail;
  }

  Future<Map<InvoiceDetailModel, Map<String, dynamic>>> _fetchSearchResultsWithDetails() async {
    final searchResults = invoiceFound;

    if (searchResults == null) {
      return {};
    }

    final resultMap = <InvoiceDetailModel, Map<String, dynamic>>{};

    for (var invoice in searchResults) {
      final additionalDetails = await _searchInvoiceDetail(invoice.refpos2 ?? "");

      resultMap[invoice] = {
        'additionalDetails': additionalDetails ?? [],
      };
    }

    return resultMap;
  }

  void _handleInvoiceSelected(InvoiceDetailModel? invoice) async {
    if (invoice != null) {
      setState(() {
        _invoiceDocNumTextController.text = "";
        invoiceFound = null;
        selectedInvoice = invoice;
        showInvoice = true;
      });
    }
  }

  Future<void> onSubmit(BuildContext childContext, BuildContext parentContext) async {
    log("HREEEEEEEE");
    FocusScope.of(context).unfocus();
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) return;

    String passwordCorrect = await checkPassword(_usernameController.text, _passwordController.text);
    if (passwordCorrect == "Success") {
      if (!context.mounted) return;

      // unlock DP HERE
      final String cashierName = GetIt.instance<SharedPreferences>().getString("username") ?? "";
      final UserModel? user = await GetIt.instance<AppDatabase>().userDao.readByUsername(cashierName, null);
      List<String> docnumList = [selectedInvoice?.refpos2 ?? fullDocnum];
      if (user != null) {
        String checkLock = await GetIt.instance<InvoiceApi>().unlockInvoice(user.docId, docnumList);
        log("checkLock - $checkLock");
        if (checkLock != 'Unlock Down Payment success') {
          SnackBarHelper.presentErrorSnackBar(
              childContext, "Failed to process, please check your connection and try again");
          return;
        }
      }
      SnackBarHelper.presentSuccessSnackBar(context, "Invoice unlocked successfully", 3);
      Navigator.pop(childContext);
    } else {
      final message = passwordCorrect == "Wrong Password" ? "Invalid username or password" : "Unauthorized";
      SnackBarHelper.presentErrorSnackBar(childContext, message);
      if (Platform.isWindows) _usernameFocusNode.requestFocus();
    }
  }

  Future<String> checkPassword(String username, String password) async {
    String hashedPassword = md5.convert(utf8.encode(password)).toString();
    String check = "";
    String category = "discandround";

    final UserModel? user = await GetIt.instance<AppDatabase>().userDao.readByUsername(username, null);

    if (user != null) {
      final tastr = await GetIt.instance<AppDatabase>().authStoreDao.readByTousrId(user.docId, category, null);

      if (tastr != null && tastr.tousrdocid == user.docId) {
        if (tastr.statusActive != 1) {
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
          builder: (context) => OTPUnlockDialog(
            requester: value,
            docnum: selectedInvoice?.refpos2 ?? fullDocnum,
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

  Future<String> createOTP() async {
    try {
      final DateTime now = DateTime.now();

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

      final String body = '''
    Approval For: Unlock Invoice,
    Store Name: ${store.storeName},
    Cash Register Id: ${(cashierMachine.description == "") ? cashierMachine.idKassa! : cashierMachine.description},
    Cashier Name: ${employee?.empName ?? user.username},
    Request Date: ${Helpers.dateEEddMMMyyy(now)},
    Invoice Document Number: ${selectedInvoice?.refpos2 ?? ""}
''';

      final String subject = "OTP RUBY POS Unlock Invoice - [${store.storeCode}]";

      final response = await GetIt.instance<OTPServiceAPi>().createSendOTP(context, null, subject, body);

      return response['Requester'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Builder(builder: (childContext) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Focus(
          onKeyEvent: (node, value) {
            if (value.runtimeType == KeyUpEvent) {
              return KeyEventResult.handled;
            }

            if (value.physicalKey == PhysicalKeyboardKey.enter) {
              if (node.hasFocus) {
                return KeyEventResult.ignored;
              } else {
                onSubmit(childContext, context);
                return KeyEventResult.handled;
              }
            } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
              context.pop();
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
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: const Text(
                'Unlock Invoice',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(childContext).size.width * 0.6,
                height: MediaQuery.of(childContext).size.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _inputInvoiceNumber(),
                      const SizedBox(height: 10),
                      const Divider(),
                      if (!showInvoice)
                        Expanded(
                          child: _searchResult(onInvoiceSelected: _handleInvoiceSelected),
                        ),
                      if (showInvoice)
                        SizedBox(
                          child: _unlockInvoice(childContext),
                        ),
                      const SizedBox(height: 10),
                      _actionButtons(childContext, context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }));
  }

  Widget _inputInvoiceNumber() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Search Invoice",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _invoiceDocNumFocusNode,
                          textAlign: TextAlign.start,
                          controller: _invoiceDocNumTextController,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintText: "Type Invoice Document Number",
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
                          onTap: () {
                            FocusScope.of(context).requestFocus(_invoiceDocNumFocusNode);
                          },
                          onEditingComplete: () async {
                            _invoiceDocNumFocusNode.unfocus();
                            final invoiceSearched = await _searchInvoiceDetail(_invoiceDocNumTextController.text);
                            setState(() {
                              invoiceFound = invoiceSearched;
                              showInvoice = false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
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
                          _invoiceDocNumFocusNode.unfocus();
                          final invoiceSearched = await _searchInvoiceDetail(_invoiceDocNumTextController.text);
                          setState(() {
                            invoiceFound = invoiceSearched;
                            showInvoice = false;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: const Icon(
                          Icons.search_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchResult({required Function(InvoiceDetailModel?) onInvoiceSelected}) {
    final query = _invoiceDocNumTextController.text.trim();

    if (query.isEmpty) return const SizedBox.shrink();

    return FutureBuilder<Map<InvoiceDetailModel, Map<String, dynamic>>>(
      future: _fetchSearchResultsWithDetails(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // } else
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty && showInvoice == false) {
          return Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "No results found.\nInput invoice number below to unlock the invoice.\nPlease make sure it's the correct invoice number!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _fullDocNumFocusNode,
                          textAlign: TextAlign.start,
                          controller: _fullDocNumTextController,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintText: "Type Invoice Document Number",
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
                          onEditingComplete: () {
                            if (_fullDocNumTextController.text == "" || _fullDocNumTextController.text.length != 24) {
                              log(_fullDocNumTextController.text);
                              SnackBarHelper.presentErrorSnackBar(context, "Please input the correct invoice number");
                              Future.delayed(const Duration(milliseconds: 200), () {
                                _fullDocNumFocusNode.unfocus();
                              });
                              return;
                            }
                            setState(() {
                              showInvoice = true;
                              fullDocnum = _fullDocNumTextController.text;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
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
                        onPressed: () {
                          if (_fullDocNumTextController.text == "" || _fullDocNumTextController.text.length != 24) {
                            log(_fullDocNumTextController.text);
                            SnackBarHelper.presentErrorSnackBar(context, "Please input the correct invoice number");
                            Future.delayed(const Duration(milliseconds: 200), () {
                              _fullDocNumFocusNode.unfocus();
                            });
                            return;
                          }
                          setState(() {
                            showInvoice = true;
                            fullDocnum = _fullDocNumTextController.text;
                          });
                        },
                        child: const Icon(
                          Icons.lock_open_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          final searchResultsWithDetails = snapshot.data!;
          return ListView.builder(
            itemCount: searchResultsWithDetails.length,
            itemBuilder: (context, index) {
              final invoice = searchResultsWithDetails.keys.elementAt(index);

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Card(
                  color: ProjectColors.background,
                  shadowColor: ProjectColors.background,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      onInvoiceSelected(invoice);
                    },
                    textColor: Colors.black,
                    title: Text(
                      invoice.refpos2 ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _unlockInvoice(BuildContext childContext) {
    log("selectedInvoice - $selectedInvoice");
    final invoiceDocnum = selectedInvoice?.refpos2 ?? fullDocnum;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Authorization needed to unlock invoice with number:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  invoiceDocnum,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.green,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) async => await onSubmit(childContext, context),
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
                      controller: _passwordController,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (value) async {
                        await onSubmit(childContext, context);
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
                        width: 10,
                      ),
                      if (_isSendingOTP)
                        const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext childContext, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 00, 0, 10),
        child: Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
            showInvoice
                ? Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: ProjectColors.primary))),
                          backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                      onPressed: () async => await onSubmit(childContext, context),
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Confirm",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              // TextSpan(
                              //   text: "  (Enter)",
                              //   style: TextStyle(fontWeight: FontWeight.w300),
                              // ),
                            ],
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
