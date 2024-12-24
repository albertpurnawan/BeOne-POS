import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_va_details.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';

class InputDuitkuVADialog extends StatefulWidget {
  const InputDuitkuVADialog({
    super.key,
    required this.mopSelectionEntity,
    required this.paymentMethods,
    required this.amount,
    required this.onVASelected,
  });

  final Function(
    MopSelectionEntity,
  ) onVASelected;
  final MopSelectionEntity mopSelectionEntity;
  final List<dynamic> paymentMethods;
  final int amount;

  @override
  State<InputDuitkuVADialog> createState() => _InputDuitkuVADialogState();
}

class _InputDuitkuVADialogState extends State<InputDuitkuVADialog> {
  String? selectedPaymentMethod;
  DuitkuVADetailsEntity? vaDuitku;
  final _textEditingControllerVAAmount = TextEditingController();
  bool isErr = false;
  bool isConnected = true;
  String errMsg = "Invalid amount";
  MopSelectionEntity? mopVA;

  late FocusNode _focusNodeVADropdown;
  late final _focusNodeVAAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.handled;
      }

      if (event.physicalKey == PhysicalKeyboardKey.f12) {
        final String amountText = _textEditingControllerVAAmount.text.trim();
        final double mopAmount = Helpers.revertMoneyToDecimalFormat(amountText);

        if (isErr) return KeyEventResult.handled;

        if (selectedPaymentMethod == null || selectedPaymentMethod!.isEmpty) {
          SnackBarHelper.presentErrorSnackBar(context, "Please select a payment method");
          return KeyEventResult.handled;
        }

        if (amountText.isEmpty || mopAmount == 0) {
          SnackBarHelper.presentErrorSnackBar(context, "Please input the amount");
          return KeyEventResult.handled;
        }

        if (mopAmount < 10000) {
          SnackBarHelper.presentErrorSnackBar(context, "Minimal amount for Virtual Account is 10,000");
          return KeyEventResult.handled;
        }

        if (mopAmount > 100000000) {
          SnackBarHelper.presentErrorSnackBar(
              context, "Maximal amount is 100,000,000, please add other payment methods");
          return KeyEventResult.handled;
        }

        if (mopAmount > widget.amount) {
          setState(() {
            isErr = true;
            errMsg = "Amount exceeds the total amount";
          });
          return KeyEventResult.handled;
        }

        if (isConnected == false) {
          SnackBarHelper.presentErrorSnackBar(
              context, "No internet connection detected. Please check your network settings and try again");
          return KeyEventResult.handled;
        }

        mopVA = mopVA?.copyWith(
          cardName: vaDuitku!.paymentName,
          cardHolder: selectedPaymentMethod,
          edcDesc: vaDuitku!.paymentImage,
          amount: mopAmount,
          tpmt7Id: vaDuitku!.docId,
        );

        widget.onVASelected(mopVA!);
        context.pop(mopAmount);
        return KeyEventResult.handled;
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    },
  );

  final FocusNode _keyboardFocusNode = FocusNode();
  bool _showKeyboard = true;
  String initialAmount = "";

  @override
  initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    mopVA = widget.mopSelectionEntity;
    _focusNodeVADropdown = FocusNode();
    // _focusNodeRemarks = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodeVADropdown.requestFocus();
    });
    _checkConnection();
  }

  @override
  void dispose() {
    _textEditingControllerVAAmount.dispose();
    // _textEditingControllerRemarks.dispose();
    _focusNodeVAAmount.dispose();
    _focusNodeVADropdown.dispose();
    _keyboardFocusNode.dispose();
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

  Future<void> _checkConnection() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        isConnected = false;
      });
    } else if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      setState(() {
        isConnected = true;
      });
    }
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
                    'Select Virtual Account',
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
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        hint: const Text("Choose a Virtual Account"),
                        value: selectedPaymentMethod,
                        focusNode: _focusNodeVADropdown,
                        isExpanded: true,
                        icon: null,
                        elevation: 18,
                        style: const TextStyle(
                          color: ProjectColors.mediumBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          hintText: "",
                          hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: ProjectColors.mediumBlack, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: ProjectColors.primary, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 24,
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a payment method';
                          }
                          return null;
                        },
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMethod = newValue;

                            final selectedMethod =
                                widget.paymentMethods.firstWhere((method) => method.paymentMethod == newValue);

                            log("selectedMethod = $selectedMethod");

                            if (selectedMethod != null) {
                              vaDuitku = DuitkuVADetailsEntity(
                                docId: selectedMethod.docId ?? "",
                                paymentMethod: selectedPaymentMethod ?? "",
                                paymentName: selectedMethod.paymentName,
                                paymentImage: selectedMethod.paymentImage,
                                totalFee: selectedMethod.totalFee ?? 0,
                                statusActive: selectedMethod.statusActive ?? 0,
                              );
                            }
                          });
                        },
                        items: widget.paymentMethods.where(
                          (method) {
                            final paymentName = method.paymentName.trim();
                            return paymentName.contains(' VA ') ||
                                paymentName.endsWith(' VA') && method.statusActive == 1;
                          },
                        ).map((method) {
                          return DropdownMenuItem<String>(
                            value: method.paymentMethod,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(method.paymentName),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    method.paymentImage.endsWith(".SVG")
                                        ? SvgPicture.network(
                                            method.paymentImage,
                                            width: 30,
                                            height: 30,
                                          )
                                        : Image.network(
                                            method.paymentImage,
                                            width: 75,
                                            height: 50,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        focusNode: _focusNodeVAAmount,
                        controller: _textEditingControllerVAAmount,
                        autofocus: true,
                        inputFormatters: [MoneyInputFormatter()],
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 18),
                        onChanged: (value) {
                          final double mopAmount = Helpers.revertMoneyToDecimalFormat(value);
                          if (mopAmount > widget.amount) {
                            setState(() {
                              isErr = true;
                              errMsg = "Max amount exceeded";
                            });
                          } else if (mopAmount <= 0) {
                            setState(() {
                              isErr = true;
                              errMsg = "Amount can't be negative or zero";
                            });
                          } else if (isErr) {
                            setState(() {
                              isErr = false;
                              errMsg = "Invalid amount";
                            });
                          }
                        },
                        onEditingComplete: () async {
                          if (isErr) return;
                          if (selectedPaymentMethod == null || selectedPaymentMethod!.isEmpty) {
                            SnackBarHelper.presentErrorSnackBar(childContext, "Please select a payment method");
                            return;
                          }
                          if (mopVA == null) return;
                          final double mopAmount =
                              Helpers.revertMoneyToDecimalFormat(_textEditingControllerVAAmount.text);
                          if (_textEditingControllerVAAmount.text.isEmpty || mopAmount == 0) {
                            SnackBarHelper.presentErrorSnackBar(childContext, "Please input the amount");
                            return;
                          }
                          if (mopAmount < 10000) {
                            SnackBarHelper.presentErrorSnackBar(
                                childContext, "Minimal amount for Virtual Account is 10,000");
                            return;
                          }

                          if (mopAmount > 100000000) {
                            SnackBarHelper.presentErrorSnackBar(
                                childContext, "Maximal amount is 100,000,000, please add other payment methods");
                            return;
                          }

                          if (mopAmount > widget.amount) {
                            setState(() {
                              isErr = true;
                              errMsg = "Amount exceeds the total amount";
                            });
                            return;
                          }

                          await _checkConnection();
                          if (!isConnected) {
                            SnackBarHelper.presentErrorSnackBar(childContext,
                                "No internet connection detected. Please check your network settings and try again");
                            return;
                          }

                          mopVA = mopVA?.copyWith(
                            cardName: vaDuitku!.paymentName,
                            cardHolder: selectedPaymentMethod,
                            edcDesc: vaDuitku!.paymentImage,
                            amount: mopAmount,
                            tpmt7Id: vaDuitku!.docId,
                          );
                          widget.onVASelected(mopVA!);
                          context.pop(mopAmount);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintText: "Enter Amount (MAX: ${widget.amount})",
                            hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                            border: const OutlineInputBorder(),
                            suffix: isErr
                                ? Text(
                                    errMsg,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w700,
                                        color: ProjectColors.swatch),
                                  )
                                : null,
                            prefixIcon: const Icon(
                              Icons.payments_outlined,
                              size: 24,
                            )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    (_showKeyboard)
                        ? KeyboardWidget(
                            controller: _textEditingControllerVAAmount,
                            isNumericMode: true,
                            customLayoutKeys: true,
                            focusNodeAndTextController: FocusNodeAndTextController(
                              focusNode: _focusNodeVAAmount,
                              textEditingController: _textEditingControllerVAAmount,
                            ),
                            textFormatter: MoneyInputFormatter(),
                            onChanged: () {
                              String text = _textEditingControllerVAAmount.text;
                              TextSelection currentSelection = _textEditingControllerVAAmount.selection;
                              int cursorPosition = currentSelection.end;
                              String inputText = _textEditingControllerVAAmount.text;
                              text = text.replaceRange(cursorPosition, cursorPosition, inputText);
                              cursorPosition += inputText.length;
                              final double mopAmount = Helpers.revertMoneyToDecimalFormat(text);
                              if (mopAmount > widget.amount) {
                                setState(() {
                                  isErr = true;
                                  errMsg = "Max amount exceeded";
                                });
                              } else if (mopAmount <= 0) {
                                setState(() {
                                  isErr = true;
                                  errMsg = "Amount can't be negative or zero";
                                });
                              } else if (isErr) {
                                setState(() {
                                  isErr = false;
                                  errMsg = "Invalid amount";
                                });
                              }
                            },
                            // onKeyPress: (key) async {
                            //   String text = _textEditingControllerVAAmount.text;
                            //   TextSelection currentSelection = _textEditingControllerVAAmount.selection;
                            //   int cursorPosition = currentSelection.end;

                            //   if (key.keyType == VirtualKeyboardKeyType.String) {
                            //   } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                            //     switch (key.action) {
                            //       case VirtualKeyboardKeyAction.Backspace:
                            //         if (text.isNotEmpty && cursorPosition > 0) {
                            //           text = text.replaceRange(cursorPosition - 1, cursorPosition, '');
                            //           cursorPosition -= 1;

                            //           final double mopAmount = Helpers.revertMoneyToDecimalFormat(text);
                            //           if (mopAmount > widget.amount) {
                            //             setState(() {
                            //               isErr = true;
                            //               errMsg = "Max amount exceeded";
                            //             });
                            //           } else if (mopAmount <= 0) {
                            //             setState(() {
                            //               isErr = true;
                            //               errMsg = "Amount can't be negative or zero";
                            //             });
                            //           } else if (isErr) {
                            //             setState(() {
                            //               isErr = false;
                            //               errMsg = "Invalid amount";
                            //             });
                            //           }
                            //         }
                            //         break;
                            //       default:
                            //         break;
                            //     }
                            //   }
                            //   TextEditingValue formattedValue = MoneyInputFormatter().formatEditUpdate(
                            //     TextEditingValue(
                            //       text: text,
                            //       selection: TextSelection.collapsed(offset: cursorPosition),
                            //     ),
                            //     TextEditingValue(
                            //       text: text,
                            //       selection: TextSelection.collapsed(offset: cursorPosition),
                            //     ),
                            //   );
                            //   _textEditingControllerVAAmount.text = formattedValue.text;
                            //   _textEditingControllerVAAmount.selection = formattedValue.selection;
                            //   setState(() {});
                            // },
                          )
                        : const SizedBox.shrink(),
                  ],
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
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                    onPressed: () {
                      setState(() {
                        context.pop();
                      });
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                    onPressed: () async {
                      final double mopAmount = Helpers.revertMoneyToDecimalFormat(_textEditingControllerVAAmount.text);

                      if (isErr) return;

                      if (selectedPaymentMethod == null || selectedPaymentMethod!.isEmpty) {
                        SnackBarHelper.presentErrorSnackBar(childContext, "Please select a payment method");
                        return;
                      }

                      if (mopVA == null) return;

                      if (_textEditingControllerVAAmount.text.isEmpty || mopAmount == 0) {
                        SnackBarHelper.presentErrorSnackBar(childContext, "Please input the amount");
                        return;
                      }

                      // Log mopAmount to debug
                      log('Entered amount: $mopAmount');

                      if (mopAmount < 10000) {
                        SnackBarHelper.presentErrorSnackBar(
                            childContext, "Minimal amount for Virtual Account is 10,000");
                        return;
                      }

                      if (mopAmount > 100000000) {
                        SnackBarHelper.presentErrorSnackBar(
                            childContext, "Maximal amount is 100,000,000, please add other payment methods");
                        return;
                      }

                      if (mopAmount > widget.amount) {
                        setState(() {
                          isErr = true;
                          errMsg = "Amount exceeds the total amount";
                        });
                        return;
                      }

                      await _checkConnection();
                      if (!isConnected) {
                        SnackBarHelper.presentErrorSnackBar(childContext,
                            "No internet connection detected. Please check your network settings and try again");
                        return;
                      }

                      mopVA = mopVA?.copyWith(
                        cardName: vaDuitku!.paymentName,
                        cardHolder: selectedPaymentMethod,
                        edcDesc: vaDuitku!.paymentImage,
                        amount: mopAmount,
                        tpmt7Id: vaDuitku!.docId,
                      );

                      widget.onVASelected(mopVA!);
                      context.pop(mopAmount);
                    },
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Set",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: "  (F12)",
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
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          ),
        );
      }),
    );
  }
}
