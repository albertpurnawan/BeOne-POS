import 'package:path/path.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/barcode_item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/closing_store_transactions_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_group_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_adjustment_transactions_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/opening_store_transactions_services.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_period_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  late final databaseVersion = 1;
  final _databaseName = "pos_fe.db";

  Database? _database;

  late ItemsApi itemsApi;
  late ItemsDao itemsDao;
  late UsersApi usersApi;
  late UsersDao usersDao;
  late UoMApi uomApi;
  late ItemCategoryApi itemCategoryApi;
  late PricelistApi pricelistApi;
  late PricelistPeriodApi pricelistPeriodApi;
  late StoreApi storeApi;
  late MOPApi mopApi;
  late CashRegisterApi cashRegisterApi;
  late TaxApi taxApi;
  late CustomerGroupApi customerGroupApi;
  late CustomerApi customerApi;
  late BarcodeItemApi barcodeItemApi;
  late PriceByItemApi priceByItemApi;
  late PriceByItemBarcodeApi priceByItemBarcodeApi;
  late MOPAdjustmentApi mopAdjustmentApi;
  late OpeningStoreApi openingStoreApi;
  late ClosingStoreApi closingStoreApi;
  late final CurrencyDao currencyDao;
  late CurrencyApi currencyApi;

  AppDatabase() {
    getDB().then((value) {
      itemsApi = ItemsApi(_database!);
      itemsDao = ItemsDao(_database!);
      usersApi = UsersApi(_database!);
      usersDao = UsersDao(_database!);
      uomApi = UoMApi(_database!);
      itemCategoryApi = ItemCategoryApi(_database!);
      pricelistApi = PricelistApi(_database!);
      pricelistPeriodApi = PricelistPeriodApi(_database!);
      storeApi = StoreApi(_database!);
      mopApi = MOPApi(_database!);
      cashRegisterApi = CashRegisterApi(_database!);
      taxApi = TaxApi(_database!);
      customerGroupApi = CustomerGroupApi(_database!);
      customerApi = CustomerApi(_database!);
      barcodeItemApi = BarcodeItemApi(_database!);
      priceByItemApi = PriceByItemApi(_database!);
      priceByItemBarcodeApi = PriceByItemBarcodeApi(_database!);
      mopAdjustmentApi = MOPAdjustmentApi(_database!);
      openingStoreApi = OpeningStoreApi(_database!);
      closingStoreApi = ClosingStoreApi(_database!);
      currencyDao = CurrencyDao(_database!);
      currencyApi = CurrencyApi(_database!);
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
