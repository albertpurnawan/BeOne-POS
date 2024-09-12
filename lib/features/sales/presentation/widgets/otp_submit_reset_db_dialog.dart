import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/otp_service.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/settings/domain/usecases/get_pos_parameter.dart';

class OTPResetDBDialog extends StatefulWidget {
  final String requester;
  const OTPResetDBDialog({super.key, required this.requester});

  @override
  State<OTPResetDBDialog> createState() => _OTPResetDBDialogState();
}

class _OTPResetDBDialogState extends State<OTPResetDBDialog> {
  final _otpControllers = List<TextEditingController>.generate(6, (index) => TextEditingController());
  String _otpCode = '';
  late Timer _timer;
  int _remainingSeconds = 30;
  bool _isTimeUp = false;
  bool _isSendingOTP = false;
  bool _isOTPClicked = false;
  bool _isOTPSent = false;
  late FocusNode _otpFocusNode;

  @override
  void initState() {
    super.initState();
    _otpFocusNode = FocusNode();
    _startTimer();
    _otpFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _otpFocusNode.dispose();
    super.dispose();
  }

  Future<String> getApprover(String email) async {
    try {
      final UserEntity? user = await GetIt.instance<AppDatabase>().userDao.readbyEmail(email, null);
      if (user == null) throw "User not found";

      return user.username;
    } catch (e) {
      log("$e when fetch reset db approver");
    }
    return "";
  }

  Future<void> onSubmit(BuildContext parentContext, BuildContext childContext, String otp, String requester) async {
    final response = await GetIt.instance<OTPServiceAPi>().validateOTP(otp, requester);

    if (response['status'] == "200") {
      if (childContext.mounted) {
        showDialog(
          context: childContext,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 2));
      if (childContext.mounted) {
        parentContext.pop(true); // Close the input otp dialog
        parentContext.pop(true); // Close the input otp dialog
        parentContext.pop(true); // Close the input otp dialog

        SnackBarHelper.presentSuccessSnackBar(parentContext, "Approval Success", 3);
        await GetIt.instance<AppDatabase>().resetDatabase();
        // exit(0);
      }
    } else {
      const message = "Wrong Code, Please Check Again";
      if (childContext.mounted) {
        SnackBarHelper.presentErrorSnackBar(childContext, message);
      }
    }
  }

  Future<void> showOTPSent() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isOTPSent = false;
      _remainingSeconds = 30;
    });
  }

  void _updateOtpCode() {
    setState(() {
      _otpCode = _otpControllers.map((e) => e.text).join();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _isTimeUp = true;
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  Future<void> resendOTP() async {
    try {
      final POSParameterEntity? topos = await GetIt.instance<GetPosParameterUseCase>().call();
      if (topos == null) throw "Failed to retrieve POS Parameter";

      final StoreMasterEntity? store = await GetIt.instance<GetStoreMasterUseCase>().call(params: topos.tostrId);
      if (store == null) throw "Failed to retrieve Store Master";

      final cashierMachine = await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(topos.tocsrId!, null);
      if (cashierMachine == null) throw "Failed to retrieve Cash Register";

      final String body = '''
    Approval For: Reset Database,
    Store Name: ${store.storeName},
    Cash Register Id: ${(cashierMachine.description == "") ? cashierMachine.idKassa! : cashierMachine.description},
''';

      final String subject = "OTP RUBY POS Reset Database - [${store.storeCode}]";

      await GetIt.instance<OTPServiceAPi>().createSendOTP(context, null, subject, body);

      setState(() {
        _isOTPSent = true;
      });
      await showOTPSent();
      _startTimer();
    } catch (e) {
      rethrow;
    }
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
                onSubmit(parentContext, childContext, _otpCode, widget.requester);
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                parentContext.pop();
              } else if (value.physicalKey == PhysicalKeyboardKey.f11) {
                setState(() {
                  _isOTPClicked = true;
                  _isSendingOTP = true;
                  _isOTPSent = false;
                  _otpFocusNode.requestFocus();

                  for (int i = 0; i < 6; i++) {
                    _otpControllers[i].text = "";
                  }
                });

                resendOTP().then((value) {
                  setState(() {
                    _isOTPClicked = false;
                    _isSendingOTP = false;
                    _isTimeUp = false;
                  });
                });
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
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: const Text(
                  'OTP Confirmation',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                width: MediaQuery.of(childContext).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Insert OTP Code You Received',
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: TextField(
                                  focusNode: index == 0 ? _otpFocusNode : null,
                                  controller: _otpControllers[index],
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ProjectColors.primary, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.green, width: 2),
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    if (value.isEmpty && index > 0) {
                                      FocusScope.of(childContext).previousFocus();
                                    } else if (value.isNotEmpty && index < 5) {
                                      FocusScope.of(childContext).nextFocus();
                                    } else if (value.isNotEmpty && index == 5) {
                                      _updateOtpCode();
                                      // FocusScope.of(context).unfocus();
                                      await onSubmit(parentContext, childContext, _otpCode, widget.requester);
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          Text("Remaining Time: ${_formatDuration(Duration(seconds: _remainingSeconds))}"),
                          if (_isTimeUp && !_isSendingOTP) ...[
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Resend OTP',
                                    style: TextStyle(
                                      color: _isOTPClicked ? Colors.grey : ProjectColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        setState(() {
                                          _isOTPClicked = true;
                                          _isSendingOTP = true;
                                          _isOTPSent = false;
                                          _otpFocusNode.requestFocus();

                                          for (int i = 0; i < 6; i++) {
                                            _otpControllers[i].text = "";
                                          }
                                        });

                                        await resendOTP();
                                        setState(() {
                                          _isOTPClicked = false;
                                          _isSendingOTP = false;
                                          _isTimeUp = false;
                                        });
                                      },
                                  ),
                                  TextSpan(
                                    text: " (F11)",
                                    style: TextStyle(
                                        color: _isOTPClicked ? Colors.grey : ProjectColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (_isTimeUp && _isSendingOTP) ...[
                            const SizedBox(height: 15),
                            (_isOTPSent)
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "OTP SENT",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: ProjectColors.green,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 24,
                                        color: ProjectColors.green,
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                          const SizedBox(height: 15),
                          _warningtext(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(color: ProjectColors.primary))),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          overlayColor:
                              MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
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
                              side: const BorderSide(color: ProjectColors.primary),
                            )),
                            backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                        onPressed: () async {
                          await onSubmit(parentContext, childContext, _otpCode, widget.requester);
                        },
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Enter",
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
                      ),
                    ),
                  ],
                ),
              ],
              actionsPadding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            ),
          ),
        );
      }),
    );
  }

  Widget _warningtext() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        border: Border.all(
          color: Colors.yellow.shade700,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            color: Colors.yellow.shade700,
            size: 42.0,
          ),
          const SizedBox(width: 10.0),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Refreshing the database might take some time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Please wait until the process is finished.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
