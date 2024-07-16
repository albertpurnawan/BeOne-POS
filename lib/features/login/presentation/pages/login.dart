import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';
import 'package:pos_fe/features/login/domain/usecase/login.dart';
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 5),
            ),
            const BeOneLogo(size: 90),
            const SizedBox(height: 30),
            const LoginForm(),
            const SizedBox(
              height: 130,
            )
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

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  // Future<void> refreshToken() async {
  //   final username = usernameController.text;
  //   final password = passwordController.text;
  //   SharedPreferences prefs = GetIt.instance<SharedPreferences>();
  //   SharedPreferences.getInstance();

  //   final url = await GetIt.instance<AppDatabase>().posParameterDao.readAll();

  //   final user = await GetIt.instance<AppDatabase>()
  //       .userDao
  //       .readByUsername(username, null);

  //   final token = await GetIt.instance<TokenApi>()
  //       .getToken(url[0].baseUrl!, user!.email, password);
  //   log("$token");
  //   prefs.setString('adminToken', token.toString());
  // }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final SharedPreferences prefs = GetIt.instance<SharedPreferences>();

    final bool isOpen = prefs.getBool('isOpen') ?? false;

    return Center(
      child: Form(
        key: formKey,
        child: Column(children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: usernameController,
              validator: (val) => val == null || val.isEmpty ? "Username is required" : null,
              label: "Username / Email",
              hint: "Username / Email",
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomInput(
              controller: passwordController,
              label: "Password",
              hint: "Password",
              prefixIcon: const Icon(Icons.lock),
              validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
              type: CustomInputType.password,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CustomButton(
              child: const Text("Login"),
              onTap: () async {
                if (!formKey.currentState!.validate()) return;
                // await refreshToken();
                final loginSuccess = await GetIt.instance<LoginUseCase>().call(
                    params: UserAuthEntity(
                        docId: null,
                        email: usernameController.text,
                        username: usernameController.text,
                        password: passwordController.text,
                        tohemId: null,
                        torolId: null));

                // log("$loginSuccess loginsuccess");
                // log("$isOpen isOpen");
                if (loginSuccess != null && loginSuccess) {
                  if (isOpen) {
                    if (context.mounted) context.goNamed(RouteConstants.home);
                  } else {
                    final CashierBalanceTransactionModel? openedShift = await showDialog(
                      // return id/tcsr1
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
                  // Show error message if login is not successful or null
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid username or password.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 15),
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
