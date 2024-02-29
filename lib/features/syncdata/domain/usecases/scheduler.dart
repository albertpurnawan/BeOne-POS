import 'package:cron/cron.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';

void syncWithBOS() {
  final cron = Cron();
  String cronSyntax =
      '${Constant.second} ${Constant.minute} ${Constant.hour} ${Constant.day} ${Constant.month} ${Constant.weekday}';

  cron.schedule(Schedule.parse(cronSyntax), () async {
    try {
      // USERS
      await GetIt.instance<UsersDao>().upsertDataFromAPI();
    } catch (err) {
      print('Error $err');
      rethrow;
    }
  });
}
