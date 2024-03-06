import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/widgets/beone_logo.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:pos_fe/core/widgets/custom_input.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/sales.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.swatch,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollWidget(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height / 2) - 150,
              ),
              const BeOneLogo(size: 130),
              const SizedBox(height: 30),
              const LoginForm()
            ],
          )),
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

    return Center(
      child: Form(
        key: formKey,
        child: Column(children: [
          Container(
            constraints: BoxConstraints(maxWidth: 400),
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
            constraints: BoxConstraints(maxWidth: 400),
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
            constraints: BoxConstraints(maxWidth: 400),
            child: CustomButton(
                child: const Text("Login"),
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;
                  // context.pushNamed(RouteConstants.sales);
                  Helpers.navigate(context, SalesPage());
                  // final login = await Api.of(context).auth.login(
                  //     usernameController.value.text, passwordController.value.text);

                  // if (login) api.refresh();
                }),
          ),
          const SizedBox(height: 15),
          // Text.rich(TextSpan(children: [
          //   const TextSpan(text: "Have no account?"),
          //   TextSpan(
          //       text: " Register",
          //       recognizer: TapGestureRecognizer()
          //         ..onTap =
          //             () => Helpers.navigate(context, const RegisterScreen()),
          //       style: const TextStyle(
          //           color: ProjectColors.swatch, fontWeight: FontWeight.bold)),
          // ]))
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
