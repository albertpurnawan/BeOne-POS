import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/usecases/restore_database_usecase.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';

class InputPasswordDialog extends StatefulWidget {
  const InputPasswordDialog({super.key});

  @override
  State<InputPasswordDialog> createState() => InputPasswordDialogState();
}

class InputPasswordDialogState extends State<InputPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  // final FocusNode _textFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _textFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    // _textFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            onKeyEvent: (node, value) {
              if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

              if (value.physicalKey == PhysicalKeyboardKey.enter) {
                // Handle Enter
                // double input = Helpers.revertMoneyToDecimalFormat(_textEditorController.text);
                // final ReceiptEntity state = context.read<ReceiptCubit>().state;
                // if ((input > state.subtotal - (state.discAmount ?? 0)) || input <= 0) {
                //   context.pop();
                //   ErrorHandler.presentErrorSnackBar(context, "Invalid discount amount");
                //   return KeyEventResult.handled;
                // }
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (context) => AuthInputDiscountDialog(
                //           discountValue: input,
                //           docnum: widget.docnum,
                //         ));
                return KeyEventResult.handled;
              } else if (value.physicalKey == PhysicalKeyboardKey.escape) {
                context.pop();
              }

              return KeyEventResult.ignored;
            },
            focusNode: _keyboardListenerFocusNode,
            child: AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              title: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Input Password',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                  child: CustomInput(
                    // focusNode: _textFocusNode,
                    controller: _passwordController,
                    label: "Password",
                    hint: "Database Password",
                    prefixIcon: const Icon(Icons.lock),
                    validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
                    type: CustomInputType.password,
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
                          backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                      onPressed: () async {
                        //handle onpressed
                        await RestoreDatabaseUseCase()
                            .call(params: RestoreDatabaseParams(_passwordController.text, context: context));
                        context.pop(true);
                        context.pop(true);
                        context.pop(true);
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
                    )),
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
