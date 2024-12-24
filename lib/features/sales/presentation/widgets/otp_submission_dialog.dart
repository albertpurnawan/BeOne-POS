import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/otp_service.dart';
import 'package:pos_fe/features/sales/data/models/approval_invoice.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OTPSubmissionDialog extends StatefulWidget {
  final String requester;
  final String subject;
  final String body;

  const OTPSubmissionDialog({super.key, required this.requester, required this.subject, required this.body});

  @override
  State<OTPSubmissionDialog> createState() => _OTPSubmissionDialogState();
}

class _OTPSubmissionDialogState extends State<OTPSubmissionDialog> {
  final _otpControllers = List<TextEditingController>.generate(6, (index) => TextEditingController());
  String _otpCode = '';
  late Timer _timer;
  int _remainingSeconds = 30;
  bool _isTimeUp = false;
  bool _isSendingOTP = false;
  bool _isOTPClicked = false;
  bool _isOTPSent = false;
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _showKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();
  String currentFocusedField = '';
  int _focusedIndex = 0;

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    _startTimer();
    _otpFocusNodes[0].requestFocus();
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].addListener(() {
        if (_otpFocusNodes[i].hasFocus) {
          setState(() {
            _focusedIndex = i;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _keyboardFocusNode.dispose();
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].dispose();
    }
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

  Future<void> resendOTP() async {
    try {
      await GetIt.instance<OTPServiceAPi>().createSendOTP(context, null, widget.subject, widget.body);

      setState(() {
        _isOTPSent = true;
      });
      await showOTPSent();
      _startTimer();
    } catch (e) {
      rethrow;
    }
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
      await updateReceiptApprovals(childContext, response['approver']!);

      if (childContext.mounted) {
        parentContext.pop(true); // Close the input otp dialog
        parentContext.pop(true); // Close the input otp dialog
        parentContext.pop(true); // Close the input otp dialog

        SnackBarHelper.presentSuccessSnackBar(parentContext, "Approval Success", 3);
      }
    } else {
      const message = "Wrong Code, Please Check Again";
      if (childContext.mounted) {
        SnackBarHelper.presentErrorSnackBar(childContext, message);
      }
    }
  }

  Future<void> updateReceiptApprovals(BuildContext context, String approver) async {
    final user = await GetIt.instance<AppDatabase>().userDao.readbyEmail(approver, null);
    final receiptCubit = context.read<ReceiptCubit>();

    final approval = ApprovalInvoiceModel(
      docId: const Uuid().v4(),
      createDate: DateTime.now(),
      updateDate: null,
      toinvId: receiptCubit.state.docNum,
      tousrId: user!.docId,
      remarks: "Approval Transaction 0",
      category: "002 - Transaction 0",
    );
    context.read<ReceiptCubit>().updateApprovals(approval);
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
                  _otpFocusNodes[0].requestFocus();

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
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'OTP Confirmation',
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
                                  focusNode: _otpFocusNodes[index],
                                  controller: _otpControllers[index],
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                  maxLength: 1,
                                  keyboardType: TextInputType.none,
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
                                          _otpFocusNodes[0].requestFocus();

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
                          const SizedBox(height: 10),
                          (_showKeyboard)
                              ? KeyboardWidget(
                                  controller: _otpControllers[_focusedIndex],
                                  isNumericMode: true,
                                  customLayoutKeys: true,
                                  focusNodeAndTextController: FocusNodeAndTextController(
                                    focusNode: _otpFocusNodes[_focusedIndex],
                                    textEditingController: _otpControllers[_focusedIndex],
                                  ),
                                  onChanged: () async {
                                    String text = _otpControllers[_focusedIndex].text;

                                    if (text.isNotEmpty && _focusedIndex < 5) {
                                      _otpFocusNodes[_focusedIndex + 1].requestFocus();
                                    } else if (text.isNotEmpty && _focusedIndex == 5) {
                                      _updateOtpCode();
                                      await onSubmit(parentContext, childContext, _otpCode, widget.requester);
                                    }
                                  },
                                  onChangedBackspace: () {
                                    String text = _otpControllers[_focusedIndex].text;
                                    if (text.isNotEmpty) {
                                      text = text.substring(0, text.length - 1);
                                      _otpControllers[_focusedIndex].text = text;
                                    }

                                    if (text.isEmpty && _focusedIndex > 0) {
                                      _otpFocusNodes[_focusedIndex - 1].requestFocus();
                                    }
                                  },
                                )
                              : const SizedBox.shrink(),
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
              actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            ),
          ),
        );
      }),
    );
  }
}
