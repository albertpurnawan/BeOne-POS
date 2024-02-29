import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/models/user_master_model.dart';

class UsersDao {
  final AppDatabase db;

  UsersDao(this.db);

  Future<List<UsersModel>> upsertDataFromAPI() async {
    try {
      final List<dynamic> usersData =
          await GetIt.instance<UsersApi>().fetchData();

      for (final UsersModel user in usersData) {
        final Map<String, dynamic> userMap = user.toJson();

        final List<String> excludedFields = [
          'createby',
          'updateby',
          'gtent_id',
          'torol_id',
          'tohem_id'
        ];

        for (var field in excludedFields) {
          if (userMap.containsKey(field)) {
            userMap.remove(field);
          }
        }

        List<dynamic> obj = [
          userMap['docid'],
          userMap['createdate'],
          userMap['updatedate'],
          userMap['gtentId'],
          userMap['email'],
          userMap['username'],
          userMap['password'],
          userMap['tohemId'],
          userMap['torolId'],
          userMap['statusactive'],
          userMap['activated'],
          userMap['superuser'],
          userMap['provider'],
          userMap['usertype'],
          userMap['trolleyuser'],
        ];

        await GetIt.instance<AppDatabase>().upsertUsers(obj);
      }
      return usersData.cast<UsersModel>();
    } catch (err) {
      print('Error $err');
      rethrow;
    }
  }
}
