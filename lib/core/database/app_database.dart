import 'package:path/path.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/pos_paramaeter.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/item_masters_dao.dart';
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
import 'package:pos_fe/features/sales/data/models/store_master.dart';
import 'package:pos_fe/features/sales/data/models/tax_master.dart';
import 'package:pos_fe/features/sales/data/models/uom.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  late final databaseVersion = 1;
  final _databaseName = "pos_fe.db";

  Database? _database;

  late ItemsDaoTest itemsDaoTest;
  late ItemsDao itemsDao;

  AppDatabase() {
    getDB().then((value) {
      itemsDaoTest = ItemsDaoTest(_database!);
      itemsDao = ItemsDao(_database!);
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
CREATE TABLE $tableTaxMasters (
  $uuidDefinition,
  ${TaxMasterFields.createDate} datetime NOT NULL,
  ${TaxMasterFields.updateDate} datetime DEFAULT NULL,
  ${TaxMasterFields.taxCode} varchar(30) NOT NULL,
  ${TaxMasterFields.description} varchar(200) NOT NULL,
  ${TaxMasterFields.rate} double NOT NULL,
  ${TaxMasterFields.periodFrom} date NOT NULL,
  ${TaxMasterFields.periodTo} date NOT NULL,
  ${TaxMasterFields.taxType} varchar(1) NOT NULL,
  ${TaxMasterFields.statusActive} int NOT NULL,
  ${TaxMasterFields.activated} int NOT NULL,
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
  ${ItemMasterFields.minStock} double NOT NULL,
  ${ItemMasterFields.maxStock} double NOT NULL,
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
  ${ItemMasterFields.margin} double DEFAULT '0',
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

        await txn.execute("""
CREATE TABLE $tableStoreMasters (
  $uuidDefinition,
  ${StoreMasterFields.createDate} datetime NOT NULL,
  ${StoreMasterFields.updateDate} datetime DEFAULT NULL,
  ${StoreMasterFields.storeCode} varchar(30) NOT NULL,
  ${StoreMasterFields.storeName} varchar(200) NOT NULL,
  ${StoreMasterFields.email} varchar(100) NOT NULL,
  ${StoreMasterFields.phone} varchar(20) NOT NULL,
  ${StoreMasterFields.addr1} varchar(200) NOT NULL,
  ${StoreMasterFields.addr2} varchar(200) DEFAULT NULL,
  ${StoreMasterFields.addr3} varchar(200) DEFAULT NULL,
  ${StoreMasterFields.city} varchar(100) NOT NULL,
  ${StoreMasterFields.remarks} text,
  ${StoreMasterFields.toprvId} text DEFAULT NULL,
  ${StoreMasterFields.tocryId} text DEFAULT NULL,
  ${StoreMasterFields.tozcdlId} text DEFAULT NULL,
  ${StoreMasterFields.tohemId} text DEFAULT NULL,
  ${StoreMasterFields.sqm} double NOT NULL,
  ${StoreMasterFields.tcurrId} text DEFAULT NULL,
  ${StoreMasterFields.toplnId} text DEFAULT NULL,
  ${StoreMasterFields.storePic} blob,
  ${StoreMasterFields.tovatId} text DEFAULT NULL,
  ${StoreMasterFields.storeCode} date NOT NULL,
  ${StoreMasterFields.statusActive} int NOT NULL,
  ${StoreMasterFields.activated} int NOT NULL,
  ${StoreMasterFields.prefixDoc} varchar(30) DEFAULT '',
  ${StoreMasterFields.header01} varchar(48) DEFAULT '-',
  ${StoreMasterFields.header02} varchar(48) DEFAULT '-',
  ${StoreMasterFields.header03} varchar(48) DEFAULT '-',
  ${StoreMasterFields.header04} varchar(48) DEFAULT '-',
  ${StoreMasterFields.header05} varchar(48) DEFAULT '-',
  ${StoreMasterFields.footer01} varchar(48) DEFAULT '-',
  ${StoreMasterFields.footer02} varchar(48) DEFAULT '-',
  ${StoreMasterFields.footer03} varchar(48) DEFAULT '-',
  ${StoreMasterFields.footer04} varchar(48) DEFAULT '-',
  ${StoreMasterFields.footer05} varchar(48) DEFAULT '-',
  ${StoreMasterFields.sellingTax} double DEFAULT '0',
  ${StoreMasterFields.openingBalance} double DEFAULT '0',
  ${StoreMasterFields.autoRounding} int DEFAULT '1',
  ${StoreMasterFields.roundingValue} double DEFAULT '0',
  ${StoreMasterFields.totalMinus} int DEFAULT '0',
  ${StoreMasterFields.totalZero} int DEFAULT '1',
  ${StoreMasterFields.holdStruck} int DEFAULT '0',
  ${StoreMasterFields.holdClose} int DEFAULT '0',
  ${StoreMasterFields.autoPrintStruk} int DEFAULT '0',
  ${StoreMasterFields.barcode1} varchar(5) DEFAULT '0',
  ${StoreMasterFields.barcode2} int DEFAULT '0',
  ${StoreMasterFields.barcode3} int DEFAULT '0',
  ${StoreMasterFields.barcode4} int DEFAULT '0',
  ${StoreMasterFields.connectBack} int DEFAULT '0',
  ${StoreMasterFields.maxUserKassa} int DEFAULT '2',
  ${StoreMasterFields.stockLevel} double NOT NULL DEFAULT '1.5',
  ${StoreMasterFields.minConst} double NOT NULL DEFAULT '0.5',
  ${StoreMasterFields.maxConst} double NOT NULL DEFAULT '0.75',
  ${StoreMasterFields.orderCycle} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.taxBy} int NOT NULL,
  ${StoreMasterFields.tpmt1Id} text DEFAULT NULL,
  ${StoreMasterFields.mtxline01} varchar(100) DEFAULT '',
  ${StoreMasterFields.mtxline02} varchar(100) DEFAULT '',
  ${StoreMasterFields.mtxline03} varchar(100) DEFAULT '',
  ${StoreMasterFields.mtxline04} varchar(100) DEFAULT '',
  ${StoreMasterFields.storeEpicPath} text,
  ${StoreMasterFields.attendaceFp} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.autoDownload} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.autoDownload1} datetime DEFAULT NULL,
  ${StoreMasterFields.autoDownload2} datetime DEFAULT NULL,
  ${StoreMasterFields.autoDownload3} datetime DEFAULT NULL,
  ${StoreMasterFields.autoSync} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.autoUpload} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.checkSellingPrice} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.checkStockMinus} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.creditTaxCodeId} text DEFAULT NULL,
  ${StoreMasterFields.maxVoidDays} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.qtyMinusValidation} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.roundingRemarks} varchar(10) DEFAULT 'Donasi',
  ${StoreMasterFields.searchItem} int NOT NULL DEFAULT '1',
  ${StoreMasterFields.vdfLine1} varchar(20) DEFAULT NULL,
  ${StoreMasterFields.vdfLine1Off} varchar(20) DEFAULT NULL,
  ${StoreMasterFields.vdfLine2} varchar(20) DEFAULT NULL,
  ${StoreMasterFields.vdfLine2Off} varchar(20) DEFAULT NULL,
  ${StoreMasterFields.isStore} int NOT NULL DEFAULT '1',
  $createdAtDefinition,
  CONSTRAINT `tostr_credittaxcodeId_fkey` FOREIGN KEY (`credittaxcodeId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tozcdId_fkey` FOREIGN KEY (`tozcdId`) REFERENCES `tozcd` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePOSParameter (
  $uuidDefinition,
  ${POSParameterFields.createDate} datetime NOT NULL,
  ${POSParameterFields.updateDate} datetime DEFAULT NULL,
  ${POSParameterFields.tostrId} text NOT NULL,
  ${POSParameterFields.storeName} text NOT NULL,
  ${POSParameterFields.tcurrId} text NOT NULL,
  ${POSParameterFields.currCode} text NOT NULL,
  ${POSParameterFields.toplnId} text NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `topos_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
)
""");

        await txn.execute("""
CREATE TABLE $tableEmployee (
  $uuidDefinition,
  ${EmployeeFields.createDate} datetime NOT NULL,
  ${EmployeeFields.updateDate} datetime DEFAULT NULL,
  ${EmployeeFields.empCode} text NOT NULL,
  ${EmployeeFields.empName} text NOT NULL,
  ${EmployeeFields.email} text NOT NULL,
  ${EmployeeFields.phone} text NOT NULL,
  ${EmployeeFields.addr1} text NOT NULL,
  ${EmployeeFields.addr2} text DEFAULT NULL,
  ${EmployeeFields.addr3} text DEFAULT NULL,
  ${EmployeeFields.city} text NOT NULL,
  ${EmployeeFields.remarks} text DEFAULT NULL,
  ${EmployeeFields.toprvId} text DEFAULT NULL,
  ${EmployeeFields.tocryId} text DEFAULT NULL,
  ${EmployeeFields.tozcdId} text DEFAULT NULL,
  ${EmployeeFields.idCard} text NOT NULL,
  ${EmployeeFields.gender} text NOT NULL,
  ${EmployeeFields.birthday} text NOT NULL,
  ${EmployeeFields.photo} blob NOT NULL,
  ${EmployeeFields.joinDate} datetime NOT NULL,
  ${EmployeeFields.resignDate} datetime NOT NULL,
  ${EmployeeFields.statusActive} int NOT NULL,
  ${EmployeeFields.activated} int NOT NULL,
  ${EmployeeFields.empDept} text NOT NULL,
  ${EmployeeFields.empTitle} text NOT NULL,
  ${EmployeeFields.empWorkplace} text NOT NULL,
  ${EmployeeFields.empdDebt} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tohem_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tohem_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tohem_tozcId_fkey` FOREIGN KEY (`tozcId`) REFERENCES `tozcd` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
)
""");

        await txn.execute("""
CREATE TABLE $tablePreferredVendor (
  $uuidDefinition,
  ${PreferredVendorFields.createDate} datetime NOT NULL,
  ${PreferredVendorFields.updateDate} datetime DEFAULT NULL,
  ${PreferredVendorFields.tsitmId} text DEFAULT NULL,
  ${PreferredVendorFields.tovenId} text DEFAULT NULL,
  ${PreferredVendorFields.listing} int NOT NULL,
  ${PreferredVendorFields.minOrder} double NOT NULL,
  ${PreferredVendorFields.multipyOrder} double NOT NULL,
  ${PreferredVendorFields.canOrder} int NOT NULL,
  ${PreferredVendorFields.dflt} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tvitm_tsitmId_fkey` FOREIGN KEY (`tsitmId`) REFERENCES `tsitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tvitm_tovenId_fkey` FOREIGN KEY (`tovenId`) REFERENCES `toven` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
)
""");
      });
    } catch (e) {
      print(e);
    }
  }

  Future upsertUsers(List<dynamic> obj) async {
    try {
      Database db = await getDB();

      await db.transaction((txn) async {
        await txn.rawInsert('''
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
        ''', obj);
      });
    } catch (err) {
      print(err);
    }
  }

  // Future close() async {
  //   final db = await instance.database;

  //   await db.close();
  // }
}
