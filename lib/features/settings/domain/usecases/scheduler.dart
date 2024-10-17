import 'dart:developer';

import 'package:cron/cron.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/auto_backup_usecase.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/settings/domain/usecases/sync_data.dart';

final cron = Cron();

Future<void> configureBackgroundTasks() async {
  final syncSchedule = "${Constant.minute} ${Constant.hour} ${Constant.day} ${Constant.month} ${Constant.weekday}";
  cron.schedule(Schedule.parse(syncSchedule), () async {
    try {
      await syncData();
      log("Sync Via CRON Finished");
    } catch (e) {
      handleError(e);
    }
  });

  final autoBackupSchedule = "03 */1 ${Constant.day} ${Constant.month} ${Constant.weekday}";
  cron.schedule(Schedule.parse(autoBackupSchedule), () async {
    try {
      await AutoBackupUseCase().call();
    } catch (e) {
      handleError(e);
    }
  });
}
