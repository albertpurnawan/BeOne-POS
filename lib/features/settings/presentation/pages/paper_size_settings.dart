import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/esc_pos_utils_platform/src/enums.dart';

class PaperSizeSettings extends StatefulWidget {
  const PaperSizeSettings({super.key});

  @override
  State<PaperSizeSettings> createState() => _PaperSizeSettingsState();
}

class _PaperSizeSettingsState extends State<PaperSizeSettings> {
  PaperSize? radioValue;

  @override
  void initState() {
    super.initState();
    final String? prefPaperSize =
        GetIt.instance<SharedPreferences>().getString("paperSize");
    radioValue = prefPaperSize == null || prefPaperSize == "80 mm"
        ? PaperSize.mm80
        : PaperSize.mm58;
  }

  void _setPaperSize() {
    final SharedPreferences pref = GetIt.instance<SharedPreferences>();

    if (radioValue == null) {
      return;
    } else {
      pref.setString(
          "paperSize", radioValue == PaperSize.mm80 ? "80 mm" : "58 mm");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: const Text('Paper Size'),
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
              // const Divider(
              //   height: 0,
              // ),
              // RadioListTile<PaperSize>(
              //     activeColor: ProjectColors.primary,
              //     hoverColor: ProjectColors.primary,
              //     // selected: index == radioValue,
              //     selectedTileColor: ProjectColors.primary,
              //     contentPadding: const EdgeInsets.symmetric(
              //       horizontal: 15,
              //     ),
              //     controlAffinity: ListTileControlAffinity.trailing,
              //     value: PaperSize.mm58,
              //     groupValue: radioValue,
              //     title: const Text("58 mm"),
              //     // shape: RoundedRectangleBorder(
              //     //     borderRadius:
              //     //         BorderRadius.circular(5)),
              //     onChanged: (val) {
              //       setState(() {
              //         radioValue = val;
              //       });
              //     }),
              const Divider(
                height: 0,
              ),
              RadioListTile<PaperSize>(
                  activeColor: ProjectColors.primary,
                  hoverColor: ProjectColors.primary,
                  // selected: index == radioValue,
                  selectedTileColor: ProjectColors.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: PaperSize.mm80,
                  groupValue: radioValue,
                  title: const Text("80 mm"),
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
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 10)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      backgroundColor: radioValue == null
                          ? WidgetStateColor.resolveWith((states) =>
                              const Color.fromARGB(255, 200, 200, 200))
                          : WidgetStateColor.resolveWith(
                              (states) => ProjectColors.primary),
                      foregroundColor: radioValue == null
                          ? WidgetStateColor.resolveWith((states) =>
                              const Color.fromARGB(255, 111, 111, 111))
                          : WidgetStateColor.resolveWith((states) =>
                              const Color.fromARGB(255, 255, 255, 255)),
                      overlayColor: WidgetStateColor.resolveWith(
                          (states) => Colors.white.withOpacity(.2))),
                  onPressed: radioValue == null
                      ? null
                      : () {
                          _setPaperSize();
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
