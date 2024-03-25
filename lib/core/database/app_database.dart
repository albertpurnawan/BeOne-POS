import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:pos_fe/core/database/seeders_data/phir1.dart';
import 'package:pos_fe/core/database/seeders_data/receiptcontents.dart';
import 'package:pos_fe/core/database/seeders_data/tbitm.dart';
import 'package:pos_fe/core/database/seeders_data/tcurr.dart';
import 'package:pos_fe/core/database/seeders_data/tocat.dart';
import 'package:pos_fe/core/database/seeders_data/tocrg.dart';
import 'package:pos_fe/core/database/seeders_data/tocsr.dart';
import 'package:pos_fe/core/database/seeders_data/tocus.dart';
import 'package:pos_fe/core/database/seeders_data/toitm.dart';
import 'package:pos_fe/core/database/seeders_data/topln.dart';
import 'package:pos_fe/core/database/seeders_data/topmt.dart';
import 'package:pos_fe/core/database/seeders_data/topos.dart';
import 'package:pos_fe/core/database/seeders_data/tostr.dart';
import 'package:pos_fe/core/database/seeders_data/touom.dart';
import 'package:pos_fe/core/database/seeders_data/tousr.dart';
import 'package:pos_fe/core/database/seeders_data/tovat.dart';
import 'package:pos_fe/core/database/seeders_data/tphir.dart';
import 'package:pos_fe/core/database/seeders_data/tpln1.dart';
import 'package:pos_fe/core/database/seeders_data/tpln2.dart';
import 'package:pos_fe/core/database/seeders_data/tpln4.dart';
import 'package:pos_fe/core/database/seeders_data/tpmt1.dart';
import 'package:pos_fe/core/database/seeders_data/tpmt3.dart';
import 'package:pos_fe/core/database/seeders_data/tsitm.dart';
import 'package:pos_fe/features/login/data/data_sources/local/user_auth_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/assign_price_member_per_store_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/authorization_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/cash_register_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/country_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/credit_card_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/customer_cst_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/customer_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/customer_group_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/employee_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/invoice_detail_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/invoice_header_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_barcode_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_by_store_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_category_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_picture_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_remark_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/means_of_payment_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/mop_by_store_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/pay_means_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/payment_type_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/pos_parameter_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/preferred_vendor_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/price_by_item_barcode_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/price_by_item_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/pricelist_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/pricelist_period_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/product_hierarchy_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/product_hierarchy_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/province_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/store_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/tax_master_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/uom_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/user_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/user_roles_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/vendor_daro.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/vendor_group_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/zipcode_dao.dart';
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
import 'package:pos_fe/features/sales/data/models/customer_cst.dart';
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
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_buy_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_get_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_coupon_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_detail.dart';
import 'package:pos_fe/features/sales/data/models/promo_credit_card_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_detail.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_gwp_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_buy.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_package_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_default_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_voucher_valid_days.dart';
import 'package:pos_fe/features/sales/data/models/province.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/data/models/user_logs.dart';
import 'package:pos_fe/features/sales/data/models/user_role.dart';
import 'package:pos_fe/features/sales/data/models/vendor.dart';
import 'package:pos_fe/features/sales/data/models/vendor_group.dart';
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
import 'package:pos_fe/features/settings/data/data_sources/local/receipt_content_dao.dart';
import 'package:pos_fe/features/settings/data/models/receipt_content.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  late final databaseVersion = 1;
  final _databaseName = "pos_fe.db";

  Database? _database;

  late final ReceiptContentDao receiptContentDao;
  late final UserAuthDao userAuthDao;
  late final AuthorizationDao authorizationDao;
  late final AssignPriceMemberPerStoreDao assignPriceMemberPerStoreDao;
  late final ItemsDao itemsDao;
  late final CurrencyDao currencyDao;
  late final CountryDao countryDao;
  late final ProvinceDao provinceDao;
  late final ZipcodeDao zipcodeDao;
  late final EmployeeDao employeeDao;
  late final TaxMasterDao taxMasterDao;
  late final CreditCardDao creditCardDao;
  late final ProductHierarchyDao productHierarchyDao;
  late final ProductHierarchyMasterDao productHierarchyMasterDao;
  late final ItemCategoryDao itemCategoryDao;
  late final UomDao uomDao;
  late final ItemMasterDao itemMasterDao;
  late final ItemPictureDao itemPictureDao;
  late final PricelistDao pricelistDao;
  late final CashRegisterDao cashRegisterDao;
  late final PricelistPeriodDao pricelistPeriodDao;
  late final ItemBarcodeDao itemBarcodeDao;
  late final ItemRemarkDao itemRemarkDao;
  late final ItemByStoreDao itemByStoreDao;
  late final PriceByItemDao priceByItemDao;
  late final PriceByItemBarcodeDao priceByItemBarcodeDao;
  late final StoreMasterDao storeMasterDao;
  late final CustomerGroupDao customerGroupDao;
  late final CustomerDao customerDao;
  late final CustomerCstDao customerCstDao;
  late final PaymentTypeDao paymentTypeDao;
  late final MeansOfPaymentDao meansOfPaymentDao;
  late final MOPByStoreDao mopByStoreDao;
  late final UserRoleDao userRoleDao;
  late final InvoiceHeaderDao invoiceHeaderDao;
  late final InvoiceDetailDao invoiceDetailDao;
  late final POSParameterDao posParameterDao;
  late final UserDao userDao;
  late final PayMeansDao payMeansDao;
  late final VendorGroupDao vendorGroupDao;
  late final VendorDao vendorDao;
  late final PreferredVendorDao preferredVendorDao;

  AppDatabase._init();

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

  Future<void> emptyDb() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);
      await databaseFactory.deleteDatabase(path);
      _database = null;
      print("Database Dropped before Updated");
      await _initDB(path);
      print("Database reinisiated");
    } catch (error) {
      print("Error emptying database: $error");
    }
  }

  Future _onConfigure(Database db) async {
    await db.execute('''
PRAGMA foreign_keys = ON;
''');
  }

  Future<void> _injectDao() async {
    receiptContentDao = ReceiptContentDao(_database!);
    userAuthDao = UserAuthDao(_database!);
    authorizationDao = AuthorizationDao(_database!);
    assignPriceMemberPerStoreDao = AssignPriceMemberPerStoreDao(_database!);
    itemsDao = ItemsDao(_database!);
    currencyDao = CurrencyDao(_database!);
    countryDao = CountryDao(_database!);
    provinceDao = ProvinceDao(_database!);
    zipcodeDao = ZipcodeDao(_database!);
    employeeDao = EmployeeDao(_database!);
    itemCategoryDao = ItemCategoryDao(_database!);
    taxMasterDao = TaxMasterDao(_database!);
    creditCardDao = CreditCardDao(_database!);
    productHierarchyDao = ProductHierarchyDao(_database!);
    productHierarchyMasterDao = ProductHierarchyMasterDao(_database!);
    userRoleDao = UserRoleDao(_database!);
    uomDao = UomDao(_database!);
    itemMasterDao = ItemMasterDao(_database!);
    itemPictureDao = ItemPictureDao(_database!);
    pricelistDao = PricelistDao(_database!);
    cashRegisterDao = CashRegisterDao(_database!);
    pricelistPeriodDao = PricelistPeriodDao(_database!);
    itemBarcodeDao = ItemBarcodeDao(_database!);
    itemRemarkDao = ItemRemarkDao(_database!);
    itemByStoreDao = ItemByStoreDao(_database!);
    priceByItemDao = PriceByItemDao(_database!);
    priceByItemBarcodeDao = PriceByItemBarcodeDao(_database!);
    storeMasterDao = StoreMasterDao(_database!);
    customerGroupDao = CustomerGroupDao(_database!);
    customerDao = CustomerDao(_database!);
    customerCstDao = CustomerCstDao(_database!);
    paymentTypeDao = PaymentTypeDao(_database!);
    meansOfPaymentDao = MeansOfPaymentDao(_database!);
    mopByStoreDao = MOPByStoreDao(_database!);
    invoiceHeaderDao = InvoiceHeaderDao(_database!);
    invoiceDetailDao = InvoiceDetailDao(_database!);
    userDao = UserDao(_database!);
    posParameterDao = POSParameterDao(_database!);
    payMeansDao = PayMeansDao(_database!);
    vendorGroupDao = VendorGroupDao(_database!);
    vendorDao = VendorDao(_database!);
    preferredVendorDao = PreferredVendorDao(_database!);

    receiptContentDao.bulkCreate(
        data: receiptcontents.map((e) {
      return ReceiptContentModel.fromMap(e);
    }).toList());
    // currencyDao.bulkCreate(
    //     data: tcurr.map((e) => CurrencyModel.fromMap(e)).toList());
    // itemCategoryDao.bulkCreate(
    //     data: tocat.map((e) => ItemCategoryModel.fromMap(e)).toList());
    // taxMasterDao.bulkCreate(
    //     data: tovat.map((e) => TaxMasterModel.fromMap(e)).toList());
    // productHierarchyDao.bulkCreate(
    //     data: tphir.map((e) => ProductHierarchyModel.fromMap(e)).toList());
    // productHierarchyMasterDao.bulkCreate(
    //     data:
    //         phir1.map((e) => ProductHierarchyMasterModel.fromMap(e)).toList());
    // pricelistDao.bulkCreate(
    //     data: topln.map((e) => PricelistModel.fromMap(e)).toList());
    // pricelistPeriodDao.bulkCreate(
    //     data: tpln1.map((e) => PricelistPeriodModel.fromMap(e)).toList());
    // uomDao.bulkCreate(data: touom.map((e) => UomModel.fromMap(e)).toList());
    // storeMasterDao.bulkCreate(
    //     data: tostr.map((e) => StoreMasterModel.fromMap(e)).toList());
    // itemMasterDao.bulkCreate(
    //     data: toitm.map((e) => ItemMasterModel.fromMap(e)).toList());
    // itemBarcodeDao.bulkCreate(
    //     data: tbitm.map((e) => ItemBarcodeModel.fromMap(e)).toList());
    // itemByStoreDao.bulkCreate(
    //     data: tsitm.map((e) => ItemByStoreModel.fromMap(e)).toList());
    // priceByItemDao.bulkCreate(
    //     data: tpln2.map((e) => PriceByItemModel.fromMap(e)).toList());
    // priceByItemBarcodeDao.bulkCreate(
    //     data: tpln4.map((e) => PriceByItemBarcodeModel.fromMap(e)).toList());
    // customerGroupDao.bulkCreate(
    //     data: tocrg.map((e) => CustomerGroupModel.fromMap(e)).toList());
    // customerDao.bulkCreate(
    //     data: tocus.map((e) => CustomerModel.fromMap(e)).toList());
    // paymentTypeDao.bulkCreate(
    //     data: topmt.map((e) => PaymentTypeModel.fromMap(e)).toList());
    // meansOfPaymentDao.bulkCreate(
    //     data: tpmt1.map((e) => MeansOfPaymentModel.fromMap(e)).toList());
    // mopByStoreDao.bulkCreate(
    //     data: tpmt3.map((e) => MOPByStoreModel.fromMap(e)).toList());
    // userDao.bulkCreate(data: tousr.map((e) => UserModel.fromMap(e)).toList());
    // cashRegisterDao.bulkCreate(
    //     data: tocsr.map((e) => CashRegisterModel.fromMap(e)).toList());
    // posParameterDao.bulkCreate(
    //     data: topos.map((e) => POSParameterModel.fromMap(e)).toList());
  }

  Future<void> _refreshItemsTable() async {
    await _database!.execute("""
DELETE FROM items
""");
    await _database!.execute("""
INSERT INTO items (itemname, itemcode, barcode, price, toitmId, tbitmId, tpln2Id)
SELECT  i.itemname, i.itemcode, bc.barcode, b.price, p.toitmId, b.tbitmId,  b.tpln2Id
FROM (
  SELECT docid AS toplnId, pp.tpln1Id, pr.tpln2Id, pr.toitmId, DATETIME(pp.tpln1createdate) AS tpln1createdate, MAX(DATETIME(pp.tpln1createdate)) AS latestPrice
  FROM topln AS pl
   INNER JOIN
    (
    SELECT docid AS tpln1Id, toplnId, createdate AS tpln1createdate
    FROM tpln1
    WHERE DATETIME(tpln1.periodfr) <= DATETIME() <= DATETIME(tpln1.periodto)
    ) AS pp
   ON pl.docid = pp.toplnId
   
   INNER JOIN
   (
      SELECT docid AS tpln2Id, tpln1Id, toitmId
      FROM tpln2
   ) AS pr
   ON pr.tpln1Id = pp.tpln1Id
  
  WHERE pl.tcurrId = 'cff4edc0-7612-4681-8d7c-c90e9e97c6dc'
  GROUP BY pr.toitmId
) as p
INNER JOIN 
  (SELECT tbitmId, price, tpln2Id
  FROM tpln4) as b
ON p.tpln2Id = b.tpln2Id
INNER JOIN
 (SELECT docid, barcode
 FROM tbitm) as bc
 ON bc.docid = b.tbitmId
INNER JOIN (
  SELECT docid, itemcode, itemname, touomId
  FROM toitm
) as i
ON i.docid = p.toitmId
INNER JOIN (
  SELECT docid AS touomId, uomcode
  FROM touom
) as u
ON u.touomId = i.touomId
""");
  }

  static Future<AppDatabase> init() async {
    final appDatabase = AppDatabase._init();
    await appDatabase.getDB();
    await appDatabase._injectDao();
    await appDatabase._refreshItemsTable();

    return appDatabase;
  }

  Future _createDB(Database db, int version) async {
    try {
      const idTypeAndConstraints = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const uuidDefinition = '`docid` TEXT PRIMARY KEY';
      const createdAtDefinition = 'createdat TEXT DEFAULT CURRENT_TIMESTAMP';

      await db.transaction((txn) async {
        await txn.execute("""
CREATE TABLE $tableReceiptContents (
  id $idTypeAndConstraints,
  ${ReceiptContentFields.row} INTEGER NOT NULL,
  ${ReceiptContentFields.content} STRING NOT NULL,
  ${ReceiptContentFields.fontSize} INTEGER DEFAULT 1,
  ${ReceiptContentFields.isBold} INTEGER DEFAULT 0,
  ${ReceiptContentFields.alignment} INTEGER DEFAULT 0,
  ${ReceiptContentFields.customValue} STRING,
  ${ReceiptContentFields.imageBytes} BLOB
);
""");

        await txn.execute("""
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
  ${CountryFields.phoneCode} varchar(5) NOT NULL,
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
  ${ZipCodeFields.urban} varchar(100) DEFAULT NULL,
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
CREATE TABLE $tableItemMasters (
  $uuidDefinition,
  ${ItemMasterFields.createDate} datetime NOT NULL,
  ${ItemMasterFields.updateDate} datetime DEFAULT NULL,
  ${ItemMasterFields.itemCode} varchar(30) NOT NULL,
  ${ItemMasterFields.itemName} varchar(100) NOT NULL,
  ${ItemMasterFields.invItem} int NOT NULL,
  ${ItemMasterFields.tocatId} text DEFAULT NULL,
  ${ItemMasterFields.touomId} text DEFAULT NULL,
  ${ItemMasterFields.minStock} double NOT NULL,
  ${ItemMasterFields.maxStock} double NOT NULL,
  ${ItemMasterFields.includeTax} int NOT NULL,
  ${ItemMasterFields.remarks} text,
  ${ItemMasterFields.statusActive} int NOT NULL,
  ${ItemMasterFields.activated} int NOT NULL,
  ${ItemMasterFields.isBatch} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.sync} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.internalCode_1} varchar(100) DEFAULT '',
  ${ItemMasterFields.internalCode_2} varchar(100) DEFAULT '',
  ${ItemMasterFields.property1} text DEFAULT NULL,
  ${ItemMasterFields.property2} text DEFAULT NULL,
  ${ItemMasterFields.property3} text DEFAULT NULL,
  ${ItemMasterFields.property4} text DEFAULT NULL,
  ${ItemMasterFields.property5} text DEFAULT NULL,
  ${ItemMasterFields.property6} text DEFAULT NULL,
  ${ItemMasterFields.property7} text DEFAULT NULL,
  ${ItemMasterFields.property8} text DEFAULT NULL,
  ${ItemMasterFields.property9} text DEFAULT NULL,
  ${ItemMasterFields.property10} text DEFAULT NULL,
  ${ItemMasterFields.openPrice} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.popItem} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.bpom} varchar(20) DEFAULT '',
  ${ItemMasterFields.expDate} varchar(6) DEFAULT '',
  ${ItemMasterFields.margin} double DEFAULT '0',
  ${ItemMasterFields.memberDiscount} int DEFAULT '1',
  ${ItemMasterFields.multiplyOrder} int DEFAULT '1',
  ${ItemMasterFields.syncCRM} int NOT NULL DEFAULT '0',
  ${ItemMasterFields.mergeQuantity} int NOT NULL DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `toitm_property10_fkey` FOREIGN KEY (`property10`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property1_fkey` FOREIGN KEY (`property1`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property2_fkey` FOREIGN KEY (`property2`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property3_fkey` FOREIGN KEY (`property3`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property4_fkey` FOREIGN KEY (`property4`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property5_fkey` FOREIGN KEY (`property5`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property6_fkey` FOREIGN KEY (`property6`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property7_fkey` FOREIGN KEY (`property7`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property8_fkey` FOREIGN KEY (`property8`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitm_property9_fkey` FOREIGN KEY (`property9`) REFERENCES `tprop` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
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
  $createdAtDefinition,
  CONSTRAINT `tpln2_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln2_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln2_tpln1Id_fkey` FOREIGN KEY (`tpln1Id`) REFERENCES `tpln1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
// ${PriceByItemFields.purchasePrice} double DEFAULT '0',
//   ${PriceByItemFields.calculatedPrice} double DEFAULT '0',
//   ${PriceByItemFields.marginPercentage} double DEFAULT '0',
//   ${PriceByItemFields.marginValue} double DEFAULT '0',
//   ${PriceByItemFields.costPrice} double DEFAULT '0',
//   ${PriceByItemFields.afterRounding} double DEFAULT '0',
//   ${PriceByItemFields.beforeRounding} double DEFAULT '0',
//   ${PriceByItemFields.roundingDiff} double DEFAULT '0',

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
  ${EmployeeFields.city} varchar(100) NOT NULL,
  ${EmployeeFields.remarks} text,
  ${EmployeeFields.toprvId} text DEFAULT NULL,
  ${EmployeeFields.tocryId} text DEFAULT NULL,
  ${EmployeeFields.tozcdId} text DEFAULT NULL,
  ${EmployeeFields.idCard} varchar(30) NOT NULL,
  ${EmployeeFields.gender} varchar(1) NOT NULL,
  ${EmployeeFields.birthdate} date NOT NULL,
  ${EmployeeFields.photo} blob,
  ${EmployeeFields.joinDate} date NOT NULL,
  ${EmployeeFields.resignDate} date DEFAULT NULL,
  ${EmployeeFields.statusActive} int NOT NULL,
  ${EmployeeFields.activated} int NOT NULL,
  ${EmployeeFields.empDept} varchar(200) NOT NULL,
  ${EmployeeFields.empTitle} varchar(200) NOT NULL,
  ${EmployeeFields.empWorkplace} varchar(200) NOT NULL,
  ${EmployeeFields.empDebt} double NOT NULL,
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
  CONSTRAINT `toaut_tousrId_fkey` FOREIGN KEY (`tousrId`) REFERENCES `tousr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
        // ${AuthorizationFields.tformId} text DEFAULT NULL,
        //CONSTRAINT `toaut_tformId_fkey` FOREIGN KEY (`tformId`) REFERENCES `tform` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,

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
CREATE TABLE $tableVendorGroup (
  $uuidDefinition,
  ${VendorGroupFields.createDate} datetime NOT NULL,
  ${VendorGroupFields.updateDate} datetime DEFAULT NULL,
  ${VendorGroupFields.vendorGroupCode} varchar(30) NOT NULL,
  ${VendorGroupFields.description} varchar(100) NOT NULL,
  ${VendorGroupFields.maxDiscount} double NOT NULL,
  ${VendorGroupFields.statusActive} int NOT NULL,
  ${VendorGroupFields.activated} int NOT NULL,
  ${VendorGroupFields.sync} int NOT NULL DEFAULT '0',
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tableVendor (
  $uuidDefinition,
  ${VendorFields.createDate} datetime NOT NULL,
${VendorFields.updateDate} datetime DEFAULT NULL,
  ${VendorFields.vendCode} varchar(191) NOT NULL,
  ${VendorFields.vendName} varchar(100) NOT NULL,
  ${VendorFields.tovdgId} text DEFAULT NULL,
  ${VendorFields.remarks} text,
  $createdAtDefinition,
  CONSTRAINT `toven_tovdgId_fkey` FOREIGN KEY (`tovdgId`) REFERENCES `tovdg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

// ${VendorFields.idCard} varchar(30) NOT NULL,
//   ${VendorFields.taxNo} varchar(50) NOT NULL,
//   ${VendorFields.gender} varchar(1) NOT NULL,
//   ${VendorFields.birthdate} date DEFAULT NULL,
//   ${VendorFields.addr1} varchar(200) NOT NULL,
//   ${VendorFields.addr2} varchar(200) DEFAULT NULL,
//   ${VendorFields.addr3} varchar(200) DEFAULT NULL,
//   ${VendorFields.city} varchar(100) NOT NULL,
//   ${VendorFields.toprvId} text DEFAULT NULL,
//   ${VendorFields.tocryId} text DEFAULT NULL,
//   ${VendorFields.tozcdId} text DEFAULT NULL,
//   ${VendorFields.phone} varchar(20) NOT NULL,
//   ${VendorFields.email} varchar(100) NOT NULL,
//   ${VendorFields.toptrId} text DEFAULT NULL,
//   ${VendorFields.toplnId} text DEFAULT NULL,
//   ${VendorFields.maxDiscount} double NOT NULL,
//   ${VendorFields.statusActive} int NOT NULL,
//   ${VendorFields.activated} int NOT NULL,
//   ${VendorFields.tohemId} text DEFAULT NULL,
//   ${VendorFields.sync} int NOT NULL DEFAULT '0',
//   CONSTRAINT `toven_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
//   CONSTRAINT `toven_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
//   CONSTRAINT `toven_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
//   CONSTRAINT `toven_toptrId_fkey` FOREIGN KEY (`toptrId`) REFERENCES `toptr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
//   CONSTRAINT `toven_tozcdId_fkey` FOREIGN KEY (`tozcdId`) REFERENCES `tozcd` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
//   CONSTRAINT `toven_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE

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
  ${CustomerCstFields.createDate} datetime NOT NULL,
  ${CustomerCstFields.updateDate} datetime DEFAULT NULL,
  ${CustomerCstFields.custCode} varchar(191) NOT NULL,
  ${CustomerCstFields.custName} varchar(100) NOT NULL,
  ${CustomerCstFields.tocrgId} text DEFAULT NULL,
  ${CustomerCstFields.phone} varchar(20) NOT NULL,
  ${CustomerCstFields.email} varchar(100) NOT NULL,
  ${CustomerCstFields.taxNo} varchar(50) NOT NULL,
  ${CustomerCstFields.maxDiscount} double NOT NULL,
  ${CustomerCstFields.toplnId} text DEFAULT NULL,
  ${CustomerCstFields.joinDate} datetime DEFAULT NULL,
  ${CustomerCstFields.isEmployee} int NOT NULL DEFAULT '0',
  ${CustomerCstFields.tohemId} text DEFAULT NULL,
  ${CustomerCstFields.docid_crm} text DEFAULT NULL,
  ${CustomerCstFields.statusActive} int NOT NULL,
  ${CustomerCstFields.activated} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tocus_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
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
  ${StoreMasterFields.addr1} varchar(200) DEFAULT NULL,
  ${StoreMasterFields.addr2} varchar(200) DEFAULT NULL,
  ${StoreMasterFields.addr3} varchar(200) DEFAULT NULL,
  ${StoreMasterFields.city} varchar(100) NOT NULL,
  ${StoreMasterFields.remarks} text DEFAULT NULL,
  ${StoreMasterFields.toprvId} text DEFAULT NULL,
  ${StoreMasterFields.tocryId} text DEFAULT NULL,
  ${StoreMasterFields.tozcdId} text DEFAULT NULL,
  ${StoreMasterFields.tohemId} text DEFAULT NULL,
  ${StoreMasterFields.sqm} double NOT NULL,
  ${StoreMasterFields.tcurrId} text DEFAULT NULL,
  ${StoreMasterFields.toplnId} text DEFAULT NULL,
  ${StoreMasterFields.storePic} blob,
  ${StoreMasterFields.tovatId} text DEFAULT NULL,
  ${StoreMasterFields.storeOpening} date NOT NULL,
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
  $createdAtDefinition,
  CONSTRAINT `tostr_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tocryId_fkey` FOREIGN KEY (`tocryId`) REFERENCES `tocry` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_toprvId_fkey` FOREIGN KEY (`toprvId`) REFERENCES `toprv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tostr_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
// CONSTRAINT `tostr_credittaxcodeId_fkey` FOREIGN KEY (`credittaxcodeId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,

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
  ${UserFields.userType} int DEFAULT NULL,
  ${UserFields.tostrId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tousr_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
        // CONSTRAINT `tousr_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
        // CONSTRAINT `tousr_torolId_fkey` FOREIGN KEY (`torolId`) REFERENCES `torol` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,

        await txn.execute('''
CREATE TABLE $tableItems (
${ItemFields.id} $idTypeAndConstraints,
${ItemFields.itemName} TEXT NOT NULL,
${ItemFields.itemCode} TEXT NOT NULL,
${ItemFields.barcode} TEXT NOT NULL,
${ItemFields.price} DOUBLE NOT NULL,
${ItemFields.toitmId} TEXT NOT NULL,
${ItemFields.tbitmId} TEXT NOT NULL,
${ItemFields.tpln2Id} TEXT NOT NULL,
CONSTRAINT `items_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT `items_tbitmId_fkey` FOREIGN KEY (`tbitmId`) REFERENCES `tbitm` (`docid`) ON DELETE NO ACTION ON UPDATE CASCADE,
CONSTRAINT `items_tpln2Id_fkey` FOREIGN KEY (`tpln2Id`) REFERENCES `tpln2` (`docid`) ON DELETE NO ACTION ON UPDATE CASCADE
)
''');

//         await txn.execute('''
// INSERT INTO $tableItems (itemname, itemcode, barcode, price, toitmId, tbitmId, tpln2Id)
// VALUES
//   ( "Bellamys Organic Apple & Fig Oatmeal 120 Gr", "9466012790015", "001", 120000, "db14e594-42d9-44cd-a96d-e4eab0ad1718", "1da2a896-5b24-470f-881c-dd57c316ce70", "652c7e41-86e4-4559-b1e9-4b840624b386")
// ''');

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
  FOREIGN KEY (moitm_id) REFERENCES items (_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (receipt_id) REFERENCES receipt (id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)""");

        await txn.execute("""
CREATE TABLE $tableMOPByStore (
  $uuidDefinition,
  ${MOPByStoreFields.createDate} datetime NOT NULL,
  ${MOPByStoreFields.updateDate} datetime DEFAULT NULL,
  ${MOPByStoreFields.tpmt1Id} text DEFAULT NULL,
  ${MOPByStoreFields.tostrId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tpmt3_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpmt3_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tpln3_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tpln3_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tocsr_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
  CONSTRAINT `tocsr_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tcsr1_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcsr1_tousrId_fkey` FOREIGN KEY (`tousrId`) REFERENCES `tousr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcsr1_openedbyId_fkey` FOREIGN KEY (`openedbyId`) REFERENCES `tousr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tcsr1_closedbyId_fkey` FOREIGN KEY (`closedbyId`) REFERENCES `tousr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tobnk_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `toitt_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitt_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toitt_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `titt1_toittId_fkey` FOREIGN KEY (`toittId`) REFERENCES `toitt` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `titt1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `titt1_touomId_fkey` FOREIGN KEY (`touomId`) REFERENCES `touom` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `titt1_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `thld1_tohldId_fkey` FOREIGN KEY (`tohldId`) REFERENCES `tohld` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tableInvoiceHeader (
  $uuidDefinition,
  ${InvoiceHeaderFields.createDate} datetime DEFAULT NULL,
  ${InvoiceHeaderFields.updateDate} datetime DEFAULT NULL,
  ${InvoiceHeaderFields.tostrId} text DEFAULT NULL,
  ${InvoiceHeaderFields.docnum} varchar(30) NOT NULL,
  ${InvoiceHeaderFields.orderNo} int NOT NULL,
  ${InvoiceHeaderFields.tocusId} text DEFAULT NULL,
  ${InvoiceHeaderFields.tohemId} text DEFAULT NULL,
  ${InvoiceHeaderFields.transDate} text DEFAULT CURRENT_TIMESTAMP,
  ${InvoiceHeaderFields.transTime} text DEFAULT CURRENT_TIMESTAMP,
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
  CONSTRAINT `toinv_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toinv_tocusId_fkey` FOREIGN KEY (`tocusId`) REFERENCES `tocus` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `toinv_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
        // CONSTRAINT `toinv_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
        // CONSTRAINT `toinv_toinvTohemId_fkey` FOREIGN KEY (`toinvTohemId`) REFERENCES `tohem` (`id`) ON DELETE SET NULL ON UPDATE CASCADE

        await txn.execute("""
CREATE TABLE $tableInvoiceDetail (
  $uuidDefinition,
  ${InvoiceDetailFields.createDate} datetime DEFAULT NULL,
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
  CONSTRAINT `tinv1_toinvId_fkey` FOREIGN KEY (`toinvId`) REFERENCES `toinv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tinv1_tbitmId_fkey` FOREIGN KEY (`tbitmId`) REFERENCES `tbitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");
        // CONSTRAINT `tinv1_tovenId_fkey` FOREIGN KEY (`tovenId`) REFERENCES `toven` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,

        await txn.execute("""
CREATE TABLE $tablePayMeans (
  $uuidDefinition,
  ${PayMeansFields.createDate} datetime DEFAULT NULL,
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
  CONSTRAINT `tinv2_toinvId_fkey` FOREIGN KEY (`toinvId`) REFERENCES `toinv` (`docid`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tinv2_tpmt3Id_fkey` FOREIGN KEY (`tpmt3Id`) REFERENCES `tpmt3` (`docid`) ON DELETE RESTRICT ON UPDATE CASCADE
)
""");
        // CONSTRAINT `tinv2_tpmt2Id_fkey` FOREIGN KEY (`tpmt2Id`) REFERENCES `tpmt2` (`id`) ON DELETE SET NULL ON UPDATE CASCADE

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
  CONSTRAINT `tinv3_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tinv4_toinvId_fkey` FOREIGN KEY (`toinvId`) REFERENCES `toinv` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `torin_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_tocusId_fkey` FOREIGN KEY (`tocusId`) REFERENCES `tocus` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_tohemId_fkey` FOREIGN KEY (`tohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `torin_torinTohemId_fkey` FOREIGN KEY (`torinTohemId`) REFERENCES `tohem` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `trin1_torinId_fkey` FOREIGN KEY (`torinId`) REFERENCES `torin` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_tovenId_fkey` FOREIGN KEY (`tovenId`) REFERENCES `toven` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin1_tbitmId_fkey` FOREIGN KEY (`tbitmId`) REFERENCES `tbitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `trin2_torinId_fkey` FOREIGN KEY (`torinId`) REFERENCES `torin` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin2_tpmt3Id_fkey` FOREIGN KEY (`tpmt3Id`) REFERENCES `tpmt3` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `trin2_tpmt2Id_fkey` FOREIGN KEY (`tpmt2Id`) REFERENCES `tpmt2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `trin3_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tmpad_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `mpad1_tmpadId_fkey` FOREIGN KEY (`tmpadId`) REFERENCES `tmpad` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `mpad1_tpmt3Id_fkey` FOREIGN KEY (`tpmt3Id`) REFERENCES `tpmt3` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `mpad1_tpmt1Id_fkey` FOREIGN KEY (`tpmt1Id`) REFERENCES `tpmt1` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `toprp_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tprp1_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprp1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tprp2_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprp2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tprp3_tprp2Id_fkey` FOREIGN KEY (`tprp2Id`) REFERENCES `tprp2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tprp4_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprp4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tprp8_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
  CONSTRAINT `tprp9_toprpId_fkey` FOREIGN KEY (`toprpId`) REFERENCES `toprp` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCreditCard (
  $uuidDefinition,
  ${PromoCreditCardFields.createDate} datetime NOT NULL,
  ${PromoCreditCardFields.updateDate} datetime DEFAULT NULL,
  ${PromoCreditCardFields.promoCode} varchar(30) NOT NULL,
  ${PromoCreditCardFields.description} varchar(200) NOT NULL,
  ${PromoCreditCardFields.startDate} date NOT NULL,
  ${PromoCreditCardFields.endDate} date NOT NULL,
  ${PromoCreditCardFields.startTime} time NOT NULL,
  ${PromoCreditCardFields.endTime} time NOT NULL,
  ${PromoCreditCardFields.remarks} text,
  ${PromoCreditCardFields.minPurchase} double NOT NULL,
  ${PromoCreditCardFields.discPct} double NOT NULL,
  ${PromoCreditCardFields.discValue} double NOT NULL,
  ${PromoCreditCardFields.statusActive} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCreditCardDetail (
  $uuidDefinition,
  ${PromoCreditCardDetailFields.createDate} datetime NOT NULL,
  ${PromoCreditCardDetailFields.updateDate} datetime DEFAULT NULL,
  ${PromoCreditCardDetailFields.toprcId} text DEFAULT NULL,
  ${PromoCreditCardDetailFields.tpmt2Id} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprc1_toprcId_fkey` FOREIGN KEY (`toprcId`) REFERENCES `toprc` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprc1_tpmt2Id_fkey` FOREIGN KEY (`tpmt2Id`) REFERENCES `tpmt2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCreditCardAssignStore (
  $uuidDefinition,
  ${PromoCreditCardAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoCreditCardAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoCreditCardAssignStoreFields.toprcId} text DEFAULT NULL,
  ${PromoCreditCardAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoCreditCardAssignStoreFields.holiday} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day1} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day2} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day3} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day4} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day5} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day6} int NOT NULL,
  ${PromoCreditCardAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprc2_toprcId_fkey` FOREIGN KEY (`toprcId`) REFERENCES `toprc` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprc2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCreditCardValidDays (
  $uuidDefinition,
  ${PromoCreditCardValidDaysFields.createDate} datetime NOT NULL,
  ${PromoCreditCardValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoCreditCardValidDaysFields.tprc2Id} text DEFAULT NULL,
  ${PromoCreditCardValidDaysFields.day} int NOT NULL,
  ${PromoCreditCardValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprc3_tprc2Id_fkey` FOREIGN KEY (`tprc2Id`) REFERENCES `tprc2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCreditCardCustomerGroup (
  $uuidDefinition,
  ${PromoCreditCardCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoCreditCardCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoCreditCardCustomerGroupFields.toprcId} text DEFAULT NULL,
  ${PromoCreditCardCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprc4_toprcId_fkey` FOREIGN KEY (`toprcId`) REFERENCES `toprc` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprc4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCreditCardDefaultValidDays (
  $uuidDefinition,
  ${PromoCreditCardDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoCreditCardDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoCreditCardDefaultValidDaysFields.toprcId} bigint DEFAULT NULL,
  ${PromoCreditCardDefaultValidDaysFields.day} int NOT NULL,
  ${PromoCreditCardDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprc9_toprcId_fkey` FOREIGN KEY (`toprcId`) REFERENCES `toprc` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYHeader (
  $uuidDefinition,
  ${PromoBuyXGetYHeaderFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYHeaderFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYHeaderFields.promoCode} varchar(30) NOT NULL,
  ${PromoBuyXGetYHeaderFields.description} varchar(200) NOT NULL,
  ${PromoBuyXGetYHeaderFields.startDate} date NOT NULL,
  ${PromoBuyXGetYHeaderFields.endDate} date NOT NULL,
  ${PromoBuyXGetYHeaderFields.startTime} time NOT NULL,
  ${PromoBuyXGetYHeaderFields.endTime} time NOT NULL,
  ${PromoBuyXGetYHeaderFields.remarks} text,
  ${PromoBuyXGetYHeaderFields.minPurchase} double NOT NULL,
  ${PromoBuyXGetYHeaderFields.buyCondition} int NOT NULL,
  ${PromoBuyXGetYHeaderFields.minBuy} double NOT NULL,
  ${PromoBuyXGetYHeaderFields.maxMultiply} double NOT NULL,
  ${PromoBuyXGetYHeaderFields.getCondition} int NOT NULL,
  ${PromoBuyXGetYHeaderFields.maxGet} double NOT NULL,
  ${PromoBuyXGetYHeaderFields.statusActive} int NOT NULL,
  ${PromoBuyXGetYHeaderFields.toplnId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `toprb_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYBuyCondition (
  $uuidDefinition,
  ${PromoBuyXGetYBuyConditionFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYBuyConditionFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYBuyConditionFields.toprbId} text DEFAULT NULL,
  ${PromoBuyXGetYBuyConditionFields.toitmId} text DEFAULT NULL,
  ${PromoBuyXGetYBuyConditionFields.quantity} double NOT NULL,
  ${PromoBuyXGetYBuyConditionFields.itemPrice} double DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tprb1_toprbId_fkey` FOREIGN KEY (`toprbId`) REFERENCES `toprb` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprb1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYAssignStore (
  $uuidDefinition,
  ${PromoBuyXGetYAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYAssignStoreFields.toprbId} text DEFAULT NULL,
  ${PromoBuyXGetYAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoBuyXGetYAssignStoreFields.holiday} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day1} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day2} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day3} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day4} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day5} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day6} int NOT NULL,
  ${PromoBuyXGetYAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprb2_toprbId_fkey` FOREIGN KEY (`toprbId`) REFERENCES `toprb` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprb2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYValidDays (
  $uuidDefinition,
  ${PromoBuyXGetYValidDaysFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYValidDaysFields.tprb2Id} text DEFAULT NULL,
  ${PromoBuyXGetYValidDaysFields.day} int NOT NULL,
  ${PromoBuyXGetYValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprb3_tprb2Id_fkey` FOREIGN KEY (`tprb2Id`) REFERENCES `tprb2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYGetCondition (
  $uuidDefinition,
  ${PromoBuyXGetYGetConditionFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYGetConditionFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYGetConditionFields.toprbId} text DEFAULT NULL,
  ${PromoBuyXGetYGetConditionFields.toitmId} text DEFAULT NULL,
  ${PromoBuyXGetYGetConditionFields.quantity} double NOT NULL,
  ${PromoBuyXGetYGetConditionFields.sellingPrice} double NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprb4_toprbId_fkey` FOREIGN KEY (`toprbId`) REFERENCES `toprb` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprb4_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYCustomerGroup (
  $uuidDefinition,
  ${PromoBuyXGetYCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYCustomerGroupFields.toprbId} text DEFAULT NULL,
  ${PromoBuyXGetYCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprb5_toprbId_fkey` FOREIGN KEY (`toprbId`) REFERENCES `toprb` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprb5_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoBuyXGetYDefaultValidDays (
  $uuidDefinition,
  ${PromoBuyXGetYDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoBuyXGetYDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoBuyXGetYDefaultValidDaysFields.toprbId} text DEFAULT NULL,
  ${PromoBuyXGetYDefaultValidDaysFields.day} int NOT NULL,
  ${PromoBuyXGetYDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprb9_toprbId_fkey` FOREIGN KEY (`toprbId`) REFERENCES `toprb` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoPackageHeader (
  $uuidDefinition,
  ${PromoPackageHeaderFields.createDate} datetime NOT NULL,
  ${PromoPackageHeaderFields.updateDate} datetime DEFAULT NULL,
  ${PromoPackageHeaderFields.promoCode} varchar(30) NOT NULL,
  ${PromoPackageHeaderFields.description} varchar(200) NOT NULL,
  ${PromoPackageHeaderFields.startDate} date NOT NULL,
  ${PromoPackageHeaderFields.endDate} date NOT NULL,
  ${PromoPackageHeaderFields.startTime} time NOT NULL,
  ${PromoPackageHeaderFields.endTime} time NOT NULL,
  ${PromoPackageHeaderFields.remarks} text,
  ${PromoPackageHeaderFields.discount} double NOT NULL,
  ${PromoPackageHeaderFields.discType} int NOT NULL,
  ${PromoPackageHeaderFields.globalDisc} varchar(1) NOT NULL,
  ${PromoPackageHeaderFields.minQuantity} double NOT NULL,
  ${PromoPackageHeaderFields.statusActive} int NOT NULL,
  $createdAtDefinition
)
""");
// ${PromoPackageHeaderFields.toplnId} text DEFAULT NULL,
// CONSTRAINT `toprk_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE

        await txn.execute("""
CREATE TABLE $tablePromoPackageBuy (
  $uuidDefinition,
  ${PromoPackageBuyFields.createDate} datetime NOT NULL,
  ${PromoPackageBuyFields.updateDate} datetime DEFAULT NULL,
  ${PromoPackageBuyFields.toprkId} text DEFAULT NULL,
  ${PromoPackageBuyFields.toitmId} text DEFAULT NULL,
  ${PromoPackageBuyFields.minQuantity} double NOT NULL,
  ${PromoPackageBuyFields.itemPrice} double DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tprk1_toprkId_fkey` FOREIGN KEY (`toprkId`) REFERENCES `toprk` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprk1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoPackageAssignStore (
  $uuidDefinition,
  ${PromoPackageAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoPackageAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoPackageAssignStoreFields.toprkId} text DEFAULT NULL,
  ${PromoPackageAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoPackageAssignStoreFields.holiday} int NOT NULL,
  ${PromoPackageAssignStoreFields.day1} int NOT NULL,
  ${PromoPackageAssignStoreFields.day2} int NOT NULL,
  ${PromoPackageAssignStoreFields.day3} int NOT NULL,
  ${PromoPackageAssignStoreFields.day4} int NOT NULL,
  ${PromoPackageAssignStoreFields.day5} int NOT NULL,
  ${PromoPackageAssignStoreFields.day6} int NOT NULL,
  ${PromoPackageAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprk2_toprkId_fkey` FOREIGN KEY (`toprkId`) REFERENCES `toprk` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprk2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoPackageValidDays (
  $uuidDefinition,
  ${PromoPackageValidDaysFields.createDate} datetime NOT NULL,
  ${PromoPackageValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoPackageValidDaysFields.tprk2Id} text DEFAULT NULL,
  ${PromoPackageValidDaysFields.day} int NOT NULL,
  ${PromoPackageValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprk3_tprk2Id_fkey` FOREIGN KEY (`tprk2Id`) REFERENCES `tprk2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoPackageCustomerGroup (
  $uuidDefinition,
  ${PromoPackageCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoPackageCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoPackageCustomerGroupFields.toprkId} text DEFAULT NULL,
  ${PromoPackageCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprk4_toprkId_fkey` FOREIGN KEY (`toprkId`) REFERENCES `toprk` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprk4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoPackageDefaultValidDays (
  $uuidDefinition,
  ${PromoPackageDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoPackageDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoPackageDefaultValidDaysFields.toprkId} text DEFAULT NULL,
  ${PromoPackageDefaultValidDaysFields.day} int NOT NULL,
  ${PromoPackageDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprk9_toprkId_fkey` FOREIGN KEY (`toprkId`) REFERENCES `toprk` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoGWPHeader (
  $uuidDefinition,
  ${PromoGWPHeaderFields.createDate} datetime NOT NULL,
  ${PromoGWPHeaderFields.updateDate} datetime DEFAULT NULL,
  ${PromoGWPHeaderFields.promoCode} varchar(30) NOT NULL,
  ${PromoGWPHeaderFields.description} varchar(200) NOT NULL,
  ${PromoGWPHeaderFields.startDate} date NOT NULL,
  ${PromoGWPHeaderFields.endDate} date NOT NULL,
  ${PromoGWPHeaderFields.startTime} time NOT NULL,
  ${PromoGWPHeaderFields.endTime} time NOT NULL,
  ${PromoGWPHeaderFields.remarks} text,
  ${PromoGWPHeaderFields.priority} int NOT NULL,
  ${PromoGWPHeaderFields.priorityNo} int NOT NULL,
  ${PromoGWPHeaderFields.minPurchase} double NOT NULL,
  ${PromoGWPHeaderFields.maxGet} double NOT NULL,
  ${PromoGWPHeaderFields.getCondition} varchar(10) NOT NULL,
  ${PromoGWPHeaderFields.statusActive} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoGWPDetail (
  $uuidDefinition,
  ${PromoGWPDetailFields.createDate} datetime NOT NULL,
  ${PromoGWPDetailFields.updateDate} datetime DEFAULT NULL,
  ${PromoGWPDetailFields.toprgId} text DEFAULT NULL,
  ${PromoGWPDetailFields.toitmId} text DEFAULT NULL,
  ${PromoGWPDetailFields.quantity} double NOT NULL,
  ${PromoGWPDetailFields.sellingPrice} double NOT NULL,
  ${PromoGWPDetailFields.itemPrice} double DEFAULT '0',
  $createdAtDefinition,
  CONSTRAINT `tprg1_toprgId_fkey` FOREIGN KEY (`toprgId`) REFERENCES `toprg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprg1_toitmId_fkey` FOREIGN KEY (`toitmId`) REFERENCES `toitm` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoGWPAssignStore (
  $uuidDefinition,
  ${PromoGWPAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoGWPAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoGWPAssignStoreFields.toprgId} text DEFAULT NULL,
  ${PromoGWPAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoGWPAssignStoreFields.holiday} int NOT NULL,
  ${PromoGWPAssignStoreFields.day1} int NOT NULL,
  ${PromoGWPAssignStoreFields.day2} int NOT NULL,
  ${PromoGWPAssignStoreFields.day3} int NOT NULL,
  ${PromoGWPAssignStoreFields.day4} int NOT NULL,
  ${PromoGWPAssignStoreFields.day5} int NOT NULL,
  ${PromoGWPAssignStoreFields.day6} int NOT NULL,
  ${PromoGWPAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprg2_toprgId_fkey` FOREIGN KEY (`toprgId`) REFERENCES `toprg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprg2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoGWPValidDays (
  $uuidDefinition,
  ${PromoGWPValidDaysFields.createDate} datetime NOT NULL,
  ${PromoGWPValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoGWPValidDaysFields.tprg2Id} text DEFAULT NULL,
  ${PromoGWPValidDaysFields.day} int NOT NULL,
  ${PromoGWPValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprg3_tprg2Id_fkey` FOREIGN KEY (`tprg2Id`) REFERENCES `tprg2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoGWPCustomerGroup (
  $uuidDefinition,
  ${PromoGWPCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoGWPCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoGWPCustomerGroupFields.toprgId} text DEFAULT NULL,
  ${PromoGWPCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprg4_toprgId_fkey` FOREIGN KEY (`toprgId`) REFERENCES `toprg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprg4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoGWPDefaultValidDays (
  $uuidDefinition,
  ${PromoGWPDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoGWPDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoGWPDefaultValidDaysFields.toprgId} text DEFAULT NULL,
  ${PromoGWPDefaultValidDaysFields.day} int NOT NULL,
  ${PromoGWPDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprg9_toprgId_fkey` FOREIGN KEY (`toprgId`) REFERENCES `toprg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoVoucherHeader (
  $uuidDefinition,
  ${PromoVoucherHeaderFields.createDate} datetime NOT NULL,
  ${PromoVoucherHeaderFields.updateDate} datetime DEFAULT NULL,
  ${PromoVoucherHeaderFields.promoCode} varchar(30) NOT NULL,
  ${PromoVoucherHeaderFields.description} varchar(200) NOT NULL,
  ${PromoVoucherHeaderFields.startDate} date NOT NULL,
  ${PromoVoucherHeaderFields.endDate} date NOT NULL,
  ${PromoVoucherHeaderFields.startTime} time NOT NULL,
  ${PromoVoucherHeaderFields.endTime} time NOT NULL,
  ${PromoVoucherHeaderFields.remarks} text,
  ${PromoVoucherHeaderFields.validDays} int NOT NULL,
  ${PromoVoucherHeaderFields.minPurchase} double NOT NULL,
  ${PromoVoucherHeaderFields.minNextPurchase} double NOT NULL,
  ${PromoVoucherHeaderFields.minNextPurchasex} int NOT NULL,
  ${PromoVoucherHeaderFields.voucherType} varchar(20) NOT NULL,
  ${PromoVoucherHeaderFields.voucherValue} double NOT NULL,
  ${PromoVoucherHeaderFields.voucherPct} double NOT NULL,
  ${PromoVoucherHeaderFields.statusActive} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoVoucherAssignStore (
  $uuidDefinition,
  ${PromoVoucherAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoVoucherAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoVoucherAssignStoreFields.toprrId} text DEFAULT NULL,
  ${PromoVoucherAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoVoucherAssignStoreFields.holiday} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day1} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day2} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day3} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day4} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day5} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day6} int NOT NULL,
  ${PromoVoucherAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprr2_toprrId_fkey` FOREIGN KEY (`toprrId`) REFERENCES `toprr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprr2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
  
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoVoucherValidDays (
  $uuidDefinition,
  ${PromoVoucherValidDaysFields.createDate} datetime NOT NULL,
  ${PromoVoucherValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoVoucherValidDaysFields.tprr2Id} text DEFAULT NULL,
  ${PromoVoucherValidDaysFields.day} int NOT NULL,
  ${PromoVoucherValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprr3_tprr2Id_fkey` FOREIGN KEY (`tprr2Id`) REFERENCES `tprr2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoVoucherCustomerGroup (
  $uuidDefinition,
  ${PromoVoucherCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoVoucherCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoVoucherCustomerGroupFields.toprrId} text DEFAULT NULL,
  ${PromoVoucherCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprr4_toprrId_fkey` FOREIGN KEY (`toprrId`) REFERENCES `toprr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprr4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE

)
""");

        await txn.execute("""
CREATE TABLE $tablePromoVoucherDefaultValidDays (
  $uuidDefinition,
  ${PromoVoucherDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoVoucherDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoVoucherDefaultValidDaysFields.toprrId} bigint DEFAULT NULL,
  ${PromoVoucherDefaultValidDaysFields.day} int NOT NULL,
  ${PromoVoucherDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprr9_toprrId_fkey` FOREIGN KEY (`toprrId`) REFERENCES `toprr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCouponHeader (
  $uuidDefinition,
  ${PromoCouponHeaderFields.createDate} datetime NOT NULL,
  ${PromoCouponHeaderFields.updateDate} datetime DEFAULT NULL,
  ${PromoCouponHeaderFields.couponCode} varchar(30) NOT NULL,
  ${PromoCouponHeaderFields.description} varchar(200) NOT NULL,
  ${PromoCouponHeaderFields.startDate} date NOT NULL,
  ${PromoCouponHeaderFields.endDate} date NOT NULL,
  ${PromoCouponHeaderFields.startTime} time NOT NULL,
  ${PromoCouponHeaderFields.endTime} time NOT NULL,
  ${PromoCouponHeaderFields.remarks} text,
  ${PromoCouponHeaderFields.includePromo} int NOT NULL,
  ${PromoCouponHeaderFields.maxTimes} int NOT NULL,
  ${PromoCouponHeaderFields.minPurchase} double NOT NULL,
  ${PromoCouponHeaderFields.generalDisc} double NOT NULL,
  ${PromoCouponHeaderFields.maxGeneralDisc} varchar(20) NOT NULL,
  ${PromoCouponHeaderFields.memberDisc} double NOT NULL,
  ${PromoCouponHeaderFields.maxMemberDisc} double NOT NULL,
  ${PromoCouponHeaderFields.statusActive} int NOT NULL,
  $createdAtDefinition
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCouponAssignStore (
  $uuidDefinition,
  ${PromoCouponAssignStoreFields.createDate} datetime NOT NULL,
  ${PromoCouponAssignStoreFields.updateDate} datetime DEFAULT NULL,
  ${PromoCouponAssignStoreFields.toprnId} text DEFAULT NULL,
  ${PromoCouponAssignStoreFields.tostrId} text DEFAULT NULL,
  ${PromoCouponAssignStoreFields.holiday} int NOT NULL,
  ${PromoCouponAssignStoreFields.day1} int NOT NULL,
  ${PromoCouponAssignStoreFields.day2}
  ${PromoCouponAssignStoreFields.day3} int NOT NULL,
  ${PromoCouponAssignStoreFields.day4} int NOT NULL,
  ${PromoCouponAssignStoreFields.day5} int NOT NULL,
  ${PromoCouponAssignStoreFields.day6} int NOT NULL,
  ${PromoCouponAssignStoreFields.day7} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprn2_toprnId_fkey` FOREIGN KEY (`toprnId`) REFERENCES `toprn` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprn2_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCouponValidDays (
  $uuidDefinition,
  ${PromoCouponValidDaysFields.createDate} datetime NOT NULL,
  ${PromoCouponValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoCouponValidDaysFields.tprn2Id} text DEFAULT NULL,
  ${PromoCouponValidDaysFields.day} int NOT NULL,
  ${PromoCouponValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprn3_tprn2Id_fkey` FOREIGN KEY (`tprn2Id`) REFERENCES `tprn2` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCouponCustomerGroup (
  $uuidDefinition,
  ${PromoCouponCustomerGroupFields.createDate} datetime NOT NULL,
  ${PromoCouponCustomerGroupFields.updateDate} datetime DEFAULT NULL,
  ${PromoCouponCustomerGroupFields.toprnId} text DEFAULT NULL,
  ${PromoCouponCustomerGroupFields.tocrgId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprn4_toprnId_fkey` FOREIGN KEY (`toprnId`) REFERENCES `toprn` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tprn4_tocrgId_fkey` FOREIGN KEY (`tocrgId`) REFERENCES `tocrg` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

        await txn.execute("""
CREATE TABLE $tablePromoCouponDefaultValidDays (
  $uuidDefinition,
  ${PromoCouponDefaultValidDaysFields.createDate} datetime NOT NULL,
  ${PromoCouponDefaultValidDaysFields.updateDate} datetime DEFAULT NULL,
  ${PromoCouponDefaultValidDaysFields.toprnId} text DEFAULT NULL,
  ${PromoCouponDefaultValidDaysFields.day} int NOT NULL,
  ${PromoCouponDefaultValidDaysFields.status} int NOT NULL,
  $createdAtDefinition,
  CONSTRAINT `tprn9_toprnId_fkey` FOREIGN KEY (`toprnId`) REFERENCES `toprn` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
)
""");

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
  ${POSParameterFields.tocsrId} text DEFAULT NULL,
  ${POSParameterFields.tovatId} text DEFAULT NULL,
  $createdAtDefinition,
  CONSTRAINT `topos_tostrId_fkey` FOREIGN KEY (`tostrId`) REFERENCES `tostr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_tcurrId_fkey` FOREIGN KEY (`tcurrId`) REFERENCES `tcurr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_toplnId_fkey` FOREIGN KEY (`toplnId`) REFERENCES `topln` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_tocsrId_fkey` FOREIGN KEY (`tocsrId`) REFERENCES `tocsr` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `topos_tovatId_fkey` FOREIGN KEY (`tovatId`) REFERENCES `tovat` (`docid`) ON DELETE SET NULL ON UPDATE CASCADE
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
