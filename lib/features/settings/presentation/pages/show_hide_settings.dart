import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowHideTaxSettings extends StatefulWidget {
  const ShowHideTaxSettings({super.key});

  @override
  State<ShowHideTaxSettings> createState() => _ShowHideTaxSettingsState();
}

class _ShowHideTaxSettingsState extends State<ShowHideTaxSettings> {
  String? radioValue;

  @override
  void initState() {
    super.initState();
    final String? prefShowHideTax =
        GetIt.instance<SharedPreferences>().getString("showHideTax");
    if (prefShowHideTax != null) {
      radioValue = prefShowHideTax == "Show Tax" ? "Show Tax" : "Hide Tax";
    }
  }

  void _setShowHideTax() {
    final SharedPreferences pref = GetIt.instance<SharedPreferences>();

    if (radioValue == null) {
      return;
    } else {
      pref.setString(
          "showHideTax", radioValue == "Show Tax" ? "Show Tax" : "Hide Tax");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: const Text('Show Hide Tax'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 300,
            maxWidth: 600,
          ),
          child: Column(
            children: [
              const Divider(
                height: 0,
              ),
              RadioListTile<String>(
                  activeColor: ProjectColors.primary,
                  hoverColor: ProjectColors.primary,
                  // selected: index == radioValue,
                  selectedTileColor: ProjectColors.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: "Show Tax",
                  groupValue: radioValue,
                  title: const Text("Show Tax"),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius:
                  //         BorderRadius.circular(5)),
                  onChanged: (val) {
                    setState(() {
                      radioValue = val;
                    });
                  }),
              const Divider(
                height: 0,
              ),
              RadioListTile<String>(
                  activeColor: ProjectColors.primary,
                  hoverColor: ProjectColors.primary,
                  // selected: index == radioValue,
                  selectedTileColor: ProjectColors.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: "Hide Tax",
                  groupValue: radioValue,
                  title: const Text("Hide Tax"),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius:
                  //         BorderRadius.circular(5)),
                  onChanged: (val) {
                    setState(() {
                      radioValue = val;
                    });
                  }),
              const Divider(
                height: 0,
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 10)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      backgroundColor: radioValue == null
                          ? MaterialStateColor.resolveWith((states) =>
                              const Color.fromARGB(255, 200, 200, 200))
                          : MaterialStateColor.resolveWith(
                              (states) => ProjectColors.primary),
                      foregroundColor: radioValue == null
                          ? MaterialStateColor.resolveWith((states) =>
                              const Color.fromARGB(255, 111, 111, 111))
                          : MaterialStateColor.resolveWith((states) =>
                              const Color.fromARGB(255, 255, 255, 255)),
                      overlayColor:
                          MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                  onPressed: radioValue == null
                      ? null
                      : () {
                          _setShowHideTax();
                          Navigator.pop(context);
                        },
                  child: const Text("Set", textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
