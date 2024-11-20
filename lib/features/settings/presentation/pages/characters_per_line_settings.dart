import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharactersPerLineSettings extends StatefulWidget {
  const CharactersPerLineSettings({super.key});

  @override
  State<CharactersPerLineSettings> createState() =>
      _CharachtersPerLineSettingsState();
}

class _CharachtersPerLineSettingsState
    extends State<CharactersPerLineSettings> {
  int? radioValue;

  @override
  void initState() {
    super.initState();
    final int? charactersPerLine =
        GetIt.instance<SharedPreferences>().getInt("charactersPerLine");
    radioValue = charactersPerLine == null || charactersPerLine == 42 ? 42 : 48;
  }

  void _setCharactersPerLine() {
    final SharedPreferences pref = GetIt.instance<SharedPreferences>();

    if (radioValue == null) {
      return;
    } else {
      pref.setInt("charactersPerLine", radioValue == 42 ? 42 : 48);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: const Text('Characters Per Line'),
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
              RadioListTile<int>(
                  activeColor: ProjectColors.primary,
                  hoverColor: ProjectColors.primary,
                  // selected: index == radioValue,
                  selectedTileColor: ProjectColors.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: 42,
                  groupValue: radioValue,
                  title: const Text("42"),
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
              RadioListTile<int>(
                  activeColor: ProjectColors.primary,
                  hoverColor: ProjectColors.primary,
                  // selected: index == radioValue,
                  selectedTileColor: ProjectColors.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: 48,
                  groupValue: radioValue,
                  title: const Text("48"),
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
                          _setCharactersPerLine();
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
