import 'package:path/path.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  final databaseVersion = 1;
  final _databaseName = "pos_fe.db";
  Database? _database;

  late final ItemsDao itemsDao;
  late final CurrencyDao currencyDao;

  AppDatabase() {
    getDB().then((value) {
      itemsDao = ItemsDao(_database!);
      currencyDao = CurrencyDao(_database!);
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

    return await openDatabase(path,
        version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('''
PRAGMA foreign_keys = ON;
''');
  }

  Future _createDB(Database db, int version) async {
    try {
      const idTypeAndConstraints = 'INTEGER PRIMARY KEY AUTOINCREMENT';

      await db.transaction((txn) async {
        await txn.execute('''
CREATE TABLE $tableItems (
${ItemFields.id} $idTypeAndConstraints,
${ItemFields.code} TEXT NOT NULL,
${ItemFields.name} TEXT NOT NULL,
${ItemFields.price} INTEGER NOT NULL
)
''');

        await txn.execute('''
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
  ("009", "Leather Wallet", 550000),
  ("010", "Running Shoes", 1140000),
  ("011", "White Socks", 60000),
  ("012", "Balaclava", 80000),
  ("013", "Laptop Backpack", 599000),
  ("014", "Shoulder Bag", 410000),
  ("015", "Winter Gloves", 180000)
''');

        await txn.execute("""
CREATE TABLE receipts (
  id INTEGER PRIMARY KEY,
  totalprice INTEGER NOT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP
)""");

        await txn.execute("""
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

        await txn.execute("""
CREATE TABLE `tcurr` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `curcode` varchar(30) NOT NULL,
  `description` varchar(100) NOT NULL,
  `descriptionfrgn` varchar(100) NOT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `tcurr_docid_key` UNIQUE (`docid`)
)
""");

        await txn.execute("""
INSERT INTO `tcurr` (docid,createdate,updatedate,curcode,description,descriptionfrgn) VALUES
	 ('cff4edc0-7612-4681-8d7c-c90e9e97c6dc','2023-08-28 04:08:00','2023-08-28 04:08:00','IDR','Rupiah','Rupiah');
""");

        await txn.execute("""
CREATE TABLE `tphir` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `description` varchar(100) NOT NULL,
  `level` int NOT NULL,
  `maxchar` int NOT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `tphir_docid_key` UNIQUE (`docid`)
)
""");

        await txn.execute("""
CREATE TABLE `phir1` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `code` varchar(30) NOT NULL,
  `description` varchar(100) NOT NULL,
  `tphirId` bigint DEFAULT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `phir1_docid_key` UNIQUE (`docid`),
  CONSTRAINT `phir1_tphirId_fkey` FOREIGN KEY (`tphirId`) REFERENCES `tphir` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE `tocat` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `catcode` varchar(30) NOT NULL,
  `catname` varchar(100) NOT NULL,
  `catnamefrgn` varchar(100) NOT NULL,
  `parentId` bigint DEFAULT NULL,
  `level` int NOT NULL,
  `phir1Id` bigint DEFAULT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `tocat_docid_key` UNIQUE (`docid`),
  CONSTRAINT `tocat_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `tocat` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocat_phir1Id_fkey` FOREIGN KEY (`phir1Id`) REFERENCES `phir1` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE `touom` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `uomcode` varchar(30) NOT NULL,
  `uomdesc` varchar(100) NOT NULL,
  `statusactive` int NOT NULL,
  `activated` int NOT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `touom_docid_key` UNIQUE (`docid`)
) 
""");

        await txn.execute("""
CREATE TABLE `toitm` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `itemcode` varchar(30) NOT NULL,
  `itemname` varchar(100) NOT NULL,
  `invitem` int NOT NULL,
  `serialno` int NOT NULL,
  `tocatId` bigint DEFAULT NULL,
  `touomId` bigint DEFAULT NULL,
  `minstock` double NOT NULL,
  `maxstock` double NOT NULL,
  `includetax` int NOT NULL,
  `remarks` text,
  `statusactive` int NOT NULL,
  `activated` int NOT NULL,
  `isbatch` int NOT NULL DEFAULT '0',
  `internalcode_1` varchar(100) DEFAULT '',
  `internalcode_2` varchar(100) DEFAULT '',
  `openprice` int NOT NULL DEFAULT '0',
  `popitem` int NOT NULL DEFAULT '0',
  `bpom` varchar(20) DEFAULT '',
  `expdate` varchar(6) DEFAULT '',
  `margin` double DEFAULT '0',
  `memberdiscount` int DEFAULT '1',
  `multiplyorder` int DEFAULT '1',
  `synccrm` int NOT NULL DEFAULT '0',
  `mergequantity` int NOT NULL DEFAULT '0',
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `toitm_docid_key` UNIQUE (`docid`),
  CONSTRAINT `toitm_tocatId_fkey` FOREIGN KEY (`tocatId`) REFERENCES `tocat` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE `topln` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `pricecode` varchar(30) NOT NULL,
  `description` varchar(100) NOT NULL,
  `baseprice` bigint NOT NULL,
  `periodprice` bigint NOT NULL,
  `factor` double NOT NULL,
  `tcurrId` bigint DEFAULT NULL,
  `type` int NOT NULL,
  `statusactive` int NOT NULL,
  `activated` int NOT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `topln_docid_key` UNIQUE (`docid`),
  CONSTRAINT `topln_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE `tpln1` (
  `_id` $idTypeAndConstraints,
  `docid` varchar(191) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime DEFAULT NULL,
  `toplnId` bigint DEFAULT NULL,
  `periodfr` date NOT NULL,
  `periodto` date NOT NULL,
  `baseprice` bigint NOT NULL,
  `periodprice` bigint NOT NULL,
  `factor` double NOT NULL,
  `statusactive` int NOT NULL,
  `activated` int NOT NULL,
  createdat TEXT DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `tpln1_docid_key` UNIQUE (`docid`),
  CONSTRAINT `tpln1_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
      });
    } catch (e) {
      print(e);
    }
  }

  // Future close() async {
  //   final db = await instance.database;

  //   await db.close();
  // }
}
