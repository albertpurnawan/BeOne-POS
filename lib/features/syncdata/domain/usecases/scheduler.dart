import 'package:cron/cron.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:sqflite/sqflite.dart';

void syncWithBOS() {
  final cron = Cron();
  String cronSyntax =
      '${Constant.second} ${Constant.minute} ${Constant.hour} ${Constant.day} ${Constant.month} ${Constant.weekday}';

  cron.schedule(Schedule.parse(cronSyntax), () async {
    Database? database;
    try {
      // USERS
      final usersApi = UsersApi(database!);
      await usersApi.fetchData();
    } catch (err) {
      print('Error $err');
      rethrow;
    }
  });
}
