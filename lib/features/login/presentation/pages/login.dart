import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/login/domain/entities/user_auth_entity.dart';
import 'package:pos_fe/features/login/domain/usecase/login.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/open_shift.dart';
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
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: (MediaQuery.of(context).size.height / 5),
            ),
            const BeOneLogo(size: 130),
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
              validator: (val) =>
                  val == null || val.isEmpty ? "Username is required" : null,
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
              validator: (val) =>
                  val == null || val.isEmpty ? "Password is required" : null,
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
                final loginSuccess = await GetIt.instance<LoginUseCase>().call(
                    params: UserAuthEntity(
                        docId: null,
                        email: usernameController.text,
                        username: usernameController.text,
                        password: passwordController.text,
                        tohemId: null,
                        torolId: null));
                if (loginSuccess!) {
                  if (isOpen) {
                    if (!context.mounted) return;
                    if (context.mounted) context.pushNamed(RouteConstants.home);
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       shape: const RoundedRectangleBorder(
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(10.0)),
                    //       ),
                    //       content: const Text(
                    //         "Please end current shift first",
                    //         style:
                    //             TextStyle(color: Color.fromRGBO(128, 0, 0, 1)),
                    //       ),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //           child: const Text('OK'),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  } else {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          // backgroundColor: ProjectColors.primary,
                          contentPadding: EdgeInsets.all(0),
                          titlePadding: EdgeInsets.all(0),
                          title: Container(
                            decoration: const BoxDecoration(
                              color: ProjectColors.primary,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5.0)),
                            ),
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                            child: const Text(
                              'Shift Opening',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: const OpenShiftDialog(),
                          ),
                        );
                      },
                    );
                  }
                  // if (isLoggedIn) {
                  //   Helpers.navigate(context, SalesPage());
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('Login failed. Please try again.'),
                  //       backgroundColor: Colors.red,
                  //     ),
                  //   );
                  // }
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid username or password.'),
                      backgroundColor: Colors.red,
                    ),
                  );
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
