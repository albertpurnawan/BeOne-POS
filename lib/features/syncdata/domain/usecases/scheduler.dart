import 'dart:developer';

import 'package:cron/cron.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/syncdata/domain/usecases/sync_data.dart';

Future<void> syncWithBOS() async {
  final cron = Cron();
  String cronSyntax =
      "${Constant.second} ${Constant.minute} ${Constant.hour} ${Constant.day} ${Constant.month} ${Constant.weekday}";

  try {
    cron.schedule(Schedule.parse(cronSyntax), () async {
      await syncData();
      log("Sync Via CRON Success");
    });
  } catch (err) {
    handleError(err);
    rethrow;
  }
}
