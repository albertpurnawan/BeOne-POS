import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/core/utilities/navigation_helper.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/models/assign_price_member_per_store.dart';
import 'package:pos_fe/features/sales/data/models/authentication_store.dart';
import 'package:pos_fe/features/sales/data/models/bill_of_material.dart';
import 'package:pos_fe/features/sales/data/models/bill_of_material_line_item.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';
import 'package:pos_fe/features/sales/data/models/country.dart';
import 'package:pos_fe/features/sales/data/models/credit_card.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/customer_cst.dart';
import 'package:pos_fe/features/sales/data/models/customer_group.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/item_by_store.dart';
import 'package:pos_fe/features/sales/data/models/item_category.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/sales/data/models/item_remarks.dart';
import 'package:pos_fe/features/sales/data/models/log_error.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/pricelist.dart';
import 'package:pos_fe/features/sales/data/models/pricelist_period.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_buy_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_get_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_bonus_multi_item_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_buy_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_get_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_buy_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_get_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_group_item_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_buy_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_get_condition.dart';
import 'package:pos_fe/features/sales/data/models/promo_diskon_item_header.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_assign_store.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_buy.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_customer_group.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_header.dart';
import 'package:pos_fe/features/sales/data/models/promotions.dart';
import 'package:pos_fe/features/sales/data/models/province.dart';
import 'package:pos_fe/features/sales/data/models/store_master.dart';
import 'package:pos_fe/features/sales/data/models/tax_master.dart';
import 'package:pos_fe/features/sales/data/models/uom.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/data/models/user_role.dart';
import 'package:pos_fe/features/sales/data/models/vendor.dart';
import 'package:pos_fe/features/sales/data/models/vendor_group.dart';
import 'package:pos_fe/features/sales/data/models/zip_code.dart';
import 'package:pos_fe/features/sales/domain/entities/item_master.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/assign_price_member_per_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/auth_store_services.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/bill_of_material_line_item_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/bill_of_material_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/country_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/credit_card_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/customer_group_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/customer_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/employee_services.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_barcode_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_by_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_remarks_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/mop_by_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/payment_type_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/preferred_vendor_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/price_by_item_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/pricelist_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/pricelist_period_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_assign_store.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_buy_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/user_role_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/vendor_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/vendor_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/zipcode_service.dart';
import 'package:pos_fe/features/settings/domain/usecases/check_credential_active_status.dart';
import 'package:pos_fe/features/settings/domain/usecases/refresh_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> syncData() async {
  late List<CurrencyModel> tcurr;
  late List<CountryModel> tocry;
  late List<ProvinceModel> toprv;
  late List<ZipCodeModel> tozcd;
  late List<EmployeeModel> tohem;
  late List<TaxMasterModel> tovat;
  late List<PaymentTypeModel> topmt;
  late List<MeansOfPaymentModel> tpmt1;
  late List<CreditCardModel> tpmt2;
  late List<PricelistModel> topln;
  late List<StoreMasterModel> tostr;
  late List<MOPByStoreModel> tpmt3;
  late List<CashRegisterModel> tocsr;
  late List<UomModel> touom;
  late List<UserRoleModel> torol;
  late List<UserModel> tousr;
  late List<PricelistPeriodModel> tpln1;
  late List<ItemCategoryModel> tocat;
  late List<ItemMasterModel> toitm;
  late List<ItemByStoreModel> tsitm;
  late List<ItemBarcodeModel> tbitm;
  late List<ItemRemarksModel> tritm;
  late List<VendorGroupModel> tovdg;
  late List<VendorModel> toven;
  late List<PreferredVendorModel> tvitm;
  late List<CustomerGroupModel> tocrg;
  late List<CustomerCstModel> tocus;
  late List<PriceByItemModel> tpln2;
  late List<AssignPriceMemberPerStoreModel> tpln3;
  late List<PriceByItemBarcodeModel> tpln4;
  late List<PromoHargaSpesialHeaderModel> topsb;
  late List<PromoHargaSpesialBuyModel> tpsb1;
  late List<PromoHargaSpesialAssignStoreModel> tpsb2;
  late List<PromoHargaSpesialCustomerGroupModel> tpsb4;
  late List<PromoBonusMultiItemHeaderModel> topmi;
  late List<PromoBonusMultiItemBuyConditionModel> tpmi1;
  late List<PromoBonusMultiItemAssignStoreModel> tpmi2;
  late List<PromoBonusMultiItemGetConditionModel> tpmi4;
  late List<PromoBonusMultiItemCustomerGroupModel> tpmi5;
  late List<PromoDiskonItemHeaderModel> topdi;
  late List<PromoDiskonItemBuyConditionModel> tpdi1;
  late List<PromoDiskonItemAssignStoreModel> tpdi2;
  late List<PromoDiskonItemGetConditionModel> tpdi4;
  late List<PromoDiskonItemCustomerGroupModel> tpdi5;
  late List<PromoDiskonGroupItemHeaderModel> topdg;
  late List<PromoDiskonGroupItemBuyConditionModel> tpdg1;
  late List<PromoDiskonGroupItemAssignStoreModel> tpdg2;
  late List<PromoDiskonGroupItemGetConditionModel> tpdg4;
  late List<PromoDiskonGroupItemCustomerGroupModel> tpdg5;
  late List<PromoBuyXGetYHeaderModel> toprb;
  late List<PromoBuyXGetYBuyConditionModel> tprb1;
  late List<PromoBuyXGetYAssignStoreModel> tprb2;
  late List<PromoBuyXGetYGetConditionModel> tprb4;
  late List<PromoBuyXGetYCustomerGroupModel> tprb5;
  late List<AuthStoreModel> tastr;
  late List<BillOfMaterialModel> toitt;
  late List<BillOfMaterialLineItemModel> titt1;

  final prefs = GetIt.instance<SharedPreferences>();
  final refreshTokenUsecase = GetIt.instance<RefreshTokenUseCase>();

  bool? checkSync = prefs.getBool('isSyncing');
  log("Synching data... - $checkSync");
  if (checkSync == null || checkSync == false) {
    try {
      prefs.setBool('isSyncing', true);
      await refreshTokenUsecase.call();
      final topos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final singleTopos = topos[0];
      final toposId = singleTopos.docId;
      final lastSyncDate = singleTopos.lastSync!;

      final nextSyncDate = DateTime.now().toUtc().toIso8601String();

      final fetchFunctions = [
        () async {
          try {
            final tcurrDb =
                await GetIt.instance<AppDatabase>().currencyDao.readAll();

            if (tcurrDb.isNotEmpty) {
              final tcurrDbMap = {
                for (var datum in tcurrDb) datum.docId: datum
              };
              tcurr =
                  await GetIt.instance<CurrencyApi>().fetchData(lastSyncDate);
              for (final datumBos in tcurr) {
                final datumDb = tcurrDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .currencyDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .currencyDao
                      .create(data: datumBos);
                }
              }
            } else {
              tcurr = await GetIt.instance<CurrencyApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .currencyDao
                  .bulkCreate(data: tcurr);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tcurr",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tocryDb =
                await GetIt.instance<AppDatabase>().countryDao.readAll();

            if (tocryDb.isNotEmpty) {
              final tocryDbMap = {
                for (var datum in tocryDb) datum.docId: datum
              };

              tocry =
                  await GetIt.instance<CountryApi>().fetchData(lastSyncDate);
              for (final datumBos in tocry) {
                final datumDb = tocryDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .countryDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .countryDao
                      .create(data: datumBos);
                }
              }
            } else {
              tocry = await GetIt.instance<CountryApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .countryDao
                  .bulkCreate(data: tocry);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tocry",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final toprvDb =
                await GetIt.instance<AppDatabase>().provinceDao.readAll();

            if (toprvDb.isNotEmpty) {
              final toprvDbMap = {
                for (var datum in toprvDb) datum.docId: datum
              };

              toprv =
                  await GetIt.instance<ProvinceApi>().fetchData(lastSyncDate);
              for (final datumBos in toprv) {
                final datumDb = toprvDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .provinceDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .provinceDao
                      .create(data: datumBos);
                }
              }
            } else {
              toprv = await GetIt.instance<ProvinceApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .provinceDao
                  .bulkCreate(data: toprv);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Toprv",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tozcdDb =
                await GetIt.instance<AppDatabase>().zipcodeDao.readAll();

            if (tozcdDb.isNotEmpty) {
              final tozcdDbMap = {
                for (var datum in tozcdDb) datum.docId: datum
              };

              tozcd =
                  await GetIt.instance<ZipcodeApi>().fetchData(lastSyncDate);
              for (final datumBos in tozcd) {
                final datumDb = tozcdDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .zipcodeDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .zipcodeDao
                      .create(data: datumBos);
                }
              }
            } else {
              tozcd = await GetIt.instance<ZipcodeApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .zipcodeDao
                  .bulkCreate(data: tozcd);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tozcd",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tohemDb =
                await GetIt.instance<AppDatabase>().employeeDao.readAll();

            if (tohemDb.isNotEmpty) {
              final tohemDbMap = {
                for (var datum in tohemDb) datum.docId: datum
              };

              tohem =
                  await GetIt.instance<EmployeeApi>().fetchData(lastSyncDate);
              for (final datumBos in tohem) {
                final datumDb = tohemDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .employeeDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .employeeDao
                      .create(data: datumBos);
                }
              }
            } else {
              tohem = await GetIt.instance<EmployeeApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .employeeDao
                  .bulkCreate(data: tohem);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tohem",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tovatDb =
                await GetIt.instance<AppDatabase>().taxMasterDao.readAll();

            if (tovatDb.isNotEmpty) {
              final tovatDbMap = {
                for (var datum in tovatDb) datum.docId: datum
              };

              tovat =
                  await GetIt.instance<TaxMasterApi>().fetchData(lastSyncDate);
              for (final datumBos in tovat) {
                final datumDb = tovatDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .taxMasterDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .taxMasterDao
                      .create(data: datumBos);
                }
              }
            } else {
              tovat = await GetIt.instance<TaxMasterApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .taxMasterDao
                  .bulkCreate(data: tovat);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tovat",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final topmtDb =
                await GetIt.instance<AppDatabase>().paymentTypeDao.readAll();

            if (topmtDb.isNotEmpty) {
              final topmtDbMap = {
                for (var datum in topmtDb) datum.docId: datum
              };

              topmt = await GetIt.instance<PaymentTypeApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in topmt) {
                final datumDb = topmtDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .paymentTypeDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .paymentTypeDao
                      .create(data: datumBos);
                }
              }
            } else {
              topmt = await GetIt.instance<PaymentTypeApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .paymentTypeDao
                  .bulkCreate(data: topmt);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Topmt",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmt1Db =
                await GetIt.instance<AppDatabase>().meansOfPaymentDao.readAll();

            if (tpmt1Db.isNotEmpty) {
              final tpmt1DbMap = {
                for (var datum in tpmt1Db) datum.docId: datum
              };

              tpmt1 = await GetIt.instance<MOPApi>().fetchData(lastSyncDate);
              for (final datumBos in tpmt1) {
                final datumDb = tpmt1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .meansOfPaymentDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .meansOfPaymentDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmt1 = await GetIt.instance<MOPApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .meansOfPaymentDao
                  .bulkCreate(data: tpmt1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmt1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmt2Db =
                await GetIt.instance<AppDatabase>().creditCardDao.readAll();

            if (tpmt2Db.isNotEmpty) {
              final tpmt2DbMap = {
                for (var datum in tpmt2Db) datum.docId: datum
              };

              tpmt2 =
                  await GetIt.instance<CreditCardApi>().fetchData(lastSyncDate);
              for (final datumBos in tpmt2) {
                final datumDb = tpmt2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .creditCardDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .creditCardDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmt2 = await GetIt.instance<CreditCardApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .creditCardDao
                  .bulkCreate(data: tpmt2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmt2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final toplnDb =
                await GetIt.instance<AppDatabase>().pricelistDao.readAll();

            if (toplnDb.isNotEmpty) {
              final toplnDbMap = {
                for (var datum in toplnDb) datum.docId: datum
              };

              topln =
                  await GetIt.instance<PricelistApi>().fetchData(lastSyncDate);
              for (final datumBos in topln) {
                final datumDb = toplnDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .pricelistDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .pricelistDao
                      .create(data: datumBos);
                }
              }
            } else {
              topln = await GetIt.instance<PricelistApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .pricelistDao
                  .bulkCreate(data: topln);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Topln",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tostrDb =
                await GetIt.instance<AppDatabase>().storeMasterDao.readAll();

            if (tostrDb.isNotEmpty) {
              final tostrDbMap = {
                for (var datum in tostrDb) datum.docId: datum
              };

              tostr = await GetIt.instance<StoreMasterApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tostr) {
                final datumDb = tostrDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .storeMasterDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .storeMasterDao
                      .create(data: datumBos);
                }
              }
            } else {
              tostr = await GetIt.instance<StoreMasterApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .storeMasterDao
                  .bulkCreate(data: tostr);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tostr",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmt3Db =
                await GetIt.instance<AppDatabase>().mopByStoreDao.readAll();

            if (tpmt3Db.isNotEmpty) {
              final tpmt3DbMap = {
                for (var datum in tpmt3Db) datum.docId: datum
              };

              tpmt3 =
                  await GetIt.instance<MOPByStoreApi>().fetchData(lastSyncDate);
              for (final datumBos in tpmt3) {
                final datumDb = tpmt3DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .mopByStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .mopByStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmt3 = await GetIt.instance<MOPByStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .mopByStoreDao
                  .bulkCreate(data: tpmt3);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmt3",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tocsrDb =
                await GetIt.instance<AppDatabase>().cashRegisterDao.readAll();

            if (tocsrDb.isNotEmpty) {
              final tocsrDbMap = {
                for (var datum in tocsrDb) datum.docId: datum
              };

              tocsr = await GetIt.instance<CashRegisterApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tocsr) {
                final datumDb = tocsrDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .cashRegisterDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .cashRegisterDao
                      .create(data: datumBos);
                }
              }
            } else {
              tocsr = await GetIt.instance<CashRegisterApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .cashRegisterDao
                  .bulkCreate(data: tocsr);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tocsr",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final touomDb =
                await GetIt.instance<AppDatabase>().uomDao.readAll();

            if (touomDb.isNotEmpty) {
              final touomDbMap = {
                for (var datum in touomDb) datum.docId: datum
              };

              touom = await GetIt.instance<UoMApi>().fetchData(lastSyncDate);
              for (final datumBos in touom) {
                final datumDb = touomDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .uomDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .uomDao
                      .create(data: datumBos);
                }
              }
            } else {
              touom = await GetIt.instance<UoMApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .uomDao
                  .bulkCreate(data: touom);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tuom",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final torolDb =
                await GetIt.instance<AppDatabase>().userRoleDao.readAll();

            if (torolDb.isNotEmpty) {
              final torolDbMap = {
                for (var datum in torolDb) datum.docId: datum
              };

              torol =
                  await GetIt.instance<UserRoleApi>().fetchData(lastSyncDate);
              for (final datumBos in torol) {
                final datumDb = torolDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .userRoleDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .userRoleDao
                      .create(data: datumBos);
                }
              }
            } else {
              torol = await GetIt.instance<UserRoleApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .userRoleDao
                  .bulkCreate(data: torol);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Torol",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tousrDb =
                await GetIt.instance<AppDatabase>().userDao.readAll();

            if (tousrDb.isNotEmpty) {
              final tousrDbMap = {
                for (var datum in tousrDb) datum.docId: datum
              };

              tousr = await GetIt.instance<UserApi>().fetchData(lastSyncDate);
              for (final datumBos in tousr) {
                final datumDb = tousrDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .userDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .userDao
                      .create(data: datumBos);
                }
              }
            } else {
              tousr = await GetIt.instance<UserApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .userDao
                  .bulkCreate(data: tousr);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tousr",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpln1Db = await GetIt.instance<AppDatabase>()
                .pricelistPeriodDao
                .readAll();

            if (tpln1Db.isNotEmpty) {
              final tpln1DbMap = {
                for (var datum in tpln1Db) datum.docId: datum
              };

              tpln1 = await GetIt.instance<PricelistPeriodApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpln1) {
                final datumDb = tpln1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .pricelistPeriodDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .pricelistPeriodDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpln1 = await GetIt.instance<PricelistPeriodApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .pricelistPeriodDao
                  .bulkCreate(data: tpln1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpln1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tocatDb =
                await GetIt.instance<AppDatabase>().itemCategoryDao.readAll();

            if (tocatDb.isNotEmpty) {
              final tocatDbMap = {
                for (var datum in tocatDb) datum.docId: datum
              };

              tocat = await GetIt.instance<ItemCategoryApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tocat) {
                final datumDb = tocatDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .itemCategoryDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .itemCategoryDao
                      .create(data: datumBos);
                }
              }
            } else {
              tocat = await GetIt.instance<ItemCategoryApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemCategoryDao
                  .bulkCreate(data: tocat);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tocat",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final toitmDb =
                await GetIt.instance<AppDatabase>().itemMasterDao.readAll();

            if (toitmDb.isNotEmpty) {
              final toitmDbMap = {
                for (var datum in toitmDb) datum.docId: datum
              };

              toitm =
                  await GetIt.instance<ItemMasterApi>().fetchData(lastSyncDate);
              for (final datumBos in toitm) {
                final datumDb = toitmDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .itemMasterDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .itemMasterDao
                      .create(data: datumBos);
                }
              }
            } else {
              toitm = await GetIt.instance<ItemMasterApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemMasterDao
                  .bulkCreate(data: toitm);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Toitm",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tsitmDb =
                await GetIt.instance<AppDatabase>().itemByStoreDao.readAll();

            if (tsitmDb.isNotEmpty) {
              final tsitmDbMap = {
                for (var datum in tsitmDb) datum.docId: datum
              };

              tsitm = await GetIt.instance<ItemByStoreApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tsitm) {
                final datumDb = tsitmDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .itemByStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .itemByStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tsitm = await GetIt.instance<ItemByStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemByStoreDao
                  .bulkCreate(data: tsitm);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tsitm",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tbitmDb =
                await GetIt.instance<AppDatabase>().itemBarcodeDao.readAll();

            if (tbitmDb.isNotEmpty) {
              final tbitmDbMap = {
                for (var datum in tbitmDb) datum.docId: datum
              };

              tbitm = await GetIt.instance<ItemBarcodeApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tbitm) {
                final datumDb = tbitmDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .itemBarcodeDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .itemBarcodeDao
                      .create(data: datumBos);
                }
              }
            } else {
              tbitm = await GetIt.instance<ItemBarcodeApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemBarcodeDao
                  .bulkCreate(data: tbitm);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tbitm",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tritmDb =
                await GetIt.instance<AppDatabase>().itemRemarkDao.readAll();

            if (tritmDb.isNotEmpty) {
              final tritmDbMap = {
                for (var datum in tritmDb) datum.docId: datum
              };

              tritm = await GetIt.instance<ItemRemarksApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tritm) {
                final datumDb = tritmDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .itemRemarkDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .itemRemarkDao
                      .create(data: datumBos);
                }
              }
            } else {
              tritm = await GetIt.instance<ItemRemarksApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemRemarkDao
                  .bulkCreate(data: tritm);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tritm",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tovdgDb =
                await GetIt.instance<AppDatabase>().vendorGroupDao.readAll();

            if (tovdgDb.isNotEmpty) {
              final tovdgDbMap = {
                for (var datum in tovdgDb) datum.docId: datum
              };

              tovdg = await GetIt.instance<VendorGroupApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tovdg) {
                final datumDb = tovdgDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .vendorGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .vendorGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tovdg = await GetIt.instance<VendorGroupApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .vendorGroupDao
                  .bulkCreate(data: tovdg);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tovdg",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tovenDb =
                await GetIt.instance<AppDatabase>().vendorDao.readAll();

            if (tovenDb.isNotEmpty) {
              final tovenDbMap = {
                for (var datum in tovenDb) datum.docId: datum
              };

              toven = await GetIt.instance<VendorApi>().fetchData(lastSyncDate);
              for (final datumBos in toven) {
                final datumDb = tovenDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .vendorDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .vendorDao
                      .create(data: datumBos);
                }
              }
            } else {
              toven = await GetIt.instance<VendorApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .vendorDao
                  .bulkCreate(data: toven);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Toven",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tvitmDb = await GetIt.instance<AppDatabase>()
                .preferredVendorDao
                .readAll();

            if (tvitmDb.isNotEmpty) {
              final tvitmDbMap = {
                for (var datum in tvitmDb) datum.docId: datum
              };

              tvitm = await GetIt.instance<PreferredVendorApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tvitm) {
                final datumDb = tvitmDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .preferredVendorDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .preferredVendorDao
                      .create(data: datumBos);
                }
              }
            } else {
              tvitm = await GetIt.instance<PreferredVendorApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .preferredVendorDao
                  .bulkCreate(data: tvitm);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tvitm",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tocrgDb =
                await GetIt.instance<AppDatabase>().customerGroupDao.readAll();

            if (tocrgDb.isNotEmpty) {
              final tocrgDbMap = {
                for (var datum in tocrgDb) datum.docId: datum
              };

              tocrg = await GetIt.instance<CustomerGroupApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tocrg) {
                final datumDb = tocrgDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .customerGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .customerGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tocrg = await GetIt.instance<CustomerGroupApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .customerGroupDao
                  .bulkCreate(data: tocrg);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tocrg",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tocusDb = await GetIt.instance<AppDatabase>()
                .customerCstDao
                .readAll(searchKeyword: '');

            if (tocusDb.isNotEmpty) {
              final tocusDbMap = {
                for (var datum in tocusDb) datum.docId: datum
              };

              tocus =
                  await GetIt.instance<CustomerApi>().fetchData(lastSyncDate);
              for (final datumBos in tocus) {
                final datumDb = tocusDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .customerCstDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .customerCstDao
                      .create(data: datumBos);
                }
              }
            } else {
              tocus = await GetIt.instance<CustomerApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .customerCstDao
                  .bulkCreate(data: tocus);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tocus",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpln2Db =
                await GetIt.instance<AppDatabase>().priceByItemDao.readAll();

            if (tpln2Db.isNotEmpty) {
              final tpln2DbMap = {
                for (var datum in tpln2Db) datum.docId: datum
              };

              tpln2 = await GetIt.instance<PriceByItemApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpln2) {
                final datumDb = tpln2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .priceByItemDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .priceByItemDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpln2 = await GetIt.instance<PriceByItemApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .priceByItemDao
                  .bulkCreate(data: tpln2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpln2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpln3Db = await GetIt.instance<AppDatabase>()
                .assignPriceMemberPerStoreDao
                .readAll();

            if (tpln3Db.isNotEmpty) {
              final tpln3DbMap = {
                for (var datum in tpln3Db) datum.docId: datum
              };

              tpln3 = await GetIt.instance<APMPSApi>().fetchData(lastSyncDate);
              for (final datumBos in tpln3) {
                final datumDb = tpln3DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .assignPriceMemberPerStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .assignPriceMemberPerStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpln3 = await GetIt.instance<APMPSApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .assignPriceMemberPerStoreDao
                  .bulkCreate(data: tpln3);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpln3",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpln4Db = await GetIt.instance<AppDatabase>()
                .priceByItemBarcodeDao
                .readAll();

            if (tpln4Db.isNotEmpty) {
              final tpln4DbMap = {
                for (var datum in tpln4Db) datum.docId: datum
              };

              tpln4 = await GetIt.instance<PriceByItemBarcodeApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpln4) {
                final datumDb = tpln4DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .priceByItemBarcodeDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .priceByItemBarcodeDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpln4 = await GetIt.instance<PriceByItemBarcodeApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .priceByItemBarcodeDao
                  .bulkCreate(data: tpln4);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpln4",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tastrDb =
                await GetIt.instance<AppDatabase>().authStoreDao.readAll();

            if (tastrDb.isNotEmpty) {
              final tastrDbMap = {
                for (var datum in tastrDb) datum.docId: datum
              };

              tastr =
                  await GetIt.instance<AuthStoreApi>().fetchData(lastSyncDate);
              for (final datumBos in tastr) {
                final datumDb = tastrDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .authStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .authStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tastr = await GetIt.instance<AuthStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .authStoreDao
                  .bulkCreate(data: tastr);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tastr",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final topsbDb = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialHeaderDao
                .readAll();

            if (topsbDb.isNotEmpty) {
              final topsbDbMap = {
                for (var datum in topsbDb) datum.docId: datum
              };

              topsb = await GetIt.instance<PromoHargaSpesialApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in topsb) {
                final datumDb = topsbDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialHeaderDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoHargaSpesialHeaderDao
                      .create(data: datumBos);
                }
              }
            } else {
              topsb = await GetIt.instance<PromoHargaSpesialApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialHeaderDao
                  .bulkCreate(data: topsb);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Topsb",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpsb1Db = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialBuyDao
                .readAll();

            if (tpsb1Db.isNotEmpty) {
              final tpsb1DbMap = {
                for (var datum in tpsb1Db) datum.docId: datum
              };

              tpsb1 = await GetIt.instance<PromoHargaSpesialBuyApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpsb1) {
                final datumDb = tpsb1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialBuyDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoHargaSpesialBuyDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpsb1 = await GetIt.instance<PromoHargaSpesialBuyApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialBuyDao
                  .bulkCreate(data: tpsb1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpsb1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpsb2Db = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialAssignStoreDao
                .readAll();

            if (tpsb2Db.isNotEmpty) {
              final tpsb2DbMap = {
                for (var datum in tpsb2Db) datum.docId: datum
              };

              tpsb2 = await GetIt.instance<PromoHargaSpesialAssignStoreApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpsb2) {
                final datumDb = tpsb2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialAssignStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoHargaSpesialAssignStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpsb2 = await GetIt.instance<PromoHargaSpesialAssignStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialAssignStoreDao
                  .bulkCreate(data: tpsb2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpsb2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpsb4Db = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialCustomerGroupDao
                .readAll();

            if (tpsb4Db.isNotEmpty) {
              final tpsb4DbMap = {
                for (var datum in tpsb4Db) datum.docId: datum
              };

              tpsb4 = await GetIt.instance<PromoHargaSpesialCustomerGroupApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpsb4) {
                final datumDb = tpsb4DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoHargaSpesialCustomerGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoHargaSpesialCustomerGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpsb4 = await GetIt.instance<PromoHargaSpesialCustomerGroupApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialCustomerGroupDao
                  .bulkCreate(data: tpsb4);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpsb4",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final topmiDb = await GetIt.instance<AppDatabase>()
                .promoMultiItemHeaderDao
                .readAll();

            if (topmiDb.isNotEmpty) {
              final topmiDbMap = {
                for (var datum in topmiDb) datum.docId: datum
              };

              topmi = await GetIt.instance<PromoBonusMultiItemHeaderApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in topmi) {
                final datumDb = topmiDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoMultiItemHeaderDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoMultiItemHeaderDao
                      .create(data: datumBos);
                }
              }
            } else {
              topmi = await GetIt.instance<PromoBonusMultiItemHeaderApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemHeaderDao
                  .bulkCreate(data: topmi);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Topmi",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmi1Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemBuyConditionDao
                .readAll();

            if (tpmi1Db.isNotEmpty) {
              final tpmi1DbMap = {
                for (var datum in tpmi1Db) datum.docId: datum
              };

              tpmi1 = await GetIt.instance<PromoBonusMultiItemBuyConditionApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpmi1) {
                final datumDb = tpmi1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoMultiItemBuyConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoMultiItemBuyConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmi1 = await GetIt.instance<PromoBonusMultiItemBuyConditionApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemBuyConditionDao
                  .bulkCreate(data: tpmi1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmi1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmi2Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemAssignStoreDao
                .readAll();

            if (tpmi2Db.isNotEmpty) {
              final tpmi2DbMap = {
                for (var datum in tpmi2Db) datum.docId: datum
              };

              tpmi2 = await GetIt.instance<PromoBonusMultiItemAssignStoreApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpmi2) {
                final datumDb = tpmi2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoMultiItemAssignStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoMultiItemAssignStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmi2 = await GetIt.instance<PromoBonusMultiItemAssignStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemAssignStoreDao
                  .bulkCreate(data: tpmi2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmi2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmi4Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemGetConditionDao
                .readAll();

            if (tpmi4Db.isNotEmpty) {
              final tpmi4DbMap = {
                for (var datum in tpmi4Db) datum.docId: datum
              };

              tpmi4 = await GetIt.instance<PromoBonusMultiItemGetConditionApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpmi4) {
                final datumDb = tpmi4DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoMultiItemGetConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoMultiItemGetConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmi4 = await GetIt.instance<PromoBonusMultiItemGetConditionApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemGetConditionDao
                  .bulkCreate(data: tpmi4);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmi4",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpmi5Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemCustomerGroupDao
                .readAll();

            if (tpmi5Db.isNotEmpty) {
              final tpmi5DbMap = {
                for (var datum in tpmi5Db) datum.docId: datum
              };

              tpmi5 =
                  await GetIt.instance<PromoBonusMultiItemCustomerGroupApi>()
                      .fetchData(lastSyncDate);
              for (final datumBos in tpmi5) {
                final datumDb = tpmi5DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoMultiItemCustomerGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoMultiItemCustomerGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpmi5 =
                  await GetIt.instance<PromoBonusMultiItemCustomerGroupApi>()
                      .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemCustomerGroupDao
                  .bulkCreate(data: tpmi5);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpmi5",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final topdiDb = await GetIt.instance<AppDatabase>()
                .promoDiskonItemHeaderDao
                .readAll();

            if (topdiDb.isNotEmpty) {
              final topdiDbMap = {
                for (var datum in topdiDb) datum.docId: datum
              };

              topdi = await GetIt.instance<PromoDiskonItemHeaderApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in topdi) {
                final datumDb = topdiDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonItemHeaderDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonItemHeaderDao
                      .create(data: datumBos);
                }
              }
            } else {
              topdi = await GetIt.instance<PromoDiskonItemHeaderApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemHeaderDao
                  .bulkCreate(data: topdi);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Topdi",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdi1Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemBuyConditionDao
                .readAll();

            if (tpdi1Db.isNotEmpty) {
              final tpdi1DbMap = {
                for (var datum in tpdi1Db) datum.docId: datum
              };

              tpdi1 = await GetIt.instance<PromoDiskonItemBuyConditionApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpdi1) {
                final datumDb = tpdi1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonItemBuyConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonItemBuyConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdi1 = await GetIt.instance<PromoDiskonItemBuyConditionApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemBuyConditionDao
                  .bulkCreate(data: tpdi1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdi1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdi2Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemAssignStoreDao
                .readAll();

            if (tpdi2Db.isNotEmpty) {
              final tpdi2DbMap = {
                for (var datum in tpdi2Db) datum.docId: datum
              };

              tpdi2 = await GetIt.instance<PromoDiskonItemAssignStoreApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpdi2) {
                final datumDb = tpdi2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonItemAssignStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonItemAssignStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdi2 = await GetIt.instance<PromoDiskonItemAssignStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemAssignStoreDao
                  .bulkCreate(data: tpdi2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdi2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdi4Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemGetConditionDao
                .readAll();

            if (tpdi4Db.isNotEmpty) {
              final tpdi4DbMap = {
                for (var datum in tpdi4Db) datum.docId: datum
              };

              tpdi4 = await GetIt.instance<PromoDiskonItemGetConditionApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpdi4) {
                final datumDb = tpdi4DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonItemGetConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonItemGetConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdi4 = await GetIt.instance<PromoDiskonItemGetConditionApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemGetConditionDao
                  .bulkCreate(data: tpdi4);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdi4",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdi5Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemCustomerGroupDao
                .readAll();

            if (tpdi5Db.isNotEmpty) {
              final tpdi5DbMap = {
                for (var datum in tpdi5Db) datum.docId: datum
              };

              tpdi5 = await GetIt.instance<PromoDiskonItemCustomerGroupApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpdi5) {
                final datumDb = tpdi5DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonItemCustomerGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonItemCustomerGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdi5 = await GetIt.instance<PromoDiskonItemCustomerGroupApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemCustomerGroupDao
                  .bulkCreate(data: tpdi5);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdi5",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final topdgDb = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemHeaderDao
                .readAll();

            if (topdgDb.isNotEmpty) {
              final topdgDbMap = {
                for (var datum in topdgDb) datum.docId: datum
              };

              topdg = await GetIt.instance<PromoDiskonGroupItemHeaderApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in topdg) {
                final datumDb = topdgDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonGroupItemHeaderDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonGroupItemHeaderDao
                      .create(data: datumBos);
                }
              }
            } else {
              topdg = await GetIt.instance<PromoDiskonGroupItemHeaderApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemHeaderDao
                  .bulkCreate(data: topdg);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Topdg",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdg1Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemBuyConditionDao
                .readAll();

            if (tpdg1Db.isNotEmpty) {
              final tpdg1DbMap = {
                for (var datum in tpdg1Db) datum.docId: datum
              };

              tpdg1 =
                  await GetIt.instance<PromoDiskonGroupItemBuyConditionApi>()
                      .fetchData(lastSyncDate);
              for (final datumBos in tpdg1) {
                final datumDb = tpdg1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonGroupItemBuyConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonGroupItemBuyConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdg1 =
                  await GetIt.instance<PromoDiskonGroupItemBuyConditionApi>()
                      .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemBuyConditionDao
                  .bulkCreate(data: tpdg1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdg1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdg2Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemAssignStoreDao
                .readAll();

            if (tpdg2Db.isNotEmpty) {
              final tpdg2DbMap = {
                for (var datum in tpdg2Db) datum.docId: datum
              };

              tpdg2 = await GetIt.instance<PromoDiskonGroupItemAssignStoreApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tpdg2) {
                final datumDb = tpdg2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonGroupItemAssignStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonGroupItemAssignStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdg2 = await GetIt.instance<PromoDiskonGroupItemAssignStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemAssignStoreDao
                  .bulkCreate(data: tpdg2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdg2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdg4Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemGetConditionDao
                .readAll();

            if (tpdg4Db.isNotEmpty) {
              final tpdg4DbMap = {
                for (var datum in tpdg4Db) datum.docId: datum
              };

              tpdg4 =
                  await GetIt.instance<PromoDiskonGroupItemGetConditionApi>()
                      .fetchData(lastSyncDate);
              for (final datumBos in tpdg4) {
                final datumDb = tpdg4DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonGroupItemGetConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonGroupItemGetConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdg4 =
                  await GetIt.instance<PromoDiskonGroupItemGetConditionApi>()
                      .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemGetConditionDao
                  .bulkCreate(data: tpdg4);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdg4",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tpdg5Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemCustomerGroupDao
                .readAll();

            if (tpdg5Db.isNotEmpty) {
              final tpdg5DbMap = {
                for (var datum in tpdg5Db) datum.docId: datum
              };

              tpdg5 =
                  await GetIt.instance<PromoDiskonGroupItemCustomerGroupApi>()
                      .fetchData(lastSyncDate);
              for (final datumBos in tpdg5) {
                final datumDb = tpdg5DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoDiskonGroupItemCustomerGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoDiskonGroupItemCustomerGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tpdg5 =
                  await GetIt.instance<PromoDiskonGroupItemCustomerGroupApi>()
                      .fetchData("2000-01-01 00:00:00");

              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemCustomerGroupDao
                  .bulkCreate(data: tpdg5);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tpdg5",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final toprbDb = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYHeaderDao
                .readAll();

            if (toprbDb.isNotEmpty) {
              final toprbDbMap = {
                for (var datum in toprbDb) datum.docId: datum
              };

              toprb = await GetIt.instance<PromoBuyXGetYHeaderApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in toprb) {
                final datumDb = toprbDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYHeaderDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoBuyXGetYHeaderDao
                      .create(data: datumBos);
                }
              }
            } else {
              toprb = await GetIt.instance<PromoBuyXGetYHeaderApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYHeaderDao
                  .bulkCreate(data: toprb);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Toprb",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tprb1Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYBuyConditionDao
                .readAll();

            if (tprb1Db.isNotEmpty) {
              final tprb1DbMap = {
                for (var datum in tprb1Db) datum.docId: datum
              };

              tprb1 = await GetIt.instance<PromoBuyXGetYBuyConditionApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tprb1) {
                final datumDb = tprb1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYBuyConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoBuyXGetYBuyConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tprb1 = await GetIt.instance<PromoBuyXGetYBuyConditionApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYBuyConditionDao
                  .bulkCreate(data: tprb1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tprb1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tprb2Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYAssignStoreDao
                .readAll();

            if (tprb2Db.isNotEmpty) {
              final tprb2DbMap = {
                for (var datum in tprb2Db) datum.docId: datum
              };

              tprb2 = await GetIt.instance<PromoBuyXGetYAssignStoreApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tprb2) {
                final datumDb = tprb2DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYAssignStoreDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoBuyXGetYAssignStoreDao
                      .create(data: datumBos);
                }
              }
            } else {
              tprb2 = await GetIt.instance<PromoBuyXGetYAssignStoreApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYAssignStoreDao
                  .bulkCreate(data: tprb2);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tprb2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tprb4Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYGetConditionDao
                .readAll();

            if (tprb4Db.isNotEmpty) {
              final tprb4DbMap = {
                for (var datum in tprb4Db) datum.docId: datum
              };

              tprb4 = await GetIt.instance<PromoBuyXGetYGetConditionApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tprb4) {
                final datumDb = tprb4DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYGetConditionDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoBuyXGetYGetConditionDao
                      .create(data: datumBos);
                }
              }
            } else {
              tprb4 = await GetIt.instance<PromoBuyXGetYGetConditionApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYGetConditionDao
                  .bulkCreate(data: tprb4);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tprb2",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final tprb5Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYCustomerGroupDao
                .readAll();

            if (tprb5Db.isNotEmpty) {
              final tprb5DbMap = {
                for (var datum in tprb5Db) datum.docId: datum
              };

              tprb5 = await GetIt.instance<PromoBuyXGetYCustomerGroupApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in tprb5) {
                final datumDb = tprb5DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .promoBuyXGetYCustomerGroupDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .promoBuyXGetYCustomerGroupDao
                      .create(data: datumBos);
                }
              }
            } else {
              tprb5 = await GetIt.instance<PromoBuyXGetYCustomerGroupApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYCustomerGroupDao
                  .bulkCreate(data: tprb5);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Tprb5",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final toittDb =
                await GetIt.instance<AppDatabase>().billOfMaterialDao.readAll();

            if (toittDb.isNotEmpty) {
              final toittDbMap = {
                for (var datum in toittDb) datum.docId: datum
              };

              toitt = await GetIt.instance<BillOfMaterialApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in toitt) {
                final datumDb = toittDbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .billOfMaterialDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .billOfMaterialDao
                      .create(data: datumBos);
                }
              }
            } else {
              toitt = await GetIt.instance<BillOfMaterialApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .billOfMaterialDao
                  .bulkCreate(data: toitt);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Toitt",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
        () async {
          try {
            final titt1Db = await GetIt.instance<AppDatabase>()
                .billOfMaterialLineItemDao
                .readAll();

            if (titt1Db.isNotEmpty) {
              final titt1DbMap = {
                for (var datum in titt1Db) datum.docId: datum
              };

              titt1 = await GetIt.instance<BillOfMaterialLineItemApi>()
                  .fetchData(lastSyncDate);
              for (final datumBos in titt1) {
                final datumDb = titt1DbMap[datumBos.docId];

                if (datumDb != null) {
                  if (datumBos.form == "U" &&
                      (datumBos.updateDate
                              ?.isAfter(DateTime.parse(lastSyncDate)) ??
                          false)) {
                    await GetIt.instance<AppDatabase>()
                        .billOfMaterialLineItemDao
                        .update(docId: datumDb.docId, data: datumBos);
                  }
                } else {
                  await GetIt.instance<AppDatabase>()
                      .billOfMaterialLineItemDao
                      .create(data: datumBos);
                }
              }
            } else {
              titt1 = await GetIt.instance<BillOfMaterialLineItemApi>()
                  .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .billOfMaterialLineItemDao
                  .bulkCreate(data: titt1);
            }
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: Titt1",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        },
      ];

      final store = await (GetIt.instance<AppDatabase>()
          .storeMasterDao
          .readByDocId(singleTopos.tostrId!, null));

      final strName = store?.storeName;

      final toposData = POSParameterModel(
        docId: toposId,
        createDate: singleTopos.createDate,
        updateDate: singleTopos.updateDate,
        gtentId: singleTopos.gtentId,
        tostrId: singleTopos.tostrId,
        storeName: strName,
        tocsrId: singleTopos.tocsrId,
        baseUrl: singleTopos.baseUrl,
        usernameAdmin: singleTopos.usernameAdmin,
        passwordAdmin: singleTopos.passwordAdmin,
        otpChannel: singleTopos.otpChannel,
        lastSync: nextSyncDate,
      );

      await GetIt.instance<AppDatabase>()
          .posParameterDao
          .update(docId: toposId, data: toposData);

      for (final fetchFunction in fetchFunctions) {
        try {
          await fetchFunction();
        } catch (e) {
          handleError(e);
          rethrow;
        }
      }

      final toposAfterSync =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final singleToposAfterSync = toposAfterSync[0];

      // UPDATE STORE NAME
      try {
        final store = await (GetIt.instance<AppDatabase>()
            .storeMasterDao
            .readByDocId(singleTopos.tostrId!, null));

        final toposData = POSParameterModel(
          docId: singleToposAfterSync.docId,
          createDate: singleToposAfterSync.createDate,
          updateDate: singleToposAfterSync.updateDate,
          gtentId: singleToposAfterSync.gtentId,
          tostrId: singleToposAfterSync.tostrId,
          storeName: store?.storeName,
          tocsrId: singleToposAfterSync.tocsrId,
          baseUrl: singleToposAfterSync.baseUrl,
          usernameAdmin: singleToposAfterSync.usernameAdmin,
          passwordAdmin: singleToposAfterSync.passwordAdmin,
          otpChannel: singleToposAfterSync.otpChannel,
          lastSync: singleToposAfterSync.lastSync,
        );

        await GetIt.instance<AppDatabase>()
            .posParameterDao
            .update(docId: toposId, data: toposData);
      } catch (e) {
        handleError(e);
        rethrow;
      }
      // END OF UPDATE STORE NAME

      // REFRESH TOPRM
      log("INSERTING PROMOS...");
      final promos = <PromotionsModel>[];
      final today = DateTime.now().weekday;

      await GetIt.instance<AppDatabase>().promosDao.deletePromos();

      topsb = await GetIt.instance<AppDatabase>()
          .promoHargaSpesialHeaderDao
          .readAll();
      for (final header in topsb) {
        if (header.statusActive != 1) continue;

        final tpsb2 = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialAssignStoreDao
            .readByTopsbId(header.docId, null);
        final tpsb4 = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialCustomerGroupDao
            .readByTopsbId(header.docId, null);

        final dayProperties = {
          1: tpsb2.day1,
          2: tpsb2.day2,
          3: tpsb2.day3,
          4: tpsb2.day4,
          5: tpsb2.day5,
          6: tpsb2.day6,
          7: tpsb2.day7,
        };

        final isValid = dayProperties[today] == 1;

        if (isValid) {
          for (final customerGroup in tpsb4) {
            promos.add(PromotionsModel(
              docId: const Uuid().v4(),
              toitmId: header.toitmId,
              promoType: 202,
              promoId: header.docId,
              date: DateTime.now(),
              startTime: header.startTime,
              endTime: header.endTime,
              tocrgId: customerGroup.tocrgId,
              promoDescription: header.description,
              tocatId: null,
              remarks: null,
            ));
          }
        }
      }

      topmi =
          await GetIt.instance<AppDatabase>().promoMultiItemHeaderDao.readAll();
      for (final header in topmi) {
        if (header.statusActive != 1) continue;

        final tpmi1 = await GetIt.instance<AppDatabase>()
            .promoMultiItemBuyConditionDao
            .readByTopmiId(header.docId, null);
        final tpmi2 = await GetIt.instance<AppDatabase>()
            .promoMultiItemAssignStoreDao
            .readByTopmiId(header.docId, null);
        final tpmi5 = await GetIt.instance<AppDatabase>()
            .promoMultiItemCustomerGroupDao
            .readByTopmiId(header.docId, null);

        final dayProperties = {
          1: tpmi2.day1,
          2: tpmi2.day2,
          3: tpmi2.day3,
          4: tpmi2.day4,
          5: tpmi2.day5,
          6: tpmi2.day6,
          7: tpmi2.day7,
        };

        final isValid = dayProperties[today] == 1;
        if (isValid) {
          for (final buyCondition in tpmi1) {
            for (final customerGroup in tpmi5) {
              promos.add(PromotionsModel(
                docId: const Uuid().v4(),
                toitmId: buyCondition.toitmId,
                promoType: 206,
                promoId: header.docId,
                date: DateTime.now(),
                startTime: header.startTime,
                endTime: header.endTime,
                tocrgId: customerGroup.tocrgId,
                promoDescription: header.description,
                tocatId: null,
                remarks: null,
              ));
            }
          }
        }
      }

      topdi = await GetIt.instance<AppDatabase>()
          .promoDiskonItemHeaderDao
          .readAll();
      for (final header in topdi) {
        if (header.statusActive != 1) continue;

        final tpdi1 = await GetIt.instance<AppDatabase>()
            .promoDiskonItemBuyConditionDao
            .readByTopdiId(header.docId, null);
        final tpdi2 = await GetIt.instance<AppDatabase>()
            .promoDiskonItemAssignStoreDao
            .readByTopdiId(header.docId, null);
        final tpdi5 = await GetIt.instance<AppDatabase>()
            .promoDiskonItemCustomerGroupDao
            .readByTopdiId(header.docId, null);

        final dayProperties = {
          1: tpdi2.day1,
          2: tpdi2.day2,
          3: tpdi2.day3,
          4: tpdi2.day4,
          5: tpdi2.day5,
          6: tpdi2.day6,
          7: tpdi2.day7,
        };

        final isValid = dayProperties[today] == 1;
        if (isValid) {
          for (final buyCondition in tpdi1) {
            for (final customerGroup in tpdi5) {
              promos.add(PromotionsModel(
                docId: const Uuid().v4(),
                toitmId: buyCondition.toitmId,
                promoType: 203,
                promoId: header.docId,
                date: DateTime.now(),
                startTime: header.startTime,
                endTime: header.endTime,
                tocrgId: customerGroup.tocrgId,
                promoDescription: header.description,
                tocatId: null,
                remarks: null,
              ));
            }
          }
        }
      }

      topdg = await GetIt.instance<AppDatabase>()
          .promoDiskonGroupItemHeaderDao
          .readAll();

      for (final header in topdg) {
        if (header.statusActive != 1) continue;

        final tpdg1 = await GetIt.instance<AppDatabase>()
            .promoDiskonGroupItemBuyConditionDao
            .readByTopdgId(header.docId, null);
        final tpdg2 = await GetIt.instance<AppDatabase>()
            .promoDiskonGroupItemAssignStoreDao
            .readByTodgId(header.docId, null);
        final tpdg5 = await GetIt.instance<AppDatabase>()
            .promoDiskonGroupItemCustomerGroupDao
            .readByTopdgId(header.docId, null);
        final dayProperties = {
          1: tpdg2.day1,
          2: tpdg2.day2,
          3: tpdg2.day3,
          4: tpdg2.day4,
          5: tpdg2.day5,
          6: tpdg2.day6,
          7: tpdg2.day7,
        };

        final isValid = dayProperties[today] == 1;
        if (isValid) {
          for (final buyCondition in tpdg1) {
            for (final customerGroup in tpdg5) {
              final List<ItemMasterEntity> itemMastersByTocatId =
                  await GetIt.instance<AppDatabase>()
                      .itemMasterDao
                      .readAllByTocatId(tocatId: buyCondition.tocatId!);

              for (final itemMaster in itemMastersByTocatId) {
                promos.add(PromotionsModel(
                  docId: const Uuid().v4(),
                  toitmId: itemMaster.docId,
                  promoType: 204,
                  promoId: header.docId,
                  date: DateTime.now(),
                  startTime: header.startTime,
                  endTime: header.endTime,
                  tocrgId: customerGroup.tocrgId,
                  promoDescription: header.description,
                  tocatId: buyCondition.tocatId,
                  remarks: null,
                ));
              }
            }
          }
        }
      }

      toprb =
          await GetIt.instance<AppDatabase>().promoBuyXGetYHeaderDao.readAll();
      for (final header in toprb) {
        if (header.statusActive != 1) continue;

        final tprb1 = await GetIt.instance<AppDatabase>()
            .promoBuyXGetYBuyConditionDao
            .readByToprbId(header.docId, null);
        final tprb2 = await GetIt.instance<AppDatabase>()
            .promoBuyXGetYAssignStoreDao
            .readByToprbId(header.docId, null);

        final dayProperties = {
          1: tprb2.day1,
          2: tprb2.day2,
          3: tprb2.day3,
          4: tprb2.day4,
          5: tprb2.day5,
          6: tprb2.day6,
          7: tprb2.day7,
        };

        final isValid = dayProperties[today] == 1;
        if (isValid) {
          for (final buyCondition in tprb1) {
            // for (final customerGroup in tprb5) {
            promos.add(PromotionsModel(
              docId: const Uuid().v4(),
              toitmId: buyCondition.toitmId,
              promoType: 103,
              promoId: header.docId,
              date: DateTime.now(),
              startTime: header.startTime,
              endTime: header.endTime,
              tocrgId: null,
              promoDescription: header.description,
              tocatId: null,
              remarks: null,
            ));
            // }
          }
        }
      }

      await GetIt.instance<AppDatabase>().promosDao.bulkCreate(data: promos);
      log("PROMOS INSERTED");
      // END OF REFRESH TOPRM

      // fetched = tcurr.length +
      //     tocry.length +
      //     toprv.length +
      //     tozcd.length +
      //     tohem.length +
      //     tovat.length +
      //     topmt.length +
      //     tpmt1.length +
      //     tpmt2.length +
      //     topln.length +
      //     tostr.length +
      //     tpmt3.length +
      //     tocsr.length +
      //     touom.length +
      //     torol.length +
      //     tousr.length +
      //     tpln1.length +
      //     tocat.length +
      //     toitm.length +
      //     tsitm.length +
      //     tbitm.length +
      //     tritm.length +
      //     tovdg.length +
      //     toven.length +
      //     tvitm.length +
      //     tocrg.length +
      //     tocus.length +
      //     tpln2.length +
      //     tpln3.length +
      //     tpln4.length +
      //     topsb.length +
      //     tpsb1.length +
      //     tpsb2.length +
      //     tpsb4.length +
      //     topmi.length +
      //     tpmi1.length +
      //     tpmi2.length +
      //     tpmi4.length +
      //     tpmi5.length +
      //     topdi.length +
      //     tpdi1.length +
      //     tpdi2.length +
      //     tpdi4.length +
      //     tpdi5.length +
      //     topdg.length +
      //     tpdg1.length +
      //     tpdg2.length +
      //     tpdg4.length +
      //     tpdg5.length +
      //     toprb.length +
      //     tprb1.length +
      //     tprb2.length +
      //     tprb4.length +
      //     tprb5.length;

      // REFRESH TABLE ITEMS
      await GetIt.instance<AppDatabase>().refreshItemsTable();
      // END OF REFRESH TABLE ITEMS

      // Check Failed Invoices and Try to Send
      final invoices =
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.readAll();
      for (var invoice in invoices) {
        if (invoice.syncToBos!.isEmpty) {
          log("$invoice");
          try {
            final invDetails = await GetIt.instance<AppDatabase>()
                .invoiceDetailDao
                .readByToinvId(invoice.docId!, null);
            await GetIt.instance<InvoiceApi>()
                .sendFailedInvoice(invoice, invDetails);
          } catch (e) {
            final logErr = LogErrorModel(
                docId: const Uuid().v4(),
                createDate: DateTime.now(),
                updateDate: DateTime.now(),
                processInfo: "AutoSync: SendToinv",
                description: e.toString());
            await GetIt.instance<AppDatabase>()
                .logErrorDao
                .create(data: logErr);
          }
        }
      }
      prefs.setBool('isSyncing', false);
      log('Data synched - $checkSync');

      // VALIDATE INACTIVE tostr, tocsr, tousr, tohem
      try {
        await GetIt.instance<CheckCredentialActiveStatusUseCase>().call();
      } catch (e) {
        log("VALIDATE INACTIVE MASTER DATA Error: $e");
        await GetIt.instance<LogoutUseCase>().call();
        await NavigationHelper.go("/");
        SnackBarHelper.presentFailSnackBar(
            NavigationHelper.context, e.toString());
      }
      // END OF VALIDATE INACTIVE tostr, tohem, tocsr, tousr
    } catch (error, stack) {
      prefs.setBool('isSyncing', false);
      log("Error synchronizing: $error");
      debugPrintStack(stackTrace: stack);
    }
  } else {
    log("Sync is in progress");
    prefs.setBool('isSyncing', false);
  }
}

Future<void> resendFailedInv() async {
  final prefs = GetIt.instance<SharedPreferences>();

  bool? checkSync = prefs.getBool('isSyncing');
  log("Synching data... - $checkSync");
  if (checkSync == null || checkSync == false) {}
}
