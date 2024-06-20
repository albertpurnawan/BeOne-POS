import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';

class OTPInputDialog extends StatefulWidget {
  final double discountValue;

  const OTPInputDialog({Key? key, required this.discountValue})
      : super(key: key);

  @override
  State<OTPInputDialog> createState() => _OTPInputDialogState();
}

class _OTPInputDialogState extends State<OTPInputDialog> {
  final _otpControllers = List<TextEditingController>.generate(
      6, (index) => TextEditingController());
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

  Future<void> resendOTP() async {
    await Future.delayed(const Duration(seconds: 3));
    log("OTP SENDED");
    setState(() {
      _isOTPSent = true;
    });
    await showOTPSent();
    _startTimer();
  }

  Future<void> onSubmit(BuildContext context) async {
    // if otp send == otp received
    context
        .read<ReceiptCubit>()
        .updateTotalAmountFromDiscount(widget.discountValue);
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).pop(); // Close the select method if needed
    Navigator.of(context).pop(); // Close the input discount if needed
    SnackBarHelper.presentSuccessSnackBar(context,
        "Header discount applied: ${Helpers.parseMoney(widget.discountValue)}");
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
          // Navigator.of(context).pop(); // Close dialog when time's up
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
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, value) {
        log("otpinputdialog $value");
        if (value.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (value.physicalKey == PhysicalKeyboardKey.enter) {
          onSubmit(context);
          return KeyEventResult.handled;
        } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
          context.pop();
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: const Text(
            'OTP Confirmation',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Text(
                    'Insert OTP Code You Received',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          focusNode: index == 0 ? _otpFocusNode : null,
                          controller: _otpControllers[index],
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
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
                              borderSide: BorderSide(
                                  color: ProjectColors.primary, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            } else if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isNotEmpty && index == 5) {
                              _updateOtpCode();
                              // FocusScope.of(context).unfocus();
                              log("OTP Code: $_otpCode");
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "Remaining Time: ${_formatDuration(Duration(seconds: _remainingSeconds))}"),
                  if (_isTimeUp && !_isSendingOTP) ...[
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Resend OTP',
                            style: TextStyle(
                              color: _isOTPClicked
                                  ? Colors.grey
                                  : ProjectColors.primary,
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
                                color: _isOTPClicked
                                    ? Colors.grey
                                    : ProjectColors.primary,
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
                ],
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
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => ProjectColors.primary.withOpacity(.2))),
                onPressed: () {
                  Navigator.of(context).pop();
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
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => ProjectColors.primary),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white.withOpacity(.2))),
                  onPressed: () async {
                    log("OTP Code: $_otpCode");
                    await onSubmit(context);
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
    );
  }
}
