import 'package:path/path.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/barcode_item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/closing_store_transactions_service.dart';
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

  Database? _database;

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

  // Future close() async {
  //   final db = await instance.database;

  //   await db.close();
  // }
}
