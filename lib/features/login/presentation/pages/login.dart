import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';
import 'package:pos_fe/features/login/domain/usecase/login.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/open_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/open_shift_success_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showVirtualKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // getDefaultKeyboardPOSParameter();
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardFocusNode.dispose();
  }

  // Future<void> getDefaultKeyboardPOSParameter() async {
  //   try {
  //     final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
  //     if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
  //     setState(() {
  //       showVirtualKeyboard = (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
  //     });
  //   } catch (e) {
  //     if (mounted) {
  //       SnackBarHelper.presentFailSnackBar(context, e.toString());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 134, 1, 1),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: showVirtualKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(360)),
              ),
              child: IconButton(
                focusColor: const Color.fromARGB(130, 20, 20, 0),
                focusNode: _keyboardFocusNode,
                icon: Icon(
                  showVirtualKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    showVirtualKeyboard = !showVirtualKeyboard;
                  });
                },
                tooltip: 'Toggle Keyboard',
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const BeOneLogo(size: 300),
            const SizedBox(height: 10),
            LoginForm(showKeyboard: showVirtualKeyboard),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final bool showKeyboard;
  const LoginForm({Key? key, required this.showKeyboard}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController usernameController, passwordController;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _loginButtonFocusNode = FocusNode();
  final FocusNode _showPassButtonFocusNode = FocusNode();
  String currentFocusedField = '';
  late bool _showKeyboard;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _showKeyboard = widget.showKeyboard;
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _usernameFocusNode.requestFocus();
    _usernameFocusNode.addListener(() {
      setState(() {
        currentFocusedField = _usernameFocusNode.hasFocus ? 'username' : currentFocusedField;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        currentFocusedField = _passwordFocusNode.hasFocus ? 'password' : currentFocusedField;
      });
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _loginButtonFocusNode.dispose();
    _showPassButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LoginForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showKeyboard != oldWidget.showKeyboard) {
      setState(() {
        _showKeyboard = widget.showKeyboard;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController? activeController;
    if (currentFocusedField == 'username') {
      activeController = usernameController;
    } else if (currentFocusedField == 'password') {
      activeController = passwordController;
    } else {
      activeController = usernameController;
    }

    return Center(
      child: Form(
        key: formKey,
        child: Column(children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: TextFormField(
              controller: usernameController,
              focusNode: _usernameFocusNode,
              validator: (val) => val == null || val.isEmpty ? "Username is required" : null,
              decoration: const InputDecoration(
                labelText: "Username / Email",
                hintText: "Insert username or email",
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: Icon(Icons.person_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.none,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: TextFormField(
              controller: passwordController,
              focusNode: _passwordFocusNode,
              validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Insert password",
                hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: const Icon(Icons.lock_outlined),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  focusNode: _showPassButtonFocusNode,
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
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Focus(
              focusNode: _loginButtonFocusNode,
              child: CustomButton(
                child: const Text("Login"),
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;
                  final SharedPreferences prefs = GetIt.instance<SharedPreferences>();
                  final bool isOpen = prefs.getBool('isOpen') ?? false;
                  final loginSuccess = await GetIt.instance<LoginUseCase>().call(
                      params: UserAuthEntity(
                          docId: null,
                          email: usernameController.text,
                          username: usernameController.text,
                          password: passwordController.text,
                          tohemId: null,
                          torolId: null));

                  if (loginSuccess != null && loginSuccess) {
                    if (isOpen) {
                      if (context.mounted) context.goNamed(RouteConstants.home);
                    } else {
                      final CashierBalanceTransactionModel? openedShift = await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const OpenShiftDialog(),
                      );

                      bool isOpenShiftConfirmed = false;

                      if (openedShift != null) {
                        isOpenShiftConfirmed = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return OpenShiftSuccessAlertDialog(
                                openedShift: openedShift,
                              );
                            });
                      } else {
                        await GetIt.instance<LogoutUseCase>().call();
                        return;
                      }

                      if (isOpenShiftConfirmed) {
                        context.pushNamed(RouteConstants.home);
                      }
                    }
                  } else {
                    if (context.mounted) {
                      SnackBarHelper.presentErrorSnackBar(context, "Invalid username or password");
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          _showKeyboard
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                  child: KeyboardWidget(
                    controller: activeController,
                    isNumericMode: false,
                    customLayoutKeys: true,
                  ),
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}

class LoginFormField extends StatelessWidget {
  const LoginFormField({
    Key? key,
    this.validator,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    required this.label,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  final String? Function(String? val)? validator;
  final Widget? prefix, prefixIcon, suffix, suffixIcon;
  final String label;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(bottom: 10),
          prefixIcon: prefixIcon,
          prefix: prefix,
          suffixIcon: suffixIcon,
          suffix: suffix,
          labelText: label),
    );
  }
}
