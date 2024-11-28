import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/usecases/restore_database_usecase.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';

class InputPasswordDialog extends StatefulWidget {
  const InputPasswordDialog({super.key});

  @override
  State<InputPasswordDialog> createState() => InputPasswordDialogState();
}

class InputPasswordDialogState extends State<InputPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  bool _showKeyboard = true;
  bool _hidePassword = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String errorMessage = "";
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Focus(
            onKeyEvent: (node, value) {
              if (value.runtimeType == KeyUpEvent) return KeyEventResult.handled;

              if (value.physicalKey == PhysicalKeyboardKey.enter) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Input Password',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(360)),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_alt_outlined,
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
                width: MediaQuery.of(context).size.width * 0.5,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Database Password",
                              hintStyle: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.none,
                            obscureText: _hidePassword,
                          ),
                        ),
                        if (errorMessage != "")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 15),
                        Container(
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
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.yellow.shade700,
                                size: 26.0,
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                "The app will close itself after the database is restored!",
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
                        ),
                        const SizedBox(height: 15),
                        (_showKeyboard)
                            ? KeyboardWidget(
                                controller: _passwordController,
                                isNumericMode: false,
                              )
                            : const SizedBox.shrink(),
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
                        await RestoreDatabaseUseCase()
                            .call(params: RestoreDatabaseParams(_passwordController.text, context: context));
                        exit(0);
                      },
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Proceed",
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
