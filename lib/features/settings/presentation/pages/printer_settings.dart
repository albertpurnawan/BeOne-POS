import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/settings/presentation/pages/default_printer_settings.dart';
import 'package:pos_fe/features/settings/presentation/pages/paper_size_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSettings extends StatefulWidget {
  const PrinterSettings({super.key});

  @override
  State<PrinterSettings> createState() => _PrinterSettingsState();
}

class _PrinterSettingsState extends State<PrinterSettings> {
  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Color.fromARGB(255, 169, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 300,
            maxWidth: 600,
          ),
          child: Column(
            children: [
              Divider(
                height: 0,
              ),
              InkWell(
                onTap: () =>
                    Helpers.navigate(context, const DefaultPrinterSettings())
                        .then((value) => setState(() {})),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.print_rounded),
                            SizedBox(
                              width: 30,
                            ),
                            Text("Default Printer"),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              GetIt.instance<SharedPreferences>()
                                      .getStringList("defaultPrinter")?[0] ??
                                  "Not Set",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(Icons.navigate_next),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
              ),
              InkWell(
                onTap: () =>
                    Helpers.navigate(context, const PaperSizeSettings())
                        .then((value) => setState(() {})),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.receipt),
                            SizedBox(
                              width: 30,
                            ),
                            Text("Paper Size"),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              GetIt.instance<SharedPreferences>()
                                      .getString("paperSize") ??
                                  "Not Set",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(Icons.navigate_next),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
