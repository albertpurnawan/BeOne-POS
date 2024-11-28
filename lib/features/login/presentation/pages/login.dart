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
      ),
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            BeOneLogo(size: 300),
            SizedBox(height: 10),
            LoginForm(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController usernameController, passwordController;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _loginButtonFocusNode = FocusNode();
  String currentFocusedField = '';

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
                hintText: "Username / Email",
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
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Password",
                prefixIcon: Icon(Icons.lock_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.none,
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
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            titlePadding: const EdgeInsets.all(0),
                            title: Container(
                              decoration: const BoxDecoration(
                                color: ProjectColors.primary,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: const Text(
                                'Open Shift',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: const OpenShiftDialog(),
                            ),
                            scrollable: false,
                          );
                        },
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
          KeyboardWidget(
            controller: currentFocusedField == 'username' ? usernameController : passwordController,
            isNumericMode: false,
          ),
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
