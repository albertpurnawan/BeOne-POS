import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/assign_price_member_per_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/country_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/credit_card_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_group_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/employee_services.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_barcode_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_by_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_remarks_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_by_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/payment_type_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/preferred_vendor_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_period_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_role_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/zipcode_service.dart';
import 'package:sqflite/sqflite.dart';

Future<void> syncData() async {
  print("Synching data...");
  try {
    final fetchFunctions = [
      () async {
        try {
          final currencies = await GetIt.instance<CurrencyApi>().fetchData();
          await GetIt.instance<AppDatabase>()
              .currencyDao
              .resync(data: currencies);
        } catch (e) {
          if (e is DatabaseException) {
            log('DatabaseException occurred: $e');
          } else {
            rethrow;
          }
        }
      },
      () async {
        try {
          final countries = await GetIt.instance<CountryApi>().fetchData();
          await GetIt.instance<AppDatabase>()
              .countryDao
              .resync(data: countries);
        } catch (e) {
          if (e is DatabaseException) {
            log('DatabaseException occurred: $e');
          } else {
            rethrow;
          }
        }
      },
      () async {
        try {
          final provinces = await GetIt.instance<ProvinceApi>().fetchData();
          await GetIt.instance<AppDatabase>()
              .provinceDao
              .resync(data: provinces);
        } catch (e) {
          if (e is DatabaseException) {
            log('DatabaseException occurred: $e');
          } else {
            rethrow;
          }
        }
      },
      () async {
        final zipcodes = await GetIt.instance<ZipcodeApi>().fetchData();
        await GetIt.instance<AppDatabase>().zipcodeDao.resync(data: zipcodes);
      },
      () async {
        final employees = await GetIt.instance<EmployeeApi>().fetchData();
        await GetIt.instance<AppDatabase>().employeeDao.resync(data: employees);
      },
      () async {
        final taxes = await GetIt.instance<TaxMasterApi>().fetchData();
        await GetIt.instance<AppDatabase>().taxMasterDao.resync(data: taxes);
      },
      () async {
        final payTypes = await GetIt.instance<PaymentTypeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .paymentTypeDao
            .resync(data: payTypes);
      },
      () async {
        final mops = await GetIt.instance<MOPApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .meansOfPaymentDao
            .resync(data: mops);
      },
      () async {
        final ccs = await GetIt.instance<CreditCardApi>().fetchData();
        await GetIt.instance<AppDatabase>().creditCardDao.resync(data: ccs);
      },
      () async {
        final pricelists = await GetIt.instance<PricelistApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .pricelistDao
            .resync(data: pricelists);
      },
      () async {
        final stores = await GetIt.instance<StoreMasterApi>().fetchData();
        await GetIt.instance<AppDatabase>().storeMasterDao.resync(data: stores);
      },
      () async {
        try {
          final mopStores = await GetIt.instance<MOPByStoreApi>().fetchData();
          await GetIt.instance<AppDatabase>()
              .mopByStoreDao
              .resync(data: mopStores);
        } catch (e) {
          if (e is DatabaseException) {
            log('DatabaseException occurred: $e');
          } else {
            rethrow;
          }
        }
      },
      () async {
        final cashiers = await GetIt.instance<CashRegisterApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .cashRegisterDao
            .resync(data: cashiers);
      },
      () async {
        final uoms = await GetIt.instance<UoMApi>().fetchData();
        await GetIt.instance<AppDatabase>().uomDao.resync(data: uoms);
      },
      () async {
        final roles = await GetIt.instance<UserRoleApi>().fetchData();
        await GetIt.instance<AppDatabase>().userRoleDao.resync(data: roles);
      },
      () async {
        final users = await GetIt.instance<UserApi>().fetchData();
        await GetIt.instance<AppDatabase>().userDao.resync(data: users);
      },
      () async {
        final pricelistPeriod =
            await GetIt.instance<PricelistPeriodApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .pricelistPeriodDao
            .resync(data: pricelistPeriod);
      },
      () async {
        final itemCat = await GetIt.instance<ItemCategoryApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemCategoryDao
            .resync(data: itemCat);
      },
      () async {
        final items = await GetIt.instance<ItemMasterApi>().fetchData();
        await GetIt.instance<AppDatabase>().itemMasterDao.resync(data: items);
      },
      () async {
        final itemsStores = await GetIt.instance<ItemByStoreApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemByStoreDao
            .resync(data: itemsStores);
      },
      () async {
        final itemBarcodes = await GetIt.instance<ItemBarcodeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemBarcodeDao
            .resync(data: itemBarcodes);
      },
      // // ---
      () async {
        final itemRemarks = await GetIt.instance<ItemRemarksApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemRemarkDao
            .resync(data: itemRemarks);
      },
      () async {
        final venGroups = await GetIt.instance<VendorGroupApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .vendorGroupDao
            .resync(data: venGroups);
      },
      () async {
        final vendor = await GetIt.instance<VendorApi>().fetchData();
        await GetIt.instance<AppDatabase>().vendorDao.resync(data: vendor);
      },
      () async {
        final prefVendor =
            await GetIt.instance<PreferredVendorApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .preferredVendorDao
            .resync(data: prefVendor);
      },
      // // ---
      () async {
        final cusGroup = await GetIt.instance<CustomerGroupApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .customerGroupDao
            .resync(data: cusGroup);
      },
      () async {
        final cusCst = await GetIt.instance<CustomerApi>().fetchData();
        await GetIt.instance<AppDatabase>().customerCstDao.resync(data: cusCst);
      },
      () async {
        final priceByItem = await GetIt.instance<PriceByItemApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .priceByItemDao
            .resync(data: priceByItem);
      },
      () async {
        final apmps = await GetIt.instance<APMPSApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .assignPriceMemberPerStoreDao
            .resync(data: apmps);
      },
      () async {
        final priceItemBarcode =
            await GetIt.instance<PriceByItemBarcodeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .priceByItemBarcodeDao
            .resync(data: priceItemBarcode);
      },
    ];
    for (final fetchFunction in fetchFunctions) {
      try {
        await fetchFunction();
      } catch (e) {
        handleError(e);
      }
    }

    // final topos =
    //     await GetIt.instance<AppDatabase>().posParameterDao.readAll();
    // final posParameter = [
    //   {
    //     "docid": const Uuid().v4(),
    //     "createdate": DateTime.now().toString(),
    //     "updatedate": DateTime.now().toString(),
    //     "gtentId": const Uuid().v4(),
    //     "tostrId": stores[0].docId,
    //     "storename": stores[0].storeName,
    //     "tcurrId": stores[0].tcurrId,
    //     "currcode": currencies[0].curCode,
    //     "toplnId": stores[0].toplnId,
    //     "tocsrId": cashiers[0].docId,
    //     "tovatId": stores[0].tovatId,
    //     "baseUrl": Constant.url,
    //     "user": "user",
    //     "password": "password",
    //   }
    // ];

    // await GetIt.instance<AppDatabase>().posParameterDao.resync(
    //     data: posParameter.map((e) => POSParameterModel.fromMap(e)).toList());

    // final auths = await GetIt.instance<AuthorizationApi>().fetchData();
    // await GetIt.instance<AppDatabase>().authorizationDao.resync(auths);
    // final itemPics = await GetIt.instance<ItemPictureApi>().fetchData();
    // await GetIt.instance<AppDatabase>().itemPictureDao.resync(itemPics);

    // fetched = currencies.length +
    //     countries.length +
    //     provinces.length +
    //     zipcodes.length +
    //     employees.length +
    //     taxes.length +
    //     payTypes.length +
    //     mops.length +
    //     ccs.length +
    //     pricelists.length +
    //     stores.length +
    //     mopStores.length +
    //     cashiers.length +
    //     uoms.length +
    //     roles.length +
    //     users.length +
    //     pricelistPeriod.length +
    //     itemCat.length +
    //     items.length +
    //     itemsStores.length +
    //     itemBarcodes.length +
    //     itemRemarks.length +
    //     venGroups.length +
    //     vendor.length +
    //     prefVendor.length +
    //     cusGroup.length +
    //     cusCst.length +
    //     priceByItem.length +
    //     apmps.length +
    //     priceItemBarcode.length;

    print('Data synched');
  } catch (error, stack) {
    print("Error synchronizing: $error");
    debugPrintStack(stackTrace: stack);
  }
}
