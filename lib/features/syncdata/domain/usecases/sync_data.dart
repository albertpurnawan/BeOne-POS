import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
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
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/zipcode_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

Future<void> syncData() async {
  print("Synching data...");
  try {
    final fetchFunctions = [
      () async {
        try {
          final currencies = await GetIt.instance<CurrencyApi>().fetchData();
          await GetIt.instance<AppDatabase>()
              .currencyDao
              .bulkCreate(data: currencies);
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
              .bulkCreate(data: countries);
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
              .bulkCreate(data: provinces);
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
        await GetIt.instance<AppDatabase>()
            .zipcodeDao
            .bulkCreate(data: zipcodes);
      },
      () async {
        final employees = await GetIt.instance<EmployeeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .employeeDao
            .bulkCreate(data: employees);
      },
      () async {
        final taxes = await GetIt.instance<TaxMasterApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .taxMasterDao
            .bulkCreate(data: taxes);
      },
      () async {
        final payTypes = await GetIt.instance<PaymentTypeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .paymentTypeDao
            .bulkCreate(data: payTypes);
      },
      () async {
        final mops = await GetIt.instance<MOPApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .meansOfPaymentDao
            .bulkCreate(data: mops);
      },
      () async {
        final ccs = await GetIt.instance<CreditCardApi>().fetchData();
        await GetIt.instance<AppDatabase>().creditCardDao.bulkCreate(data: ccs);
      },
      () async {
        final pricelists = await GetIt.instance<PricelistApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .pricelistDao
            .bulkCreate(data: pricelists);
      },
      () async {
        final stores = await GetIt.instance<StoreMasterApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .storeMasterDao
            .bulkCreate(data: stores);
      },
      () async {
        try {
          final mopStores = await GetIt.instance<MOPByStoreApi>().fetchData();
          await GetIt.instance<AppDatabase>()
              .mopByStoreDao
              .bulkCreate(data: mopStores);
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
            .bulkCreate(data: cashiers);
      },
      () async {
        final uoms = await GetIt.instance<UoMApi>().fetchData();
        await GetIt.instance<AppDatabase>().uomDao.bulkCreate(data: uoms);
      },
      () async {
        final roles = await GetIt.instance<UserRoleApi>().fetchData();
        await GetIt.instance<AppDatabase>().userRoleDao.bulkCreate(data: roles);
      },
      () async {
        final users = await GetIt.instance<UserApi>().fetchData();
        await GetIt.instance<AppDatabase>().userDao.bulkCreate(data: users);
      },
      () async {
        final pricelistPeriod =
            await GetIt.instance<PricelistPeriodApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .pricelistPeriodDao
            .bulkCreate(data: pricelistPeriod);
      },
      () async {
        final itemCat = await GetIt.instance<ItemCategoryApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemCategoryDao
            .bulkCreate(data: itemCat);
      },
      () async {
        final items = await GetIt.instance<ItemMasterApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemMasterDao
            .bulkCreate(data: items);
      },
      () async {
        final itemsStores = await GetIt.instance<ItemByStoreApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemByStoreDao
            .bulkCreate(data: itemsStores);
      },
      () async {
        final itemBarcodes = await GetIt.instance<ItemBarcodeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemBarcodeDao
            .bulkCreate(data: itemBarcodes);
      },
      // // ---
      () async {
        final itemRemarks = await GetIt.instance<ItemRemarksApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .itemRemarkDao
            .bulkCreate(data: itemRemarks);
      },
      () async {
        final vendor = await GetIt.instance<VendorApi>().fetchData();
        await GetIt.instance<AppDatabase>().vendorDao.bulkCreate(data: vendor);
      },
      () async {
        final prefVendor =
            await GetIt.instance<PreferredVendorApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .preferredVendorDao
            .bulkCreate(data: prefVendor);
      },
      // // ---
      () async {
        final cusGroup = await GetIt.instance<CustomerGroupApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .customerGroupDao
            .bulkCreate(data: cusGroup);
      },
      () async {
        final cusCst = await GetIt.instance<CustomerApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .customerCstDao
            .bulkCreate(data: cusCst);
      },
      () async {
        final priceByItem = await GetIt.instance<PriceByItemApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .priceByItemDao
            .bulkCreate(data: priceByItem);
      },
      () async {
        final apmps = await GetIt.instance<APMPSApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .assignPriceMemberPerStoreDao
            .bulkCreate(data: apmps);
      },
      () async {
        final priceItemBarcode =
            await GetIt.instance<PriceByItemBarcodeApi>().fetchData();
        await GetIt.instance<AppDatabase>()
            .priceByItemBarcodeDao
            .bulkCreate(data: priceItemBarcode);
      },
    ];
    for (final fetchFunction in fetchFunctions) {
      try {
        await fetchFunction();
      } catch (e) {
        print('Error fetching data: $e');
        // Handle the error here, such as logging or displaying a message
      }
    }

    final stores = await GetIt.instance<StoreMasterApi>().fetchData();
    await GetIt.instance<AppDatabase>().storeMasterDao.bulkCreate(data: stores);

    final currencies = await GetIt.instance<CurrencyApi>().fetchData();
    await GetIt.instance<AppDatabase>()
        .currencyDao
        .bulkCreate(data: currencies);

    final cashiers = await GetIt.instance<CashRegisterApi>().fetchData();
    await GetIt.instance<AppDatabase>()
        .cashRegisterDao
        .bulkCreate(data: cashiers);

    // log("$priceItemBarcode\n");

    // final topos =
    //     await GetIt.instance<AppDatabase>().posParameterDao.readAll();
    final posParameter = [
      {
        "docid": const Uuid().v4(),
        "createdate": DateTime.now().toString(),
        "updatedate": DateTime.now().toString(),
        "gtentId": const Uuid().v4(),
        "tostrId": stores[0].docId,
        "storename": stores[0].storeName,
        "tcurrId": stores[0].tcurrId,
        "currcode": currencies[0].curCode,
        "toplnId": stores[0].toplnId,
        "tocsrId": cashiers[0].docId,
        "tovatId": stores[0].tovatId,
        "baseUrl": Constant.url,
        "user": "user",
        "password": "password",
      }
    ];

    await GetIt.instance<AppDatabase>().posParameterDao.bulkCreate(
        data: posParameter.map((e) => POSParameterModel.fromMap(e)).toList());

    // final auths = await GetIt.instance<AuthorizationApi>().fetchData();
    // await GetIt.instance<AppDatabase>().authorizationDao.bulkCreate(auths);
    // final itemPics = await GetIt.instance<ItemPictureApi>().fetchData();
    // await GetIt.instance<AppDatabase>().itemPictureDao.bulkCreate(itemPics);

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
    handleError(error);
    debugPrintStack(stackTrace: stack);
  }
}
