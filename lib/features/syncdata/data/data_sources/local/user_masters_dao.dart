import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/models/user_master_model.dart';
import 'package:sqflite/sqflite.dart';

class UsersDao {
  final Database db;

  UsersDao(this.db);

  Future<List<dynamic>> insertUsersFromApi() async {
    try {
      final List<dynamic> usersData = await UsersApi(db).fetchUsersData();
      for (final userData in usersData) {
        final Users user = Users.fromJson(userData);
        print(user);
        final List<String> excludedFields = [
          'createby',
          'updateby',
          'gtent_id',
          'torol_id',
          'tohem_id'
        ];

        final Map<String, dynamic> userMap = user.toJson();

        for (var field in excludedFields) {
          if (userMap.containsKey(field)) {
            userMap.remove(field);
          }
        }

        await db.transaction((txn) async {
          await txn.rawInsert(
            '''
        INSERT OR REPLACE INTO users (
          docid, createdate, updatedate, gtentId, email, username, password,
          tohemId, torolId, statusactive, activated, superuser, provider,
          usertype, trolleyuser
        ) VALUES (
          ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        )
        ON CONFLICT(docid) DO UPDATE SET
        createdate = excluded.createdate,
        updatedate = excluded.updatedate,
        gtentId = excluded.gtentId,
        email = excluded.email,
        username = excluded.username,
        password = excluded.password,
        tohemId = excluded.tohemId,
        torolId = excluded.torolId,
        statusactive = excluded.statusactive,
        activated = excluded.activated,
        superuser = excluded.superuser,
        provider = excluded.provider,
        usertype = excluded.usertype,
        trolleyuser = excluded.trolleyuser
        ''',
            [
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
            ],
          );
        });
      }
      return usersData;
    } catch (err) {
      print('Error $err');
      rethrow;
    }
  }
}
