import 'package:path/path.dart';
import 'package:pos_fe/core/database/seeders_data/phir1.dart';
import 'package:pos_fe/core/database/seeders_data/tbitm.dart';
import 'package:pos_fe/core/database/seeders_data/tcurr.dart';
import 'package:pos_fe/core/database/seeders_data/tocat.dart';
import 'package:pos_fe/core/database/seeders_data/toitm.dart';
import 'package:pos_fe/core/database/seeders_data/topln.dart';
import 'package:pos_fe/core/database/seeders_data/tostr.dart';
import 'package:pos_fe/core/database/seeders_data/touom.dart';
import 'package:pos_fe/core/database/seeders_data/tovat.dart';
import 'package:pos_fe/core/database/seeders_data/tphir.dart';
import 'package:pos_fe/core/database/seeders_data/tpln1.dart';
import 'package:pos_fe/core/database/seeders_data/tpln2.dart';
import 'package:pos_fe/core/database/seeders_data/tpln4.dart';
import 'package:pos_fe/core/database/seeders_data/tsitm.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_barcode_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_by_store_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_category_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/price_by_item_barcode_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/price_by_item_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/pricelist_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/pricelist_period_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/product_hierarchy_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/product_hierarchy_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/store_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/tax_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/uom_dao.dart';
import 'package:pos_fe/features/sales/data/models/assign_price_member_per_store.dart';
import 'package:pos_fe/features/sales/data/models/authorization.dart';
import 'package:pos_fe/features/sales/data/models/base_pay_term.dart';
import 'package:pos_fe/features/sales/data/models/batch_credit_memo.dart';
import 'package:pos_fe/features/sales/data/models/batch_invoice.dart';
import 'package:pos_fe/features/sales/data/models/bill_of_material.dart';
import 'package:pos_fe/features/sales/data/models/bill_of_material_line_item.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/country.dart';
import 'package:pos_fe/features/sales/data/models/credit_card.dart';
import 'package:pos_fe/features/sales/data/models/credit_memo_detail.dart';
import 'package:pos_fe/features/sales/data/models/credit_memo_header.dart';
import 'package:pos_fe/features/sales/data/models/credit_memo_pay_means.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/customer_address.dart';
import 'package:pos_fe/features/sales/data/models/customer_contact_person.dart';
import 'package:pos_fe/features/sales/data/models/customer_group.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:pos_fe/features/sales/data/models/gender.dart';
import 'package:pos_fe/features/sales/data/models/holiday.dart';
import 'package:pos_fe/features/sales/data/models/holiday_detail.dart';
import 'package:pos_fe/features/sales/data/models/house_bank_account.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/invoice_payment_other_voucher.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/item_picture.dart';
import 'package:pos_fe/features/sales/data/models/item_property.dart';
import 'package:pos_fe/features/sales/data/models/item_remarks.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_detail.dart';
import 'package:pos_fe/features/sales/data/models/mop_adjustment_header.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:pos_fe/features/sales/data/models/payment_term.dart';
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
import 'package:pos_fe/features/sales/data/models/payment_type_master.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_default_price_level.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_detail.dart';
import 'package:pos_fe/features/sales/data/models/promo_bertingkat_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/province.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/data/models/user_logs.dart';
import 'package:pos_fe/features/sales/data/models/user_role.dart';
import 'package:pos_fe/features/sales/data/models/zip_code.dart';
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

  late final ItemsDao itemsDao;
  late final CurrencyDao currencyDao;
  late final TaxMasterDao taxMasterDao;
  late final ProductHierarchyDao productHierarchyDao;
  late final ProductHierarchyMasterDao productHierarchyMasterDao;
  late final ItemCategoryDao itemCategoryDao;
  late final UomDao uomDao;
  late final ItemMasterDao itemMasterDao;
  late final PricelistDao pricelistDao;
  late final PricelistPeriodDao pricelistPeriodDao;
  late final ItemBarcodeDao itemBarcodeDao;
  late final ItemByStoreDao itemByStoreDao;
  late final PriceByItemDao priceByItemDao;
  late final PriceByItemBarcodeDao priceByItemBarcodeDao;
  late final StoreMasterDao storeMasterDao;

  AppDatabase() {
    getDB().then((db) {
      itemsDao = ItemsDao(db);
      currencyDao = CurrencyDao(db);
      itemCategoryDao = ItemCategoryDao(db);
      taxMasterDao = TaxMasterDao(db);
      productHierarchyDao = ProductHierarchyDao(db);
      productHierarchyMasterDao = ProductHierarchyMasterDao(db);
      uomDao = UomDao(db);
      itemMasterDao = ItemMasterDao(db);
      pricelistDao = PricelistDao(db);
      pricelistPeriodDao = PricelistPeriodDao(db);
      itemBarcodeDao = ItemBarcodeDao(db);
      itemByStoreDao = ItemByStoreDao(db);
      priceByItemDao = PriceByItemDao(db);
      priceByItemBarcodeDao = PriceByItemBarcodeDao(db);
      storeMasterDao = StoreMasterDao(db);

      currencyDao
          .bulkCreate(tcurr.map((e) => CurrencyModel.fromMap(e)).toList());
      itemCategoryDao
          .bulkCreate(tocat.map((e) => ItemCategoryModel.fromMap(e)).toList());
      taxMasterDao
          .bulkCreate(tovat.map((e) => TaxMasterModel.fromMap(e)).toList());
      productHierarchyDao.bulkCreate(
          tphir.map((e) => ProductHierarchyModel.fromMap(e)).toList());
      productHierarchyMasterDao.bulkCreate(
          phir1.map((e) => ProductHierarchyMasterModel.fromMap(e)).toList());

      pricelistDao
          .bulkCreate(topln.map((e) => PricelistModel.fromMap(e)).toList());
      pricelistPeriodDao.bulkCreate(
          tpln1.map((e) => PricelistPeriodModel.fromMap(e)).toList());
      uomDao.bulkCreate(touom.map((e) => UomModel.fromMap(e)).toList());
      storeMasterDao
          .bulkCreate(tostr.map((e) => StoreMasterModel.fromMap(e)).toList());
      itemMasterDao
          .bulkCreate(toitm.map((e) => ItemMasterModel.fromMap(e)).toList());
      itemBarcodeDao
          .bulkCreate(tbitm.map((e) => ItemBarcodeModel.fromMap(e)).toList());
      itemByStoreDao
          .bulkCreate(tsitm.map((e) => ItemByStoreModel.fromMap(e)).toList());
      priceByItemDao
          .bulkCreate(tpln2.map((e) => PriceByItemModel.fromMap(e)).toList());
      priceByItemBarcodeDao.bulkCreate(
          tpln4.map((e) => PriceByItemBarcodeModel.fromMap(e)).toList());
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
CREATE TABLE $tableCountry (
  $uuidDefinition,
  ${CountryFields.createDate} datetime NOT NULL,
  ${CountryFields.updateDate} datetime DEFAULT NULL,
  ${CountryFields.countryCode} varchar(30) NOT NULL,
  ${CountryFields.description} varchar(30) NOT NULL,
  ${CountryFields.descriptionFrgn} varchar(30) NOT NULL,
  ${CountryFields.tcurrId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tocry_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableProvince (
  $uuidDefinition,
  ${ProvinceFields.createDate} datetime NOT NULL,
  ${ProvinceFields.updateDate} datetime DEFAULT NULL,
  ${ProvinceFields.provncCode} varchar(30) NOT NULL,
  ${ProvinceFields.description} varchar(100) NOT NULL,
  ${ProvinceFields.descriptionFrgn} varchar(100) NOT NULL,
  ${ProvinceFields.tocryId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `toprv_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableZipCode (
  $uuidDefinition,
  ${ZipCodeFields.createDate} datetime NOT NULL,
  ${ZipCodeFields.updateDate} datetime DEFAULT NULL,
  ${ZipCodeFields.zipCode} varchar(30) NOT NULL,
  ${ZipCodeFields.city} varchar(100) NOT NULL,
  ${ZipCodeFields.district} varchar(100) NOT NULL,
  ${ZipCodeFields.urban} varchar(100) NOT NULL,
  ${ZipCodeFields.subDistrict} varchar(100) NOT NULL,
  ${ZipCodeFields.toprvId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tozcd_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
CREATE TABLE `$tableProductHierarchies` (
  $uuidDefinition,
  ${ProductHierarchyFields.createDate} datetime NOT NULL,
  ${ProductHierarchyFields.updateDate} datetime DEFAULT NULL,
  ${ProductHierarchyFields.description} varchar(100) NOT NULL,
  ${ProductHierarchyFields.level} int NOT NULL,
  ${ProductHierarchyFields.maxChar} int NOT NULL,
  $createdAtDefinition
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
  ${ItemCategoryFields.phir1Id} text DEFAULT NULL,
  $createdAtDefinition
)
""");
        // CONSTRAINT `tocat_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `tocat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
        // CONSTRAINT `tocat_phir1Id_fkey` FOREIGN KEY (`phir1Id`) REFERENCES `phir1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE

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
CREATE TABLE $tableItemPicture (
  $uuidDefinition,
  ${ItemPictureFields.createDate} datetime NOT NULL,
  ${ItemPictureFields.updateDate} datetime DEFAULT NULL,
  ${ItemPictureFields.toitmId} text DEFAULT NULL,
  ${ItemPictureFields.picture} blob NOT NULL,
  ${ItemPictureFields.path} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tpitm_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableItemRemarks (
  $uuidDefinition,
  ${ItemRemarksFields.createDate} datetime NOT NULL,
  ${ItemRemarksFields.updateDate} datetime DEFAULT NULL,
  ${ItemRemarksFields.toitmId} text DEFAULT NULL,
  ${ItemRemarksFields.remarks} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tritm_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  $createdAtDefinition,
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
CREATE TABLE $tableEmployee (
  $uuidDefinition,
  ${EmployeeFields.createDate} datetime NOT NULL,
  ${EmployeeFields.updateDate} datetime DEFAULT NULL,
  ${EmployeeFields.empCode} varchar(30) NOT NULL,
  ${EmployeeFields.empName} varchar(200) NOT NULL,
  ${EmployeeFields.email} varchar(100) NOT NULL,
  ${EmployeeFields.phone} varchar(20) NOT NULL,
  ${EmployeeFields.addr1} varchar(200) NOT NULL,
  ${EmployeeFields.addr2} varchar(200) DEFAULT NULL,
  ${EmployeeFields.addr3} varchar(200) DEFAULT NULL,
  ${EmployeeFields.city} text NOT NULL,
  ${EmployeeFields.remarks} text DEFAULT NULL,
  ${EmployeeFields.toprvId} text DEFAULT NULL,
  ${EmployeeFields.tocryId} text DEFAULT NULL,
  ${EmployeeFields.tozcdId} text DEFAULT NULL,
  ${EmployeeFields.idCard} varchar(30) NOT NULL,
  ${EmployeeFields.gender} varchar(1) NOT NULL,
  ${EmployeeFields.birthdate} text NOT NULL,
  ${EmployeeFields.photo} blob NOT NULL,
  ${EmployeeFields.joinDate} datetime NOT NULL,
  ${EmployeeFields.resignDate} datetime NOT NULL,
  ${EmployeeFields.statusActive} int NOT NULL,
  ${EmployeeFields.activated} int NOT NULL,
  ${EmployeeFields.empDept} varchar(200) NOT NULL,
  ${EmployeeFields.empTitle} varchar(200) NOT NULL,
  ${EmployeeFields.empWorkplace} varchar(200) NOT NULL,
  ${EmployeeFields.empdDebt} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tohem_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tohem_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tohem_tozcdId_fkey` FOREIGN KEY (`tozcdId`) REFERENCES `tozcd` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tvitm_tovenId_fkey` FOREIGN KEY (`tovenId`) REFERENCES `toven` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePaymentTerm (
  $uuidDefinition,
  ${PaymentTermFields.createDate} datetime NOT NULL,
  ${PaymentTermFields.updateDate} datetime DEFAULT NULL,
  ${PaymentTermFields.paymentCode} varchar(30) NOT NULL,
  ${PaymentTermFields.description} varchar(100) NOT NULL,
  ${PaymentTermFields.base} varchar(1) NOT NULL,
  ${PaymentTermFields.dueon} int NOT NULL,
  ${PaymentTermFields.statusActive} int NOT NULL,
  ${PaymentTermFields.activated} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableUserRole (
  $uuidDefinition,
  ${UserRoleFields.createDate} datetime NOT NULL,
  ${UserRoleFields.updateDate} datetime DEFAULT NULL,
  ${UserRoleFields.roleCode} varchar(30) NOT NULL,
  ${UserRoleFields.roleName} varchar(100) NOT NULL,
  ${UserRoleFields.statusActive} int NOT NULL,
  ${UserRoleFields.activated} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableUser (
  $uuidDefinition,
  ${UserFields.createDate} datetime NOT NULL,
  ${UserFields.updateDate} datetime DEFAULT NULL,
  ${UserFields.email} varchar(100) NOT NULL,
  ${UserFields.username} varchar(100) NOT NULL,
  ${UserFields.password} varchar(100) NOT NULL,
  ${UserFields.tohemId} text DEFAULT NULL,
  ${UserFields.torolId} text DEFAULT NULL,
  ${UserFields.statusActive} int NOT NULL,
  ${UserFields.activated} int NOT NULL,
  ${UserFields.superUser} int NOT NULL,
  ${UserFields.provider} int NOT NULL,
  ${UserFields.userType} int DEFAULT NULL,
  ${UserFields.trolleyUser} varchar(20) DEFAULT NULL,
  ${UserFields.trolleyPass} varchar(100) DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tousr_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tousr_torolId_fkey` FOREIGN KEY (`torolId`) REFERENCES `torol` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableAuthorization (
  $uuidDefinition,
  ${AuthorizationFields.createDate} datetime NOT NULL,
  ${AuthorizationFields.updateDate} datetime DEFAULT NULL,
  ${AuthorizationFields.tousrId} text DEFAULT NULL,
  ${AuthorizationFields.authorization} int NOT NULL,
  ${AuthorizationFields.setBy} int NOT NULL,
  ${AuthorizationFields.canView} int DEFAULT NULL,
  ${AuthorizationFields.canCreate} int DEFAULT NULL,
  ${AuthorizationFields.canUpdate} int DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `toaut_tousrId_fkey` FOREIGN KEY (`tousrId`) REFERENCES `tousr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
        // ${AuthorizationFields.tformId} text DEFAULT NULL,
        //CONSTRAINT `toaut_tformId_fkey` FOREIGN KEY (`tformId`) REFERENCES `tform` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,

        await txn.execute("""
CREATE TABLE $tableCustomerGroup (
  $uuidDefinition,
  ${CustomerGroupFields.createDate} datetime NOT NULL,
  ${CustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${CustomerGroupFields.custgroupCode} varchar(30) NOT NULL,
  ${CustomerGroupFields.description} varchar(100) NOT NULL,
  ${CustomerGroupFields.maxDiscount} double NOT NULL,
  ${CustomerGroupFields.statusActive} int NOT NULL,
  ${CustomerGroupFields.activated} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableBasePayTerm (
  $uuidDefinition,
  ${BasePayTermFields.createDate} datetime NOT NULL,
  ${BasePayTermFields.updateDate} datetime DEFAULT NULL,
  ${BasePayTermFields.baseCode} varchar(1) NOT NULL,
  ${BasePayTermFields.description} varchar(100) NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableCustomer (
  $uuidDefinition,
  ${CustomerFields.createDate} datetime NOT NULL,
  ${CustomerFields.updateDate} datetime DEFAULT NULL,
  ${CustomerFields.custCode} varchar(191) NOT NULL,
  ${CustomerFields.custName} varchar(100) NOT NULL,
  ${CustomerFields.tocrgId} text DEFAULT NULL,
  ${CustomerFields.idCard} varchar(30) NOT NULL,
  ${CustomerFields.taxNo} varchar(50) NOT NULL,
  ${CustomerFields.gender} varchar(1) NOT NULL,
  ${CustomerFields.birthdate} datetime NOT NULL,
  ${CustomerFields.addr1} varchar(200) NOT NULL,
  ${CustomerFields.addr2} varchar(200) DEFAULT NULL,
  ${CustomerFields.addr3} varchar(200) DEFAULT NULL,
  ${CustomerFields.city} varchar(100) NOT NULL,
  ${CustomerFields.toprvId} text DEFAULT NULL,
  ${CustomerFields.tocryId} text DEFAULT NULL,
  ${CustomerFields.tozcdId} text DEFAULT NULL,
  ${CustomerFields.phone} varchar(20) NOT NULL,
  ${CustomerFields.email} varchar(100) NOT NULL,
  ${CustomerFields.remarks} text DEFAULT NULL,
  ${CustomerFields.toptrId} text DEFAULT NULL,
  ${CustomerFields.toplnId} text DEFAULT NULL,
  ${CustomerFields.joinDate} datetime DEFAULT NULL,
  ${CustomerFields.maxDiscount} double NOT NULL,
  ${CustomerFields.statusActive} int NOT NULL,
  ${CustomerFields.activated} int NOT NULL,
  ${CustomerFields.isEmployee} int NOT NULL DEFAULT '0',
  ${CustomerFields.tohemId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tocus_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocus_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocus_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocus_tozcdId_fkey` FOREIGN KEY (`tozcdId`) REFERENCES `tozcd` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocus_toptrId_fkey` FOREIGN KEY (`toptrId`) REFERENCES `toptr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocus_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tocus_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCustomerAddress (
  $uuidDefinition,
  ${CustomerAddressFields.createDate} datetime NOT NULL,
  ${CustomerAddressFields.updateDate} datetime DEFAULT NULL,
  ${CustomerAddressFields.tocusId} text DEFAULT NULL,
  ${CustomerAddressFields.linenum} int NOT NULL,
  ${CustomerAddressFields.addr1} varchar(200) NOT NULL,
  ${CustomerAddressFields.addr2} varchar(200) DEFAULT NULL,
  ${CustomerAddressFields.addr3} varchar(200) DEFAULT NULL,
  ${CustomerAddressFields.city} varchar(100) NOT NULL,
  ${CustomerAddressFields.toprvId} text DEFAULT NULL,
  ${CustomerAddressFields.tocryId} text DEFAULT NULL,
  ${CustomerAddressFields.tozcdId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tcus1_tocusId_fkey` FOREIGN KEY (`tocusId`) REFERENCES `tocus` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcus1_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcus1_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcus1_tozcdId_fkey` FOREIGN KEY (`tozcdId`) REFERENCES `tozcd` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCustomerContactPerson (
  $uuidDefinition,
  ${CustomerContactPersonFields.createDate} datetime NOT NULL,
  ${CustomerContactPersonFields.updateDate} datetime DEFAULT NULL,
  ${CustomerContactPersonFields.tocusId} text DEFAULT NULL,
  ${CustomerContactPersonFields.linenum} int NOT NULL,
  ${CustomerContactPersonFields.title} varchar(20) NOT NULL,
  ${CustomerContactPersonFields.fullname} varchar(200) NOT NULL,
  ${CustomerContactPersonFields.phone} varchar(20) NOT NULL,
  ${CustomerContactPersonFields.email} varchar(100) NOT NULL,
  ${CustomerContactPersonFields.position} varchar(50) NOT NULL,
  ${CustomerContactPersonFields.idcard} varchar(30) NOT NULL,
  ${CustomerContactPersonFields.taxno} varchar(50) NOT NULL,
  ${CustomerContactPersonFields.gender} varchar(1) NOT NULL,
  ${CustomerContactPersonFields.birthdate} date NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tcus2_tocusId_fkey` FOREIGN KEY (`tocusId`) REFERENCES `tocus` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePaymentTypeMaster (
  $uuidDefinition,
  ${PaymentTypeMasterFields.createDate} datetime NOT NULL,
  ${PaymentTypeMasterFields.updateDate} datetime DEFAULT NULL,
  ${PaymentTypeMasterFields.payTypeCode} varchar(10) NOT NULL,
  ${PaymentTypeMasterFields.description} varchar(100) NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tablePaymentType (
  $uuidDefinition,
  ${PaymentTypeFields.createDate} datetime NOT NULL,
  ${PaymentTypeFields.updateDate} datetime DEFAULT NULL,
  ${PaymentTypeFields.payTypeCode} varchar(10) NOT NULL,
  ${PaymentTypeFields.description} varchar(100) NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableMOP (
  $uuidDefinition,
  ${MeansOfPaymentFields.createDate} datetime NOT NULL,
  ${MeansOfPaymentFields.updateDate} datetime DEFAULT NULL,
  ${MeansOfPaymentFields.topmtId} text DEFAULT NULL,
  ${MeansOfPaymentFields.mopCode} varchar(30) NOT NULL,
  ${MeansOfPaymentFields.description} varchar(100) NOT NULL,
  ${MeansOfPaymentFields.mopAlias} varchar(100) NOT NULL,
  ${MeansOfPaymentFields.bankCharge} double NOT NULL,
  ${MeansOfPaymentFields.consolidation} int NOT NULL,
  ${MeansOfPaymentFields.credit} int NOT NULL,
  ${MeansOfPaymentFields.subType} int NOT NULL DEFAULT '0',
  ${MeansOfPaymentFields.validForEmp} int NOT NULL DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tpmt1_topmtId_fkey` FOREIGN KEY (`topmtId`) REFERENCES `topmt` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCC (
  $uuidDefinition,
  ${CreditCardFields.createDate} datetime NOT NULL,
  ${CreditCardFields.updateDate} datetime DEFAULT NULL,
  ${CreditCardFields.ccCode} varchar(30) NOT NULL,
  ${CreditCardFields.description} varchar(100) NOT NULL,
  ${CreditCardFields.cardType} int NOT NULL DEFAULT '0',
  ${CreditCardFields.statusActive} int NOT NULL DEFAULT '0',
  ${CreditCardFields.activated} int NOT NULL DEFAULT '0',
  $createdAtDefinition
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
  ${StoreMasterFields.storeOpen} date NOT NULL,
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
  CONSTRAINT `tostr_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
        // CONSTRAINT `tostr_credittaxcodeId_fkey` FOREIGN KEY (`credittaxcodeId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
        // CONSTRAINT `tostr_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
        // CONSTRAINT `tostr_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
        // CONSTRAINT `tostr_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
        // CONSTRAINT `tostr_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,

        await txn.execute("""
CREATE TABLE $tablePOSParameter (
  $uuidDefinition,
  ${POSParameterFields.createDate} datetime NOT NULL,
  ${POSParameterFields.updateDate} datetime DEFAULT NULL,
  ${POSParameterFields.tostrId} text DEFAULT NULL,
  ${POSParameterFields.storeName} text NOT NULL,
  ${POSParameterFields.tcurrId} text DEFAULT NULL,
  ${POSParameterFields.currCode} text DEFAULT NULL,
  ${POSParameterFields.toplnId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `topos_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableMOPByStore (
  $uuidDefinition,
  ${MOPByStoreFields.createDate} datetime NOT NULL,
  ${MOPByStoreFields.updateDate} datetime DEFAULT NULL,
  ${MOPByStoreFields.tpmt1id} text DEFAULT NULL,
  ${MOPByStoreFields.tostrId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tpmt3_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpmt3_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableAPMPS (
  $uuidDefinition,
  ${AssignPriceMemberPerStoreFields.createDate} datetime NOT NULL,
  ${AssignPriceMemberPerStoreFields.updateDate} datetime DEFAULT NULL,
  ${AssignPriceMemberPerStoreFields.toplnId} text DEFAULT NULL,
  ${AssignPriceMemberPerStoreFields.tostrId} text DEFAULT NULL,
  ${AssignPriceMemberPerStoreFields.statusActive} int NOT NULL,
  ${AssignPriceMemberPerStoreFields.activated} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tpln3_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln3_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
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
CREATE TABLE $tableCashRegister (
  $uuidDefinition,
  ${CashRegisterFields.createDate} datetime NOT NULL,
  ${CashRegisterFields.updateDate} datetime DEFAULT NULL,
  ${CashRegisterFields.tostrId} text DEFAULT NULL,
  ${CashRegisterFields.hwkey} varchar(100) NOT NULL,
  ${CashRegisterFields.token} varchar(100) NOT NULL,
  ${CashRegisterFields.email} varchar(100) NOT NULL,
  ${CashRegisterFields.statusActive} int NOT NULL,
  ${CashRegisterFields.activated} int NOT NULL,
  ${CashRegisterFields.description} varchar(100) NOT NULL,
  ${CashRegisterFields.ipKassa} varchar(15) DEFAULT NULL,
  ${CashRegisterFields.idKassa} varchar(50) DEFAULT NULL,
  ${CashRegisterFields.printerCode} varchar(20) DEFAULT NULL,
  ${CashRegisterFields.printerLogo} int DEFAULT NULL,
  ${CashRegisterFields.strukType} int DEFAULT NULL,
  ${CashRegisterFields.bigHeader} int DEFAULT NULL,
  ${CashRegisterFields.syncCloud} int DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tocsr_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCashierBalanceTransaction (
  $uuidDefinition,
  ${CashierBalanceTransactionFields.createDate} datetime NOT NULL,
  ${CashierBalanceTransactionFields.updateDate} datetime DEFAULT NULL,
  ${CashierBalanceTransactionFields.tocsrId} text DEFAULT NULL,
  ${CashierBalanceTransactionFields.tousrId} text DEFAULT NULL,
  ${CashierBalanceTransactionFields.docNum} varchar(30) NOT NULL,
  ${CashierBalanceTransactionFields.openDate} date NOT NULL,
  ${CashierBalanceTransactionFields.openTime} time NOT NULL,
  ${CashierBalanceTransactionFields.calcDate} date NOT NULL,
  ${CashierBalanceTransactionFields.calcTime} time NOT NULL,
  ${CashierBalanceTransactionFields.closeDate} date NOT NULL,
  ${CashierBalanceTransactionFields.closeTime} time NOT NULL,
  ${CashierBalanceTransactionFields.timezone} varchar(200) NOT NULL,
  ${CashierBalanceTransactionFields.openValue} double NOT NULL,
  ${CashierBalanceTransactionFields.calcValue} double NOT NULL,
  ${CashierBalanceTransactionFields.cashValue} double NOT NULL,
  ${CashierBalanceTransactionFields.closeValue} double NOT NULL,
  ${CashierBalanceTransactionFields.openedbyId} text DEFAULT NULL,
  ${CashierBalanceTransactionFields.closedbyId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tcsr1_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcsr1_tousrId_fkey` FOREIGN KEY (`tousrId`) REFERENCES `tousr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcsr1_openedbyId_fkey` FOREIGN KEY (`openedbyId`) REFERENCES `tousr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcsr1_closedbyId_fkey` FOREIGN KEY (`closedbyId`) REFERENCES `tousr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableGender (
  $uuidDefinition,
  ${GenderFields.createDate} datetime NOT NULL,
  ${GenderFields.updateDate} datetime DEFAULT NULL,
  ${GenderFields.genderCode} varchar(1) NOT NULL,
  ${GenderFields.description} varchar(100) NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableHouseBankAccount (
  $uuidDefinition,
  ${HouseBankAccountFields.createDate} datetime NOT NULL,
  ${HouseBankAccountFields.updateDate} datetime DEFAULT NULL,
  ${HouseBankAccountFields.accountNo} varchar(30) NOT NULL,
  ${HouseBankAccountFields.accountName} varchar(200) NOT NULL,
  ${HouseBankAccountFields.bank} varchar(100) NOT NULL,
  ${HouseBankAccountFields.tostrId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tobnk_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableBillOfMaterial (
  $uuidDefinition,
  ${BillOfMaterialFields.createDate} datetime NOT NULL,
  ${BillOfMaterialFields.updateDate} datetime DEFAULT NULL,
  ${BillOfMaterialFields.toitmId} text DEFAULT NULL,
  ${BillOfMaterialFields.quantity} double NOT NULL,
  ${BillOfMaterialFields.touomId} text DEFAULT NULL,
  ${BillOfMaterialFields.tipe} int NOT NULL,
  ${BillOfMaterialFields.tcurrId} text DEFAULT NULL,
  ${BillOfMaterialFields.price} double NOT NULL,
  ${BillOfMaterialFields.statusActive} int NOT NULL,
  ${BillOfMaterialFields.sync} int NOT NULL DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `toitt_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitt_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitt_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableBOMLineItem (
  $uuidDefinition,
  ${BillOfMaterialLineItemFields.createDate} datetime NOT NULL,
  ${BillOfMaterialLineItemFields.updateDate} datetime DEFAULT NULL,
  ${BillOfMaterialLineItemFields.toittId} text DEFAULT NULL,
  ${BillOfMaterialLineItemFields.toitmId} text DEFAULT NULL,
  ${BillOfMaterialLineItemFields.quantity} double NOT NULL,
  ${BillOfMaterialLineItemFields.touomId} text DEFAULT NULL,
  ${BillOfMaterialLineItemFields.tcurrId} text DEFAULT NULL,
  ${BillOfMaterialLineItemFields.price} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `titt1_toittId_fkey` FOREIGN KEY (`toittId`) REFERENCES `toitt` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `titt1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `titt1_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `titt1_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableHoliday (
  $uuidDefinition,
  ${HolidayFields.createDate} datetime NOT NULL,
  ${HolidayFields.updateDate} datetime DEFAULT NULL,
  ${HolidayFields.calendarCode} varchar(30) NOT NULL,
  ${HolidayFields.description} varchar(200) NOT NULL,
  ${HolidayFields.descriptionFrgn} varchar(200) NOT NULL,
  ${HolidayFields.fiscalYear} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableHolidayDetail (
  $uuidDefinition,
  ${HolidayDetailFields.createDate} datetime NOT NULL,
  ${HolidayDetailFields.updateDate} datetime DEFAULT NULL,
  ${HolidayDetailFields.tohldId} text DEFAULT NULL,
  ${HolidayDetailFields.holidayDate} date NOT NULL,
  ${HolidayDetailFields.description} varchar(200) NOT NULL,
  ${HolidayDetailFields.descriptionFrgn} varchar(200) NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `thld1_tohldId_fkey` FOREIGN KEY (`tohldId`) REFERENCES `tohld` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableInvoiceHeader (
  $uuidDefinition,
  ${InvoiceHeaderFields.createDate} datetime NOT NULL,
  ${InvoiceHeaderFields.updateDate} datetime DEFAULT NULL,
  ${InvoiceHeaderFields.tostrId} text DEFAULT NULL,
  ${InvoiceHeaderFields.docnum} varchar(30) NOT NULL,
  ${InvoiceHeaderFields.orderNo} int NOT NULL,
  ${InvoiceHeaderFields.tocusId} text DEFAULT NULL,
  ${InvoiceHeaderFields.tohemId} text DEFAULT NULL,
  ${InvoiceHeaderFields.transDate} date NOT NULL,
  ${InvoiceHeaderFields.transTime} time NOT NULL,
  ${InvoiceHeaderFields.timezone} varchar(200) NOT NULL,
  ${InvoiceHeaderFields.remarks} text,
  ${InvoiceHeaderFields.subTotal} double NOT NULL,
  ${InvoiceHeaderFields.discPrctg} double NOT NULL,
  ${InvoiceHeaderFields.discAmount} double NOT NULL,
  ${InvoiceHeaderFields.discountCard} double NOT NULL,
  ${InvoiceHeaderFields.coupon} varchar(30) NOT NULL,
  ${InvoiceHeaderFields.discountCoupun} double NOT NULL,
  ${InvoiceHeaderFields.taxPrctg} double NOT NULL,
  ${InvoiceHeaderFields.taxAmount} double NOT NULL,
  ${InvoiceHeaderFields.addCost} double NOT NULL,
  ${InvoiceHeaderFields.rounding} double NOT NULL,
  ${InvoiceHeaderFields.grandTotal} double NOT NULL,
  ${InvoiceHeaderFields.changed} double NOT NULL,
  ${InvoiceHeaderFields.totalPayment} double NOT NULL,
  ${InvoiceHeaderFields.tocsrId} text DEFAULT NULL,
  ${InvoiceHeaderFields.docStatus} int NOT NULL DEFAULT '0',
  ${InvoiceHeaderFields.sync} int NOT NULL DEFAULT '0',
  ${InvoiceHeaderFields.syncCRM} int NOT NULL DEFAULT '0',
  ${InvoiceHeaderFields.toinvTohemId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `toinv_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toinv_tocusId_fkey` FOREIGN KEY (`tocusId`) REFERENCES `tocus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toinv_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toinv_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toinv_toinvTohemId_fkey` FOREIGN KEY (`toinvTohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableInvoiceDetail (
  $uuidDefinition,
  ${InvoiceDetailFields.createDate} datetime NOT NULL,
  ${InvoiceDetailFields.updateDate} datetime DEFAULT NULL,
  ${InvoiceDetailFields.toinvId} text DEFAULT NULL,
  ${InvoiceDetailFields.lineNum} int NOT NULL,
  ${InvoiceDetailFields.docNum} varchar(30) NOT NULL,
  ${InvoiceDetailFields.idNumber} int NOT NULL,
  ${InvoiceDetailFields.toitmId} text DEFAULT NULL,
  ${InvoiceDetailFields.quantity} double NOT NULL,
  ${InvoiceDetailFields.sellingPrice} double NOT NULL,
  ${InvoiceDetailFields.discPrctg} double NOT NULL,
  ${InvoiceDetailFields.discAmount} double NOT NULL,
  ${InvoiceDetailFields.totalAmount} double NOT NULL,
  ${InvoiceDetailFields.taxPrctg} double NOT NULL,
  ${InvoiceDetailFields.promotionType} varchar(20) NOT NULL,
  ${InvoiceDetailFields.promotionId} varchar(191) NOT NULL,
  ${InvoiceDetailFields.remarks} text,
  ${InvoiceDetailFields.editTime} datetime NOT NULL,
  ${InvoiceDetailFields.cogs} double NOT NULL,
  ${InvoiceDetailFields.tovatId} text DEFAULT NULL,
  ${InvoiceDetailFields.promotionTingkat} varchar(191) DEFAULT NULL,
  ${InvoiceDetailFields.promoVoucherNo} varchar(191) DEFAULT NULL,
  ${InvoiceDetailFields.baseDocId} varchar(191) DEFAULT NULL,
  ${InvoiceDetailFields.baseLineDocId} varchar(191) DEFAULT NULL,
  ${InvoiceDetailFields.includeTax} int NOT NULL,
  ${InvoiceDetailFields.tovenId} text DEFAULT NULL,
  ${InvoiceDetailFields.tbitmId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tinv1_toinvId_fkey` FOREIGN KEY (`toinvId`) REFERENCES `toinv` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_tovenId_fkey` FOREIGN KEY (`tovenId`) REFERENCES `toven` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_tbitmId_fkey` FOREIGN KEY (`tbitmId`) REFERENCES `tbitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePayMeans (
  $uuidDefinition,
  ${PayMeansFields.createDate} datetime NOT NULL,
  ${PayMeansFields.updateDate} datetime DEFAULT NULL,
  ${PayMeansFields.toinvId} text DEFAULT NULL,
  ${PayMeansFields.lineNum} int NOT NULL,
  ${PayMeansFields.tpmt3Id} text DEFAULT NULL,
  ${PayMeansFields.amount} double NOT NULL,
  ${PayMeansFields.tpmt2Id} text DEFAULT NULL,
  ${PayMeansFields.cardNo} varchar(20) DEFAULT NULL,
  ${PayMeansFields.cardHolder} varchar(20) DEFAULT NULL,
  ${PayMeansFields.sisaVoucher} double DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tinv2_toinvId_fkey` FOREIGN KEY (`toinvId`) REFERENCES `toinv` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tinv2_tpmt3Id_fkey` FOREIGN KEY (`tpmt3Id`) REFERENCES `tpmt3` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tinv2_tpmt2Id_fkey` FOREIGN KEY (`tpmt2Id`) REFERENCES `tpmt2` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableBatchInvoice (
  $uuidDefinition,
  ${BatchInvoiceFields.createDate} datetime NOT NULL,
  ${BatchInvoiceFields.updateDate} datetime DEFAULT NULL,
  ${BatchInvoiceFields.tinv1Docid} text DEFAULT NULL,
  ${BatchInvoiceFields.toitmId} text DEFAULT NULL,
  ${BatchInvoiceFields.batchNo} varchar(10) NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tinv3_tinv1Docid_fkey` FOREIGN KEY (`tinv1Docid`) REFERENCES `tinv1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv3_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableIPOV (
  $uuidDefinition,
  ${IPOVFields.createDate} datetime NOT NULL,
  ${IPOVFields.updateDate} datetime DEFAULT NULL,
  ${IPOVFields.toinvId} text DEFAULT NULL,
  ${IPOVFields.type} int NOT NULL,
  ${IPOVFields.serialNo} varchar(50) NOT NULL,
  ${IPOVFields.amount} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tinv4_toinvId_fkey` FOREIGN KEY (`toinvId`) REFERENCES `toinv` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCreditMemoHeader (
  $uuidDefinition,
  ${CreditMemoHeaderFields.createDate} datetime NOT NULL,
  ${CreditMemoHeaderFields.updateDate} datetime DEFAULT NULL,
  ${CreditMemoHeaderFields.tostrId} text DEFAULT NULL,
  ${CreditMemoHeaderFields.docNum} varchar(30) NOT NULL,
  ${CreditMemoHeaderFields.orderNo} int NOT NULL,
  ${CreditMemoHeaderFields.tocusId} text DEFAULT NULL,
  ${CreditMemoHeaderFields.tohemId} text DEFAULT NULL,
  ${CreditMemoHeaderFields.transDate} date NOT NULL,
  ${CreditMemoHeaderFields.transTime} time NOT NULL,
  ${CreditMemoHeaderFields.timezone} varchar(200) NOT NULL,
  ${CreditMemoHeaderFields.remarks} text DEFAULT NULL,
  ${CreditMemoHeaderFields.subTotal} double NOT NULL,
  ${CreditMemoHeaderFields.discPrctg} double NOT NULL,
  ${CreditMemoHeaderFields.discAmount} double NOT NULL,
  ${CreditMemoHeaderFields.discountCard} double NOT NULL,
  ${CreditMemoHeaderFields.coupon} varchar(20) NOT NULL,
  ${CreditMemoHeaderFields.discountCoupun} double NOT NULL,
  ${CreditMemoHeaderFields.taxPrctg} double NOT NULL,
  ${CreditMemoHeaderFields.taxAmount} double NOT NULL,
  ${CreditMemoHeaderFields.addCost} double NOT NULL,
  ${CreditMemoHeaderFields.rounding} double NOT NULL,
  ${CreditMemoHeaderFields.grandTotal} double NOT NULL,
  ${CreditMemoHeaderFields.changed} double NOT NULL,
  ${CreditMemoHeaderFields.totalPayment} double NOT NULL,
  ${CreditMemoHeaderFields.tocsrId} text DEFAULT NULL,
  ${CreditMemoHeaderFields.docStatus} int NOT NULL DEFAULT '0',
  ${CreditMemoHeaderFields.sync} int NOT NULL DEFAULT '0',
  ${CreditMemoHeaderFields.syncCRM} int NOT NULL DEFAULT '0',
  ${CreditMemoHeaderFields.torinTohemId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `torin_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_tocusId_fkey` FOREIGN KEY (`tocusId`) REFERENCES `tocus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_torinTohemId_fkey` FOREIGN KEY (`torinTohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCreditMemoDetail (
  $uuidDefinition,
  ${CreditMemoDetailFields.createDate} datetime NOT NULL,
  ${CreditMemoDetailFields.updateDate} datetime DEFAULT NULL,
  ${CreditMemoDetailFields.torinId} text DEFAULT NULL,
  ${CreditMemoDetailFields.lineNum} int NOT NULL,
  ${CreditMemoDetailFields.docNum} varchar(30) NOT NULL,
  ${CreditMemoDetailFields.idNumber} int NOT NULL,
  ${CreditMemoDetailFields.toitmId} text DEFAULT NULL,
  ${CreditMemoDetailFields.quantity} double NOT NULL,
  ${CreditMemoDetailFields.sellingPrice} double NOT NULL,
  ${CreditMemoDetailFields.discPrctg} double NOT NULL,
  ${CreditMemoDetailFields.discAmount} double NOT NULL,
  ${CreditMemoDetailFields.totalAmount} double NOT NULL,
  ${CreditMemoDetailFields.taxPrctg} double NOT NULL,
  ${CreditMemoDetailFields.promotionType} varchar(20) NOT NULL,
  ${CreditMemoDetailFields.promotionId} varchar(191) NOT NULL,
  ${CreditMemoDetailFields.remarks} text,
  ${CreditMemoDetailFields.editTime} datetime NOT NULL,
  ${CreditMemoDetailFields.cogs} double NOT NULL,
  ${CreditMemoDetailFields.tovatId} text DEFAULT NULL,
  ${CreditMemoDetailFields.promotionTingkat} varchar(191) DEFAULT NULL,
  ${CreditMemoDetailFields.promoVoucherNo} varchar(191) DEFAULT NULL,
  ${CreditMemoDetailFields.baseDocId} varchar(191) DEFAULT NULL,
  ${CreditMemoDetailFields.baseLineDocId} varchar(191) DEFAULT NULL,
  ${CreditMemoDetailFields.includeTax} int NOT NULL,
  ${CreditMemoDetailFields.tovenId} text DEFAULT NULL,
  ${CreditMemoDetailFields.tbitmId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `trin1_torinId_fkey` FOREIGN KEY (`torinId`) REFERENCES `torin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_tovenId_fkey` FOREIGN KEY (`tovenId`) REFERENCES `toven` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_tbitmId_fkey` FOREIGN KEY (`tbitmId`) REFERENCES `tbitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableCreditMemoPayMeans (
  $uuidDefinition,
  ${CreditMemoPayMeansFields.createDate} datetime NOT NULL,
  ${CreditMemoPayMeansFields.updateDate} datetime DEFAULT NULL,
  ${CreditMemoPayMeansFields.torinId} text DEFAULT NULL,
  ${CreditMemoPayMeansFields.lineNum} int NOT NULL,
  ${CreditMemoPayMeansFields.tpmt3Id} text DEFAULT NULL,
  ${CreditMemoPayMeansFields.amount} bigint NOT NULL,
  ${CreditMemoPayMeansFields.tpmt2Id} text DEFAULT NULL,
  ${CreditMemoPayMeansFields.cardNo} varchar(20) DEFAULT NULL,
  ${CreditMemoPayMeansFields.cardHolder} varchar(20) DEFAULT NULL,
  ${CreditMemoPayMeansFields.sisaVoucher} double DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `trin2_torinId_fkey` FOREIGN KEY (`torinId`) REFERENCES `torin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin2_tpmt3Id_fkey` FOREIGN KEY (`tpmt3Id`) REFERENCES `tpmt3` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin2_tpmt2Id_fkey` FOREIGN KEY (`tpmt2Id`) REFERENCES `tpmt2` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableBatchCreditMemo (
  $uuidDefinition,
  ${BatchCreditMemoFields.createDate} datetime NOT NULL,
  ${BatchCreditMemoFields.updateDate} datetime DEFAULT NULL,
  ${BatchCreditMemoFields.trin1Docid} varchar(191) DEFAULT NULL,
  ${BatchCreditMemoFields.toitmId} text DEFAULT NULL,
  ${BatchCreditMemoFields.batchNo} varchar(10) NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `trin3_trin1Docid_fkey` FOREIGN KEY (`trin1Docid`) REFERENCES `trin1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin3_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableUserLogs (
  $uuidDefinition,
  ${UserLogsFields.createDate} datetime NOT NULL,
  ${UserLogsFields.updateDate} datetime DEFAULT NULL,
  ${UserLogsFields.remarks} text,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableMOPAdjustmentHeader (
  $uuidDefinition,
  ${MOPAdjustmentHeaderFields.createDate} datetime NOT NULL,
  ${MOPAdjustmentHeaderFields.updateDate} datetime DEFAULT NULL,
  ${MOPAdjustmentHeaderFields.docNum} varchar(30) NOT NULL,
  ${MOPAdjustmentHeaderFields.docDate} date NOT NULL,
  ${MOPAdjustmentHeaderFields.docTime} time NOT NULL,
  ${MOPAdjustmentHeaderFields.timezone} varchar(200) NOT NULL,
  ${MOPAdjustmentHeaderFields.posted} int NOT NULL,
  ${MOPAdjustmentHeaderFields.postDate} date NOT NULL,
  ${MOPAdjustmentHeaderFields.postTime} time NOT NULL,
  ${MOPAdjustmentHeaderFields.remarks} text,
  ${MOPAdjustmentHeaderFields.tostrId} text DEFAULT NULL,
  ${MOPAdjustmentHeaderFields.sync} int NOT NULL DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tmpad_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableMOPAdjustmentDetail (
  $uuidDefinition,
  ${MOPAdjustmentDetailFields.createDate} datetime NOT NULL,
  ${MOPAdjustmentDetailFields.updateDate} datetime DEFAULT NULL,
  ${MOPAdjustmentDetailFields.tmpadId} text DEFAULT NULL,
  ${MOPAdjustmentDetailFields.tpmt1Id} text DEFAULT NULL,
  ${MOPAdjustmentDetailFields.amount} double NOT NULL,
  ${MOPAdjustmentDetailFields.tpmt3Id} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `mpad1_tmpadId_fkey` FOREIGN KEY (`tmpadId`) REFERENCES `tmpad` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `mpad1_tpmt3Id_fkey` FOREIGN KEY (`tpmt3Id`) REFERENCES `tpmt3` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `mpad1_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableItemProperty (
  $uuidDefinition,
  ${ItemPropertyFields.createDate} datetime NOT NULL,
  ${ItemPropertyFields.updateDate} datetime DEFAULT NULL,
  ${ItemPropertyFields.properties} varchar(30) NOT NULL,
  ${ItemPropertyFields.code} varchar(30) NOT NULL,
  ${ItemPropertyFields.description} varchar(100) NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkat (
  $uuidDefinition,
  ${PromoBertingkatFields.createDate} datetime NOT NULL,
  ${PromoBertingkatFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatFields.promoCode} varchar(30) NOT NULL,
  ${PromoBertingkatFields.description} varchar(200) NOT NULL,
  ${PromoBertingkatFields.startDate} date NOT NULL,
  ${PromoBertingkatFields.endDate} date NOT NULL,
  ${PromoBertingkatFields.startTime} time NOT NULL,
  ${PromoBertingkatFields.endTime} time NOT NULL,
  ${PromoBertingkatFields.remarks} text,
  ${PromoBertingkatFields.statusActive} int NOT NULL,
  ${PromoBertingkatFields.toplnId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `toprp_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkatDetail (
  $uuidDefinition,
  ${PromoBertingkatDetailFields.createDate} datetime NOT NULL,
  ${PromoBertingkatDetailFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatDetailFields.toprpId} text DEFAULT NULL,
  ${PromoBertingkatDetailFields.toitmId} text DEFAULT NULL,
  ${PromoBertingkatDetailFields.promoType} varchar(1) NOT NULL,
  ${PromoBertingkatDetailFields.minQuantity} double NOT NULL,
  ${PromoBertingkatDetailFields.promoValue} double NOT NULL,
  ${PromoBertingkatDetailFields.itemPrice} double DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tprp1_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprp1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkatAssignStore (
  $uuidDefinition,
  ${PromoBertingkatAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoBertingkatAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatAssignStoreFields.toprpId} text DEFAULT NULL,
  ${PromoBertingkatAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoBertingkatAssignStoreFields.holiday} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day1} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day2} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day3} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day4} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day5} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day6} int NOT NULL,
  ${PromoBertingkatAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprp2_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprp2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkatValidDays (
  $uuidDefinition,
  ${PromoBertingkatValidDaysFields.createDate} datetime NOT NULL,
  ${PromoBertingkatValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatValidDaysFields.tprp2Id} text DEFAULT NULL,
  ${PromoBertingkatValidDaysFields.day} int NOT NULL,
  ${PromoBertingkatValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprp3_tprp2Id_fkey` FOREIGN KEY (`tprp2Id`) REFERENCES `tprp2` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkatCustomerGroup (
  $uuidDefinition,
  ${PromoBertingkatCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoBertingkatCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatCustomerGroupFields.toprpId} text DEFAULT NULL,
  ${PromoBertingkatCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprp4_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprp4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkatDefaultPriceLevel (
  $uuidDefinition,
  ${PromoBertingkatDefaultPriceLevelFields.createDate} datetime NOT NULL,
  ${PromoBertingkatDefaultPriceLevelFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatDefaultPriceLevelFields.toprpId} text DEFAULT NULL,
  ${PromoBertingkatDefaultPriceLevelFields.promoType} varchar(1) NOT NULL,
  ${PromoBertingkatDefaultPriceLevelFields.minQuantity} double NOT NULL,
  ${PromoBertingkatDefaultPriceLevelFields.promoValue} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprp8_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBertingkatDefaulValidDays (
  $uuidDefinition,
  ${PromoBertingkatDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoBertingkatDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoBertingkatDefaultValidDaysFields.toprpId} text DEFAULT NULL,
  ${PromoBertingkatDefaultValidDaysFields.day} int NOT NULL,
  ${PromoBertingkatDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprp9_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
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
          docid, createdate, touomId, gtentId, email, username, password,
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
