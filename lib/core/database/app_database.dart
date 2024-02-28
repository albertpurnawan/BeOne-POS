import 'package:path/path.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/item_by_store.dart';
import 'package:pos_fe/features/sales/data/models/item_category.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/pricelist.dart';
import 'package:pos_fe/features/sales/data/models/pricelist_period.dart';
import 'package:pos_fe/features/sales/data/models/product_hierarchy.dart';
import 'package:pos_fe/features/sales/data/models/product_hierarchy_master.dart';
import 'package:pos_fe/features/sales/data/models/uom.dart';
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
      const uuidDefinition = '`docid` TEXT PRIMARY KEY';
      const createdAtDefinition = 'createdat TEXT DEFAULT CURRENT_TIMESTAMP';

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
CREATE TABLE $tableCurrencies (
  $uuidDefinition,
  ${CurrencyFields.createDate} datetime NOT NULL,
  ${CurrencyFields.updateDate} datetime DEFAULT NULL,
  ${CurrencyFields.curCode} varchar(30) NOT NULL,
  ${CurrencyFields.description} varchar(100) NOT NULL,
  ${CurrencyFields.descriptionFrgn} varchar(100) NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
INSERT INTO `tcurr` (docid,createdate,updatedate,curcode,description,descriptionfrgn) VALUES
	 ('cff4edc0-7612-4681-8d7c-c90e9e97c6dc','2023-08-28 04:08:00','2023-08-28 04:08:00','IDR','Rupiah','Rupiah');
""");

        await txn.execute("""
CREATE TABLE `$tableProductHierarchies` (
  $uuidDefinition,
  ${ProductHierarchyFields.createDate} datetime NOT NULL,
  ${ProductHierarchyFields.updateDate} datetime DEFAULT NULL,
  ${ProductHierarchyFields.description} varchar(100) NOT NULL,
  ${ProductHierarchyFields.level} int NOT NULL,
  ${ProductHierarchyFields.maxChar} int NOT NULL,
  $createdAtDefinition,
)
""");

        await txn.execute("""
CREATE TABLE `$tableProductHierarchyMasters` (
  $uuidDefinition,
  ${ProductHierarchyMasterFields.createDate} datetime NOT NULL,
  ${ProductHierarchyMasterFields.updateDate} datetime DEFAULT NULL,
  ${ProductHierarchyMasterFields.code} varchar(30) NOT NULL,
  ${ProductHierarchyMasterFields.description} varchar(100) NOT NULL,
  ${ProductHierarchyMasterFields.tphirId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `phir1_tphirId_fkey` FOREIGN KEY (`tphirId`) REFERENCES `tphir` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableItemCategories (
  $uuidDefinition,
  ${ItemCategoryFields.createDate} datetime NOT NULL,
  ${ItemCategoryFields.updateDate} datetime DEFAULT NULL,
  ${ItemCategoryFields.catCode} varchar(30) NOT NULL,
  ${ItemCategoryFields.catName} varchar(100) NOT NULL,
  ${ItemCategoryFields.catNameFrgn} varchar(100) NOT NULL,
  ${ItemCategoryFields.parentId} text DEFAULT NULL,
  ${ItemCategoryFields.level} int NOT NULL,
  ${ItemCategoryFields.level} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tocat_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `tocat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocat_phir1Id_fkey` FOREIGN KEY (`phir1Id`) REFERENCES `phir1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableUom (
  $uuidDefinition,
  ${UomFields.createDate} datetime NOT NULL,
  ${UomFields.updateDate} datetime DEFAULT NULL,
  ${UomFields.uomCode} varchar(30) NOT NULL,
  ${UomFields.uomDesc} varchar(100) NOT NULL,
  ${UomFields.statusActive} int NOT NULL,
  ${UomFields.activated} int NOT NULL,
  $createdAtDefinition
) 
""");

        await txn.execute("""
CREATE TABLE $tableItemMasters (
  $uuidDefinition,
  ${ItemMasterFields.createDate} datetime NOT NULL,
  ${ItemMasterFields.updateDate} datetime DEFAULT NULL,
  ${ItemMasterFields.itemCode} varchar(30) NOT NULL,
  ${ItemMasterFields.itemName} varchar(100) NOT NULL,
  ${ItemMasterFields.invItem} int NOT NULL,
  ${ItemMasterFields.serialNo} int NOT NULL,
  ${ItemMasterFields.tocatId} text DEFAULT NULL,
  ${ItemMasterFields.touomId} text DEFAULT NULL,
  ${ItemMasterFields.minStock} int NOT NULL,
  ${ItemMasterFields.maxStock} int NOT NULL,
  ${ItemMasterFields.includeTax} int NOT NULL,
  ${ItemMasterFields.remarks} text,
  ${ItemMasterFields.statusActive} int NOT NULL,
  ${ItemMasterFields.activated} int NOT NULL,
  ${ItemMasterFields.isBatch} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.internalCode_1} varchar(100) DEFAULT '',
  ${ItemMasterFields.internalCode_2} varchar(100) DEFAULT '',
  ${ItemMasterFields.openPrice} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.popItem} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.bpom} varchar(20) DEFAULT '',
  ${ItemMasterFields.expDate} varchar(6) DEFAULT '',
  ${ItemMasterFields.margin} int DEFAULT '0',
  ${ItemMasterFields.memberDiscount} int DEFAULT '1',
  ${ItemMasterFields.multiplyOrder} int DEFAULT '1',
  ${ItemMasterFields.mergeQuantity} int NOT NULL DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `toitm_tocatId_fkey` FOREIGN KEY (`tocatId`) REFERENCES `tocat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePricelists (
  $uuidDefinition,
  ${PricelistFields.createDate} datetime NOT NULL,
  ${PricelistFields.updateDate} datetime DEFAULT NULL,
  ${PricelistFields.priceCode} varchar(30) NOT NULL,
  ${PricelistFields.description} varchar(100) NOT NULL,
  ${PricelistFields.basePrice} bigint NOT NULL,
  ${PricelistFields.periodPrice} bigint NOT NULL,
  ${PricelistFields.factor} double NOT NULL,
  ${PricelistFields.tcurrId} text DEFAULT NULL,
  ${PricelistFields.type} int NOT NULL,
  ${PricelistFields.statusactive} int NOT NULL,
  ${PricelistFields.activated} int NOT NULL,
  $createdAtDefinition
  CONSTRAINT `topln_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePricelistPeriods (
  $uuidDefinition,
  ${PricelistPeriodFields.createDate} datetime NOT NULL,
  ${PricelistPeriodFields.updateDate} datetime DEFAULT NULL,
  ${PricelistPeriodFields.toplnId} text DEFAULT NULL,
  ${PricelistPeriodFields.periodFr} datetime NOT NULL,
  ${PricelistPeriodFields.periodTo} datetime NOT NULL,
  ${PricelistPeriodFields.basePrice} bigint NOT NULL,
  ${PricelistPeriodFields.periodPrice} bigint NOT NULL,
  ${PricelistPeriodFields.factor} double NOT NULL,
  ${PricelistPeriodFields.statusActive} int NOT NULL,
  ${PricelistPeriodFields.activated} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tpln1_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableItemBarcodes (
  $uuidDefinition,
  ${ItemBarcodesFields.createDate} datetime NOT NULL,
  ${ItemBarcodesFields.updateDate} datetime DEFAULT NULL,
  ${ItemBarcodesFields.toitmId} text DEFAULT NULL,
  ${ItemBarcodesFields.barcode} varchar(50) NOT NULL,
  ${ItemBarcodesFields.statusActive} int NOT NULL,
  ${ItemBarcodesFields.activated} int NOT NULL,
  ${ItemBarcodesFields.quantity} double NOT NULL,
  ${ItemBarcodesFields.touomId} text DEFAULT NULL,
  ${ItemBarcodesFields.dflt} int DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tbitm_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tbitm_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableItemsByStore (
  $uuidDefinition,
  ${ItemsByStoreFields.createDate} datetime NOT NULL,
  ${ItemsByStoreFields.updateDate} datetime DEFAULT NULL,
  ${ItemsByStoreFields.toitmId} text DEFAULT NULL,
  ${ItemsByStoreFields.tostrId} text DEFAULT NULL,
  ${ItemsByStoreFields.statusActive} int NOT NULL,
  ${ItemsByStoreFields.activated} int NOT NULL,
  ${ItemsByStoreFields.tovatId} text DEFAULT NULL,
  ${ItemsByStoreFields.tovatIdPur} text DEFAULT NULL,
  ${ItemsByStoreFields.maxStock} double DEFAULT '0',
  ${ItemsByStoreFields.minStock} double DEFAULT '0',
  ${ItemsByStoreFields.marginPercentage} double DEFAULT '0',
  ${ItemsByStoreFields.marginPrice} double DEFAULT '0',
  ${ItemsByStoreFields.multiplyOrder} int DEFAULT '1',
  ${ItemsByStoreFields.price} double DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tsitm_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tsitm_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tsitm_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tsitm_tovatIdPur_fkey` FOREIGN KEY (`tovatIdPur`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePricesByItem (
  $uuidDefinition,
  ${PriceByItemFields.createDate} datetime NOT NULL,
  ${PriceByItemFields.updateDate} datetime DEFAULT NULL,
  ${PriceByItemFields.tpln1Id} text DEFAULT NULL,
  ${PriceByItemFields.toitmId} text DEFAULT NULL,
  ${PriceByItemFields.tcurrId} text DEFAULT NULL,
  ${PriceByItemFields.price} double NOT NULL,
  ${PriceByItemFields.purchasePrice} double DEFAULT '0',
  ${PriceByItemFields.calculatedPrice} double DEFAULT '0',
  ${PriceByItemFields.marginPercentage} double DEFAULT '0',
  ${PriceByItemFields.marginValue} double DEFAULT '0',
  ${PriceByItemFields.costPrice} double DEFAULT '0',
  ${PriceByItemFields.afterRounding} double DEFAULT '0',
  ${PriceByItemFields.beforeRounding} double DEFAULT '0',
  ${PriceByItemFields.roundingDiff} double DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tpln2_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln2_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln2_tpln1Id_fkey` FOREIGN KEY (`tpln1Id`) REFERENCES `tpln1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePricesByItemBarcode (
  $uuidDefinition,
  ${PriceByItemBarcodeFields.createDate} datetime NOT NULL,
  ${PriceByItemBarcodeFields.updateDate} datetime DEFAULT NULL,
  ${PriceByItemBarcodeFields.tpln2Id} text DEFAULT NULL,
  ${PriceByItemBarcodeFields.tbitmId} text DEFAULT NULL,
  ${PriceByItemBarcodeFields.tcurrId} text DEFAULT NULL,
  ${PriceByItemBarcodeFields.price} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tpln4_tbitmId_fkey` FOREIGN KEY (`tbitmId`) REFERENCES `tbitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln4_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln4_tpln2Id_fkey` FOREIGN KEY (`tpln2Id`) REFERENCES `tpln2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
