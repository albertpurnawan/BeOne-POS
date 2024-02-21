import 'package:cron/cron.dart';
import 'package:pos_fe/api/users/users_api.dart';
import 'package:pos_fe/core/constants/constants.dart';

void syncWithBOS() {
  final cron = Cron();
  String cronSyntax =
      '${Constant.second} ${Constant.minute} ${Constant.hour} ${Constant.day} ${Constant.month} ${Constant.weekday}';

  cron.schedule(Schedule.parse(cronSyntax), () async {
    try {
      // USERS
      final usersApi = UsersApi();
      await usersApi.fetchUsersData();
    } catch (err) {
      print('Error $err');
      rethrow;
    }
  });
}
