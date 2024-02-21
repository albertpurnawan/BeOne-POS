import 'package:cron/cron.dart';
import 'package:pos_fe/api/users/users_api.dart';

void syncWithBOS() {
  final cron = Cron();

  cron.schedule(Schedule.parse('37 10 * * *'), () async {
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
