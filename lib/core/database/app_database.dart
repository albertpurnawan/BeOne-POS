import 'package:path/path.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  late final databaseVersion = 1;
  final _databaseName = "pos_fe.db";

  late ItemsApi itemsApi;
  late ItemsDao itemsDao;
  late UsersApi usersApi;
  late UsersDao usersDao;
  Database? _database;

  AppDatabase() {
    getDB().then((value) {
      itemsApi = ItemsApi(_database!);
      itemsDao = ItemsDao(_database!);
      usersApi = UsersApi(_database!);
      usersDao = UsersDao(_database!);
    });
  }

  Future<Database> getDB() async {
    if (_database != null) return _database!;

    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    try {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

      await db.execute('''
PRAGMA foreign_keys = ON;
''');

      await db.execute('''
CREATE TABLE $tableItems (
${ItemFields.id} $idType,
${ItemFields.code} TEXT NOT NULL,
${ItemFields.name} TEXT NOT NULL,
${ItemFields.price} INTEGER NOT NULL
)
''');

      await db.execute('''
INSERT INTO $tableItems (code, name, price)
VALUES
  ("001", "T-Shirt Navy", 120000),
  ("002", "Cargo Pants Brown", 390000),
  ("003", "Vintage Sunglasses", 860000),
  ("004", "Metal Bracelet", 60000),
  ("005", "Zodiac Necklace", 250000),
  ("006", "White Baseball Cap", 210000),
  ("007", "Denim Shorts", 299000),
  ("008", "Red Shirt", 330000),
  ("009", "Leather Waller", 550000),
  ("010", "Running Shoes", 1140000),
  ("011", "White Socks", 60000),
  ("012", "Balaclava", 80000),
  ("013", "Laptop Backpack", 599000),
  ("014", "Shoulder Bag", 410000),
  ("015", "Winter Gloves", 180000)
''');

      await db.execute("""
CREATE TABLE receipts (
  id INTEGER PRIMARY KEY,
  totalprice INTEGER NOT NULL,
  createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)""");

      await db.execute("""
CREATE TABLE receiptitems (
  id INTEGER PRIMARY KEY,
  moitm_id INTEGER NOT NULL,
  receipt_id INTEGER NOT NULL,
  quantity REAL NOT NULL,
  itemname TEXT NOT NULL,
  itemcode TEXT NOT NULL,
  itemprice REAL NOT NULL,
  subtotal REAL NOT NULL,
  createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (moitm_id) REFERENCES moitm (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (receipt_id) REFERENCES receipt (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)""");

      await db.execute("""
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  docid STRING NOT NULL UNIQUE, 
  createdate TEXT,
  updatedate TEXT,
  gtentId INTEGER,
  email STRING,
  username STRING,
  password STRING,
  tohemId INTEGER,
  torolId INTEGER,
  statusactive INTEGER,
  activated INTEGER,
  superuser INTEGER,
  provider INTEGER,
  usertype INTEGER,
  trolleyuser STRING
)
""");
/*
FOREIGN KEY (gtentId) REFERENCES tennats (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (tohemId) REFERENCES employees (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (torolId) REFERENCES userroles (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (tostrId) REFERENCES stores (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
*/
    } catch (e) {
      print(e);
    }
  }

  //INSERT USERS
  // Future<void> insertUsers(Users users) async {
  //   try {
  //     _database ??= await _initDB(_databaseName);

  //     final List<String> excludedFields = [
  //       'createby',
  //       'updateby',
  //       'gtent_id',
  //       'torol_id',
  //       'tohem_id'
  //     ];

  //     final Map<String, dynamic> userMap = users.toJson();

  //     for (var field in excludedFields) {
  //       if (userMap.containsKey(field)) {
  //         userMap.remove(field);
  //       }
  //     }

  //     await _database?.transaction((txn) async {
  //       await txn.rawInsert(
  //         '''
  //       INSERT OR REPLACE INTO users (
  //         docid, createdate, updatedate, gtentId, email, username, password,
  //         tohemId, torolId, statusactive, activated, superuser, provider,
  //         usertype, trolleyuser
  //       ) VALUES (
  //         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
  //       )
  //       ON CONFLICT(docid) DO UPDATE SET
  //       createdate = excluded.createdate,
  //       updatedate = excluded.updatedate,
  //       gtentId = excluded.gtentId,
  //       email = excluded.email,
  //       username = excluded.username,
  //       password = excluded.password,
  //       tohemId = excluded.tohemId,
  //       torolId = excluded.torolId,
  //       statusactive = excluded.statusactive,
  //       activated = excluded.activated,
  //       superuser = excluded.superuser,
  //       provider = excluded.provider,
  //       usertype = excluded.usertype,
  //       trolleyuser = excluded.trolleyuser
  //       ''',
  //         [
  //           userMap['docid'],
  //           userMap['createdate'],
  //           userMap['updatedate'],
  //           userMap['gtentId'],
  //           userMap['email'],
  //           userMap['username'],
  //           userMap['password'],
  //           userMap['tohemId'],
  //           userMap['torolId'],
  //           userMap['statusactive'],
  //           userMap['activated'],
  //           userMap['superuser'],
  //           userMap['provider'],
  //           userMap['usertype'],
  //           userMap['trolleyuser'],
  //         ],
  //       );
  //     });
  //   } catch (err) {
  //     print('Error inserting user: $err');
  //     rethrow;
  //   }
  // }

  // Future close() async {
  //   final db = await instance.database;

  //   await db.close();
  // }
}

// final List<String> excludedFields = [
//         'createby',
//         'updateby',
//         'gtent_id',
//         'torol_id',
//         'tohem_id'
//       ];

//       final Map<String, dynamic> userMap = users.toJson();

//       for (var field in excludedFields) {
//         if (userMap.containsKey(field)) {
//           userMap.remove(field);
//         }
//       }

//       await db.transaction((txn) async {
//         await txn.rawInsert(
//           '''
//         INSERT OR REPLACE INTO users (
//           docid, createdate, updatedate, gtentId, email, username, password,
//           tohemId, torolId, statusactive, activated, superuser, provider,
//           usertype, trolleyuser
//         ) VALUES (
//           ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
//         )
//         ON CONFLICT(docid) DO UPDATE SET
//         createdate = excluded.createdate,
//         updatedate = excluded.updatedate,
//         gtentId = excluded.gtentId,
//         email = excluded.email,
//         username = excluded.username,
//         password = excluded.password,
//         tohemId = excluded.tohemId,
//         torolId = excluded.torolId,
//         statusactive = excluded.statusactive,
//         activated = excluded.activated,
//         superuser = excluded.superuser,
//         provider = excluded.provider,
//         usertype = excluded.usertype,
//         trolleyuser = excluded.trolleyuser
//         ''',
//           [
//             userMap['docid'],
//             userMap['createdate'],
//             userMap['updatedate'],
//             userMap['gtentId'],
//             userMap['email'],
//             userMap['username'],
//             userMap['password'],
//             userMap['tohemId'],
//             userMap['torolId'],
//             userMap['statusactive'],
//             userMap['activated'],
//             userMap['superuser'],
//             userMap['provider'],
//             userMap['usertype'],
//             userMap['trolleyuser'],
//           ],
//         );
//       });