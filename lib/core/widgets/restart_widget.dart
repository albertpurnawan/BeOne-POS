import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    final state = context.findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() async {
    setState(() {});

    // Reinitialize services (if necessary)
    GetIt.instance.unregister<AppDatabase>();
    GetIt.instance.registerSingletonAsync<AppDatabase>(
      () async {
        final db = await AppDatabase.init();
        return db;
      },
    );
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
