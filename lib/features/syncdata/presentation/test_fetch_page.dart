import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/assign_price_member_per_store.dart';
import 'package:pos_fe/features/sales/data/models/authentication_store.dart';
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
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';
import 'package:pos_fe/features/sales/data/models/netzme_data.dart';
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
import 'package:pos_fe/features/syncdata/data/data_sources/remote/assign_price_member_per_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/auth_store_services.dart';
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
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_bonus_multi_item_assign_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_bonus_multi_item_buy_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_bonus_multi_item_customer_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_bonus_multi_item_get_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_bonus_multi_item_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_buy_x_get_y_assign_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_buy_x_get_y_buy_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_buy_x_get_y_customer_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_buy_x_get_y_get_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_buy_x_get_y_header_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_group_item_assign_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_group_item_buy_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_group_item_customer_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_group_item_get_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_group_item_header_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_item_assign_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_item_buy_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_item_customer_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_item_get_condition_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_diskon_item_header_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_harga_spesial_assign_store.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_harga_spesial_buy_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_harga_spesial_customer_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/promo_harga_spesial_header_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_role_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_group_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/vendor_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/zipcode_service.dart';
import 'package:pos_fe/features/syncdata/domain/usecases/fetch_bos_token.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final TextEditingController _docIdController = TextEditingController();
  final AuthApi _authApi = AuthApi();

  String _token = '';
  String _singleData = '';
  int _dataCount = 0;
  int _dataFetched = 0;
  String _dataExample = '';
  int _statusCode = 0;
  String _errorMessage = '';
  double _syncProgress = 0.0;
  int totalTable = 59;
  int fetched = 0;

  void _fetchToken() async {
    print("Fetching token...");
    final token =
        await _authApi.fetchAuthToken("interfacing@sesa.com", "BeOne\$\$123");
    if (token != null) {
      print("Token received: ${token.token}");
      setState(() {
        _token = token.token;
      });
    }
  }

  void manualSyncData() async {
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
    late List<NetzmeModel> tntzm;

    print("Synching data...");
    try {
      final topos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final singleTopos = topos[0];
      final toposId = singleTopos.docId;
      final lastSyncDate = topos[0].lastSync!;

      final fetchFunctions = [
        () async {
          try {
            tcurr = await GetIt.instance<CurrencyApi>().fetchData(lastSyncDate);
            final tcurrDb =
                await GetIt.instance<AppDatabase>().currencyDao.readAll();

            if (tcurrDb.isNotEmpty) {
              final tcurrDbMap = {
                for (var datum in tcurrDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<CurrencyApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .currencyDao
                  .bulkCreate(data: tcurr);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tocry = await GetIt.instance<CountryApi>().fetchData(lastSyncDate);
            final tocryDb =
                await GetIt.instance<AppDatabase>().countryDao.readAll();

            if (tocryDb.isNotEmpty) {
              final tocryDbMap = {
                for (var datum in tocryDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<CountryApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .countryDao
                  .bulkCreate(data: tocry);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            toprv = await GetIt.instance<ProvinceApi>().fetchData(lastSyncDate);
            final toprvDb =
                await GetIt.instance<AppDatabase>().provinceDao.readAll();

            if (toprvDb.isNotEmpty) {
              final toprvDbMap = {
                for (var datum in toprvDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ProvinceApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .provinceDao
                  .bulkCreate(data: toprv);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tozcd = await GetIt.instance<ZipcodeApi>().fetchData(lastSyncDate);
            final tozcdDb =
                await GetIt.instance<AppDatabase>().zipcodeDao.readAll();

            if (tozcdDb.isNotEmpty) {
              final tozcdDbMap = {
                for (var datum in tozcdDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ZipcodeApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .zipcodeDao
                  .bulkCreate(data: tozcd);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tohem = await GetIt.instance<EmployeeApi>().fetchData(lastSyncDate);
            final tohemDb =
                await GetIt.instance<AppDatabase>().employeeDao.readAll();

            if (tohemDb.isNotEmpty) {
              final tohemDbMap = {
                for (var datum in tohemDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<EmployeeApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .employeeDao
                  .bulkCreate(data: tohem);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tovat =
                await GetIt.instance<TaxMasterApi>().fetchData(lastSyncDate);
            final tovatDb =
                await GetIt.instance<AppDatabase>().taxMasterDao.readAll();

            if (tovatDb.isNotEmpty) {
              final tovatDbMap = {
                for (var datum in tovatDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<TaxMasterApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .taxMasterDao
                  .bulkCreate(data: tovat);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            topmt =
                await GetIt.instance<PaymentTypeApi>().fetchData(lastSyncDate);
            final topmtDb =
                await GetIt.instance<AppDatabase>().paymentTypeDao.readAll();

            if (topmtDb.isNotEmpty) {
              final topmtDbMap = {
                for (var datum in topmtDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PaymentTypeApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .paymentTypeDao
                  .bulkCreate(data: topmt);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmt1 = await GetIt.instance<MOPApi>().fetchData(lastSyncDate);
            final tpmt1Db =
                await GetIt.instance<AppDatabase>().meansOfPaymentDao.readAll();

            if (tpmt1Db.isNotEmpty) {
              final tpmt1DbMap = {
                for (var datum in tpmt1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<MOPApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .meansOfPaymentDao
                  .bulkCreate(data: tpmt1);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmt2 =
                await GetIt.instance<CreditCardApi>().fetchData(lastSyncDate);
            final tpmt2Db =
                await GetIt.instance<AppDatabase>().creditCardDao.readAll();

            if (tpmt2Db.isNotEmpty) {
              final tpmt2DbMap = {
                for (var datum in tpmt2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<CreditCardApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .creditCardDao
                  .bulkCreate(data: tpmt2);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            topln =
                await GetIt.instance<PricelistApi>().fetchData(lastSyncDate);
            final toplnDb =
                await GetIt.instance<AppDatabase>().pricelistDao.readAll();

            if (toplnDb.isNotEmpty) {
              final toplnDbMap = {
                for (var datum in toplnDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PricelistApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .pricelistDao
                  .bulkCreate(data: topln);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tostr =
                await GetIt.instance<StoreMasterApi>().fetchData(lastSyncDate);
            final tostrDb =
                await GetIt.instance<AppDatabase>().storeMasterDao.readAll();

            if (tostrDb.isNotEmpty) {
              final tostrDbMap = {
                for (var datum in tostrDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<StoreMasterApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .storeMasterDao
                  .bulkCreate(data: tostr);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmt3 =
                await GetIt.instance<MOPByStoreApi>().fetchData(lastSyncDate);
            final tpmt3Db =
                await GetIt.instance<AppDatabase>().mopByStoreDao.readAll();

            if (tpmt3Db.isNotEmpty) {
              final tpmt3DbMap = {
                for (var datum in tpmt3Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<MOPByStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .mopByStoreDao
                  .bulkCreate(data: tpmt3);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tocsr =
                await GetIt.instance<CashRegisterApi>().fetchData(lastSyncDate);
            final tocsrDb =
                await GetIt.instance<AppDatabase>().cashRegisterDao.readAll();

            if (tocsrDb.isNotEmpty) {
              final tocsrDbMap = {
                for (var datum in tocsrDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<CashRegisterApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .cashRegisterDao
                  .bulkCreate(data: tocsr);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            touom = await GetIt.instance<UoMApi>().fetchData(lastSyncDate);
            final touomDb =
                await GetIt.instance<AppDatabase>().uomDao.readAll();

            if (touomDb.isNotEmpty) {
              final touomDbMap = {
                for (var datum in touomDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<UoMApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .uomDao
                  .bulkCreate(data: touom);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            torol = await GetIt.instance<UserRoleApi>().fetchData(lastSyncDate);
            final torolDb =
                await GetIt.instance<AppDatabase>().userRoleDao.readAll();

            if (torolDb.isNotEmpty) {
              final torolDbMap = {
                for (var datum in torolDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<UserRoleApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .userRoleDao
                  .bulkCreate(data: torol);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tousr = await GetIt.instance<UserApi>().fetchData(lastSyncDate);
            final tousrDb =
                await GetIt.instance<AppDatabase>().userDao.readAll();

            if (tousrDb.isNotEmpty) {
              final tousrDbMap = {
                for (var datum in tousrDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<UserApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .userDao
                  .bulkCreate(data: tousr);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpln1 = await GetIt.instance<PricelistPeriodApi>()
                .fetchData(lastSyncDate);
            final tpln1Db = await GetIt.instance<AppDatabase>()
                .pricelistPeriodDao
                .readAll();

            if (tpln1Db.isNotEmpty) {
              final tpln1DbMap = {
                for (var datum in tpln1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PricelistPeriodApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .pricelistPeriodDao
                  .bulkCreate(data: tpln1);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tocat =
                await GetIt.instance<ItemCategoryApi>().fetchData(lastSyncDate);
            final tocatDb =
                await GetIt.instance<AppDatabase>().itemCategoryDao.readAll();

            if (tocatDb.isNotEmpty) {
              final tocatDbMap = {
                for (var datum in tocatDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ItemCategoryApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemCategoryDao
                  .bulkCreate(data: tocat);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            toitm =
                await GetIt.instance<ItemMasterApi>().fetchData(lastSyncDate);
            final toitmDb =
                await GetIt.instance<AppDatabase>().itemMasterDao.readAll();

            if (toitmDb.isNotEmpty) {
              final toitmDbMap = {
                for (var datum in toitmDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ItemMasterApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemMasterDao
                  .bulkCreate(data: toitm);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
          } catch (e, s) {
            debugPrintStack(stackTrace: s);
            if (e is DatabaseException) {
              log('DatabaseException occurred: $e');
            } else {
              rethrow;
            }
          }
        },
        () async {
          try {
            tsitm =
                await GetIt.instance<ItemByStoreApi>().fetchData(lastSyncDate);
            final tsitmDb =
                await GetIt.instance<AppDatabase>().itemByStoreDao.readAll();

            if (tsitmDb.isNotEmpty) {
              final tsitmDbMap = {
                for (var datum in tsitmDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ItemByStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemByStoreDao
                  .bulkCreate(data: tsitm);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tbitm =
                await GetIt.instance<ItemBarcodeApi>().fetchData(lastSyncDate);
            final tbitmDb =
                await GetIt.instance<AppDatabase>().itemBarcodeDao.readAll();

            if (tbitmDb.isNotEmpty) {
              final tbitmDbMap = {
                for (var datum in tbitmDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ItemBarcodeApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemBarcodeDao
                  .bulkCreate(data: tbitm);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
          } catch (e) {
            if (e is DatabaseException) {
              log('DatabaseException occurred: $e');
            } else {
              rethrow;
            }
          }
        },
        // // ---
        () async {
          try {
            tritm =
                await GetIt.instance<ItemRemarksApi>().fetchData(lastSyncDate);
            final tritmDb =
                await GetIt.instance<AppDatabase>().itemRemarkDao.readAll();

            if (tritmDb.isNotEmpty) {
              final tritmDbMap = {
                for (var datum in tritmDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<ItemRemarksApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .itemRemarkDao
                  .bulkCreate(data: tritm);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tovdg =
                await GetIt.instance<VendorGroupApi>().fetchData(lastSyncDate);
            final tovdgDb =
                await GetIt.instance<AppDatabase>().vendorGroupDao.readAll();

            if (tovdgDb.isNotEmpty) {
              final tovdgDbMap = {
                for (var datum in tovdgDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<VendorGroupApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .vendorGroupDao
                  .bulkCreate(data: tovdg);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            toven = await GetIt.instance<VendorApi>().fetchData(lastSyncDate);
            final tovenDb =
                await GetIt.instance<AppDatabase>().vendorDao.readAll();

            if (tovenDb.isNotEmpty) {
              final tovenDbMap = {
                for (var datum in tovenDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<VendorApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .vendorDao
                  .bulkCreate(data: toven);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tvitm = await GetIt.instance<PreferredVendorApi>()
                .fetchData(lastSyncDate);
            final tvitmDb = await GetIt.instance<AppDatabase>()
                .preferredVendorDao
                .readAll();

            if (tvitmDb.isNotEmpty) {
              final tvitmDbMap = {
                for (var datum in tvitmDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PreferredVendorApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .preferredVendorDao
                  .bulkCreate(data: tvitm);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
          } catch (e) {
            if (e is DatabaseException) {
              log('DatabaseException occurred: $e');
            } else {
              rethrow;
            }
          }
        },
        // // ---
        () async {
          try {
            tocrg = await GetIt.instance<CustomerGroupApi>()
                .fetchData(lastSyncDate);
            final tocrgDb =
                await GetIt.instance<AppDatabase>().customerGroupDao.readAll();

            if (tocrgDb.isNotEmpty) {
              final tocrgDbMap = {
                for (var datum in tocrgDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<CustomerGroupApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .customerGroupDao
                  .bulkCreate(data: tocrg);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tocus = await GetIt.instance<CustomerApi>().fetchData(lastSyncDate);
            final tocusDb = await GetIt.instance<AppDatabase>()
                .customerCstDao
                .readAll(searchKeyword: '');

            if (tocusDb.isNotEmpty) {
              final tocusDbMap = {
                for (var datum in tocusDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<CustomerApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .customerCstDao
                  .bulkCreate(data: tocus);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpln2 =
                await GetIt.instance<PriceByItemApi>().fetchData(lastSyncDate);
            final tpln2Db =
                await GetIt.instance<AppDatabase>().priceByItemDao.readAll();

            if (tpln2Db.isNotEmpty) {
              final tpln2DbMap = {
                for (var datum in tpln2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PriceByItemApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .priceByItemDao
                  .bulkCreate(data: tpln2);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpln3 = await GetIt.instance<APMPSApi>().fetchData(lastSyncDate);
            final tpln3Db = await GetIt.instance<AppDatabase>()
                .assignPriceMemberPerStoreDao
                .readAll();

            if (tpln3Db.isNotEmpty) {
              final tpln3DbMap = {
                for (var datum in tpln3Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<APMPSApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .assignPriceMemberPerStoreDao
                  .bulkCreate(data: tpln3);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpln4 = await GetIt.instance<PriceByItemBarcodeApi>()
                .fetchData(lastSyncDate);
            final tpln4Db = await GetIt.instance<AppDatabase>()
                .priceByItemBarcodeDao
                .readAll();

            if (tpln4Db.isNotEmpty) {
              final tpln4DbMap = {
                for (var datum in tpln4Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PriceByItemBarcodeApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .priceByItemBarcodeDao
                  .bulkCreate(data: tpln4);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tastr =
                await GetIt.instance<AuthStoreApi>().fetchData(lastSyncDate);
            final tastrDb =
                await GetIt.instance<AppDatabase>().authStoreDao.readAll();

            if (tastrDb.isNotEmpty) {
              final tastrDbMap = {
                for (var datum in tastrDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .authStoreDao
                  .bulkCreate(data: tastr);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            topsb = await GetIt.instance<PromoHargaSpesialApi>()
                .fetchData(lastSyncDate);
            final topsbDb = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialHeaderDao
                .readAll();

            if (topsbDb.isNotEmpty) {
              final topsbDbMap = {
                for (var datum in topsbDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoHargaSpesialApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialHeaderDao
                  .bulkCreate(data: topsb);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpsb1 = await GetIt.instance<PromoHargaSpesialBuyApi>()
                .fetchData(lastSyncDate);
            final tpsb1Db = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialBuyDao
                .readAll();

            if (tpsb1Db.isNotEmpty) {
              final tpsb1DbMap = {
                for (var datum in tpsb1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoHargaSpesialBuyApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialBuyDao
                  .bulkCreate(data: tpsb1);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpsb2 = await GetIt.instance<PromoHargaSpesialAssignStoreApi>()
                .fetchData(lastSyncDate);
            final tpsb2Db = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialAssignStoreDao
                .readAll();

            if (tpsb2Db.isNotEmpty) {
              final tpsb2DbMap = {
                for (var datum in tpsb2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoHargaSpesialAssignStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialAssignStoreDao
                  .bulkCreate(data: tpsb2);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpsb4 = await GetIt.instance<PromoHargaSpesialCustomerGroupApi>()
                .fetchData(lastSyncDate);
            final tpsb4Db = await GetIt.instance<AppDatabase>()
                .promoHargaSpesialCustomerGroupDao
                .readAll();

            if (tpsb4Db.isNotEmpty) {
              final tpsb4DbMap = {
                for (var datum in tpsb4Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoHargaSpesialCustomerGroupApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoHargaSpesialCustomerGroupDao
                  .bulkCreate(data: tpsb4);
            }

            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            topmi = await GetIt.instance<PromoBonusMultiItemHeaderApi>()
                .fetchData(lastSyncDate);
            final topmiDb = await GetIt.instance<AppDatabase>()
                .promoMultiItemHeaderDao
                .readAll();

            if (topmiDb.isNotEmpty) {
              final topmiDbMap = {
                for (var datum in topmiDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemHeaderDao
                  .bulkCreate(data: topmi);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmi1 = await GetIt.instance<PromoBonusMultiItemBuyConditionApi>()
                .fetchData(lastSyncDate);
            final tpmi1Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemBuyConditionDao
                .readAll();

            if (tpmi1Db.isNotEmpty) {
              final tpmi1DbMap = {
                for (var datum in tpmi1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBonusMultiItemBuyConditionApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemBuyConditionDao
                  .bulkCreate(data: tpmi1);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmi2 = await GetIt.instance<PromoBonusMultiItemAssignStoreApi>()
                .fetchData(lastSyncDate);
            final tpmi2Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemAssignStoreDao
                .readAll();

            if (tpmi2Db.isNotEmpty) {
              final tpmi2DbMap = {
                for (var datum in tpmi2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBonusMultiItemAssignStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemAssignStoreDao
                  .bulkCreate(data: tpmi2);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmi4 = await GetIt.instance<PromoBonusMultiItemGetConditionApi>()
                .fetchData(lastSyncDate);
            final tpmi4Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemGetConditionDao
                .readAll();

            if (tpmi4Db.isNotEmpty) {
              final tpmi4DbMap = {
                for (var datum in tpmi4Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBonusMultiItemGetConditionApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemGetConditionDao
                  .bulkCreate(data: tpmi4);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpmi5 = await GetIt.instance<PromoBonusMultiItemCustomerGroupApi>()
                .fetchData(lastSyncDate);
            final tpmi5Db = await GetIt.instance<AppDatabase>()
                .promoMultiItemCustomerGroupDao
                .readAll();

            if (tpmi5Db.isNotEmpty) {
              final tpmi5DbMap = {
                for (var datum in tpmi5Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBonusMultiItemCustomerGroupApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoMultiItemCustomerGroupDao
                  .bulkCreate(data: tpmi5);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            topdi = await GetIt.instance<PromoDiskonItemHeaderApi>()
                .fetchData(lastSyncDate);
            final topdiDb = await GetIt.instance<AppDatabase>()
                .promoDiskonItemHeaderDao
                .readAll();

            if (topdiDb.isNotEmpty) {
              final topdiDbMap = {
                for (var datum in topdiDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoDiskonItemHeaderApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemHeaderDao
                  .bulkCreate(data: topdi);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdi1 = await GetIt.instance<PromoDiskonItemBuyConditionApi>()
                .fetchData(lastSyncDate);
            final tpdi1Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemBuyConditionDao
                .readAll();

            if (tpdi1Db.isNotEmpty) {
              final tpdi1DbMap = {
                for (var datum in tpdi1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoDiskonItemBuyConditionApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemBuyConditionDao
                  .bulkCreate(data: tpdi1);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdi2 = await GetIt.instance<PromoDiskonItemAssignStoreApi>()
                .fetchData(lastSyncDate);
            final tpdi2Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemAssignStoreDao
                .readAll();

            if (tpdi2Db.isNotEmpty) {
              final tpdi2DbMap = {
                for (var datum in tpdi2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoDiskonItemAssignStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemAssignStoreDao
                  .bulkCreate(data: tpdi2);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdi4 = await GetIt.instance<PromoDiskonItemGetConditionApi>()
                .fetchData(lastSyncDate);
            final tpdi4Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemGetConditionDao
                .readAll();

            if (tpdi4Db.isNotEmpty) {
              final tpdi4DbMap = {
                for (var datum in tpdi4Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemGetConditionDao
                  .bulkCreate(data: tpdi4);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdi5 = await GetIt.instance<PromoDiskonItemCustomerGroupApi>()
                .fetchData(lastSyncDate);
            final tpdi5Db = await GetIt.instance<AppDatabase>()
                .promoDiskonItemCustomerGroupDao
                .readAll();

            if (tpdi5Db.isNotEmpty) {
              final tpdi5DbMap = {
                for (var datum in tpdi5Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonItemCustomerGroupDao
                  .bulkCreate(data: tpdi5);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            topdg = await GetIt.instance<PromoDiskonGroupItemHeaderApi>()
                .fetchData(lastSyncDate);
            final topdgDb = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemHeaderDao
                .readAll();

            if (topdgDb.isNotEmpty) {
              final topdgDbMap = {
                for (var datum in topdgDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoDiskonGroupItemHeaderApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemHeaderDao
                  .bulkCreate(data: topdg);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdg1 = await GetIt.instance<PromoDiskonGroupItemBuyConditionApi>()
                .fetchData(lastSyncDate);
            final tpdg1Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemBuyConditionDao
                .readAll();

            if (tpdg1Db.isNotEmpty) {
              final tpdg1DbMap = {
                for (var datum in tpdg1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemBuyConditionDao
                  .bulkCreate(data: tpdg1);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdg2 = await GetIt.instance<PromoDiskonGroupItemAssignStoreApi>()
                .fetchData(lastSyncDate);
            final tpdg2Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemAssignStoreDao
                .readAll();

            if (tpdg2Db.isNotEmpty) {
              final tpdg2DbMap = {
                for (var datum in tpdg2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemAssignStoreDao
                  .bulkCreate(data: tpdg2);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdg4 = await GetIt.instance<PromoDiskonGroupItemGetConditionApi>()
                .fetchData(lastSyncDate);
            final tpdg4Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemGetConditionDao
                .readAll();

            if (tpdg4Db.isNotEmpty) {
              final tpdg4DbMap = {
                for (var datum in tpdg4Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoDiskonGroupItemGetConditionApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemGetConditionDao
                  .bulkCreate(data: tpdg4);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tpdg5 = await GetIt.instance<PromoDiskonGroupItemCustomerGroupApi>()
                .fetchData(lastSyncDate);
            final tpdg5Db = await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemCustomerGroupDao
                .readAll();

            if (tpdg5Db.isNotEmpty) {
              final tpdg5DbMap = {
                for (var datum in tpdg5Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoDiskonGroupItemCustomerGroupDao
                  .bulkCreate(data: tpdg5);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            toprb = await GetIt.instance<PromoBuyXGetYHeaderApi>()
                .fetchData(lastSyncDate);
            final toprbDb = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYHeaderDao
                .readAll();

            if (toprbDb.isNotEmpty) {
              final toprbDbMap = {
                for (var datum in toprbDb) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYHeaderDao
                  .bulkCreate(data: toprb);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tprb1 = await GetIt.instance<PromoBuyXGetYBuyConditionApi>()
                .fetchData(lastSyncDate);
            final tprb1Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYBuyConditionDao
                .readAll();

            if (tprb1Db.isNotEmpty) {
              final tprb1DbMap = {
                for (var datum in tprb1Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBuyXGetYBuyConditionApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYBuyConditionDao
                  .bulkCreate(data: tprb1);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tprb2 = await GetIt.instance<PromoBuyXGetYAssignStoreApi>()
                .fetchData(lastSyncDate);
            final tprb2Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYAssignStoreDao
                .readAll();

            if (tprb2Db.isNotEmpty) {
              final tprb2DbMap = {
                for (var datum in tprb2Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<AuthStoreApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYAssignStoreDao
                  .bulkCreate(data: tprb2);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tprb4 = await GetIt.instance<PromoBuyXGetYGetConditionApi>()
                .fetchData(lastSyncDate);
            final tprb4Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYGetConditionDao
                .readAll();

            if (tprb4Db.isNotEmpty) {
              final tprb4DbMap = {
                for (var datum in tprb4Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBuyXGetYGetConditionApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYGetConditionDao
                  .bulkCreate(data: tprb4);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tprb5 = await GetIt.instance<PromoBuyXGetYCustomerGroupApi>()
                .fetchData(lastSyncDate);
            final tprb5Db = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYCustomerGroupDao
                .readAll();

            if (tprb5Db.isNotEmpty) {
              final tprb5DbMap = {
                for (var datum in tprb5Db) datum.docId: datum
              };

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
              // final allData = await GetIt.instance<PromoBuyXGetYCustomerGroupApi>()
              //     .fetchData("2000-01-01 00:00:00");
              await GetIt.instance<AppDatabase>()
                  .promoBuyXGetYCustomerGroupDao
                  .bulkCreate(data: tprb5);
            }
            setState(() {
              _syncProgress += 1 / totalTable;
            });
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
            tntzm = [
              NetzmeModel(
                  docId: const Uuid().v4(),
                  url: "http://tokoapisnap-stg.netzme.com",
                  clientKey: "pt_bak",
                  clientSecret: "61272364208846ee9366dc204f81fce6",
                  privateKey:
                      "MIIBOgIBAAJBAMjxtB9QVz9KLCe5DAqJoLlz7e9ZhS5EE5YhC0E1F7+a14GLpm7mqcSN0alAmOK5DQZW4JufhzFmDpwB3a4+vskCAwEAAQJAfDYkcILaG64+0yMo1U6zwk9uEdkVYT8FmHS+n0Uxc+cqgs9UGb8uFoZmswGhs5HpfxpgEOckucwqi4SrgqXWMQIhAM4DOyj8SVCbvieRjOruhLjuh6S9wQmingB7A9+b58bVAiEA+bOjL0CothyHnfNgaY2IBT9TIO0FefTE1IfcukbH+iUCIHeyTOdNXlOlieB3owbFOvwwK0O+tLAieecRkniTnyFZAiA5uQsqKzpVDvdSziYlgHBHNkJTRDeV3714nAeskBw+eQIhAKkIuZjqXadPACYDNUXrfm5GGWZ2BKUjujJIZXjaRLnA",
                  custIdMerchant: "M_b7uJH43W")
            ];
            await GetIt.instance<AppDatabase>()
                .netzmeDao
                .bulkCreate(data: tntzm);
            setState(() {
              _syncProgress += 1 / totalTable;
            });
          } catch (e) {
            if (e is DatabaseException) {
              log('DatabaseException occurred: $e');
            } else {
              rethrow;
            }
          }
        },
      ];
      for (final fetchFunction in fetchFunctions) {
        try {
          await fetchFunction();
          final nextSyncDate = DateTime.now().toUtc().toIso8601String();

          final toposData = POSParameterModel(
            docId: toposId,
            createDate: singleTopos.createDate,
            updateDate: singleTopos.updateDate,
            gtentId: singleTopos.gtentId,
            tostrId: singleTopos.tostrId,
            storeName: singleTopos.storeName,
            tocsrId: singleTopos.tocsrId,
            baseUrl: singleTopos.baseUrl,
            usernameAdmin: singleTopos.usernameAdmin,
            passwordAdmin: singleTopos.passwordAdmin,
            lastSync: nextSyncDate,
          );

          await GetIt.instance<AppDatabase>()
              .posParameterDao
              .update(docId: toposId, data: toposData);
        } catch (e) {
          handleError(e);
          rethrow;
        }
      }

      final promos = <PromotionsModel>[];
      final today = DateTime.now().weekday;

      for (final header in topsb) {
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

      for (final header in topmi) {
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

      for (final header in topdi) {
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

      for (final header in topdg) {
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

      for (final header in toprb) {
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

      // log("$tpln4\n");

      // final topos =
      //     await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      // final store = await GetIt.instance<AppDatabase>()
      //     .storeMasterDao
      //     .readByDocId(topos[0].tostrId!, null);

      // final posParameter = {
      //   "docid": topos[0].docId,
      //   "createdate": topos[0].createDate.toString(),
      //   "updatedate": DateTime.now().toString(),
      //   "gtentId": topos[0].gtentId,
      //   "tostrId": topos[0].tostrId,
      //   "storename": store!.storeName,
      //   "tocsrId": topos[0].tocsrId,
      //   "baseUrl": topos[0].baseUrl,
      //   "usernameAdmin": topos[0].usernameAdmin,
      //   "passwordAdmin": topos[0].passwordAdmin,
      // };
      // final posData = POSParameterModel.fromMap(posParameter);

      // await GetIt.instance<AppDatabase>()
      //     .posParameterDao
      //     .update(docId: topos[0].docId, data: posData);

      fetched = tcurr.length +
          tocry.length +
          toprv.length +
          tozcd.length +
          tohem.length +
          tovat.length +
          topmt.length +
          tpmt1.length +
          tpmt2.length +
          topln.length +
          tostr.length +
          tpmt3.length +
          tocsr.length +
          touom.length +
          torol.length +
          tousr.length +
          tpln1.length +
          tocat.length +
          toitm.length +
          tsitm.length +
          tbitm.length +
          tritm.length +
          tovdg.length +
          toven.length +
          tvitm.length +
          tocrg.length +
          tocus.length +
          tpln2.length +
          tpln3.length +
          tpln4.length +
          topsb.length +
          tpsb1.length +
          tpsb2.length +
          tpsb4.length +
          topmi.length +
          tpmi1.length +
          tpmi2.length +
          tpmi4.length +
          tpmi5.length +
          topdi.length +
          tpdi1.length +
          tpdi2.length +
          tpdi4.length +
          tpdi5.length +
          topdg.length +
          tpdg1.length +
          tpdg2.length +
          tpdg4.length +
          tpdg5.length +
          toprb.length +
          tprb1.length +
          tprb2.length +
          tprb4.length +
          tprb5.length;

      await GetIt.instance<AppDatabase>().refreshItemsTable();

      setState(() {
        _dataCount = fetched;
        _syncProgress = 1.0;
      });
      print('Data synched');
    } catch (error, stack) {
      print("Error synchronizing: $error");
      debugPrintStack(stackTrace: stack);
    }
  }

  void _fetchData() async {
    print('Fetching data...');
    try {
      final topos =
          await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final singleTopos = topos[0];
      final toposId = singleTopos.docId;
      final lastSyncDate = topos[0].lastSync!;

      final tocus =
          await GetIt.instance<AuthStoreApi>().fetchData(lastSyncDate);
      final tocusDb =
          await GetIt.instance<AppDatabase>().authStoreDao.readAll();
      log("tocusDb $tocusDb");

      if (tocusDb.isNotEmpty) {
        log("DB NOT EMPTY");
        final tocusDbMap = {for (var datum in tocusDb) datum.docId: datum};

        for (final datumBos in tocus) {
          final datumDb = tocusDbMap[datumBos.docId];

          if (datumDb != null) {
            if (datumBos.form == "U" &&
                (datumBos.updateDate?.isAfter(DateTime.parse(lastSyncDate)) ??
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
        log("DB EMPTY - $tocus");
        final allData = await GetIt.instance<AuthStoreApi>()
            .fetchData("2000-01-01 00:00:00");
        await GetIt.instance<AppDatabase>()
            .authStoreDao
            .bulkCreate(data: allData);
      }

      final nextSyncDate = DateTime.now().toUtc().toIso8601String();

      final toposData = POSParameterModel(
        docId: toposId,
        createDate: singleTopos.createDate,
        updateDate: singleTopos.updateDate,
        gtentId: singleTopos.gtentId,
        tostrId: singleTopos.tostrId,
        storeName: singleTopos.storeName,
        tocsrId: singleTopos.tocsrId,
        baseUrl: singleTopos.baseUrl,
        usernameAdmin: singleTopos.usernameAdmin,
        passwordAdmin: singleTopos.passwordAdmin,
        lastSync: nextSyncDate,
      );

      await GetIt.instance<AppDatabase>()
          .posParameterDao
          .update(docId: toposId, data: toposData);

      print("Data Fetched");
    } catch (error) {
      print('Error: $error');
      handleError(error);
      setState(() {
        _statusCode = handleError(error)['statusCode'];
        _errorMessage = handleError(error)['message'];
        _clearErrorMessageAfterDelay();
      });
    }
  }

  Future<String> _fetchSingleData() async {
    try {
      // final signature = await GetIt.instance<NetzmeApi>().createSignature();
      // log(signature);
      // final accessToken =
      //     await GetIt.instance<NetzmeApi>().requestAccessToken(signature);
      // log(accessToken);
      // final serviceSignature =
      //     await GetIt.instance<NetzmeApi>().createSignatureService(accessToken);
      // log(serviceSignature);
      // final transactionQris = await GetIt.instance<NetzmeApi>()
      //     .createTransactionQRIS(serviceSignature);
      // log("$transactionQris");

      // print("Data Fetched");

      return "";
    } catch (error) {
      handleError(error);
      setState(() {
        _statusCode = handleError(error)['statusCode'];
        _errorMessage = handleError(error)['message'];
        _clearErrorMessageAfterDelay();
      });
      rethrow;
    }
  }

  void _clearErrorMessageAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _statusCode = 0;
        _errorMessage = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
        title: Text('Sync Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: LinearProgressIndicator(
                        value: _syncProgress,
                        backgroundColor:
                            const Color.fromARGB(255, 184, 183, 183),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _syncProgress == 1.0
                            ? "Data Synced: $fetched"
                            : "${(_syncProgress * 100).round().toString()}%",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    // _fetchToken();
                    manualSyncData();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(ProjectColors.primary),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: Text(
                    'Sync',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () async {
                    await GetIt.instance<AppDatabase>().resetDatabase();
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: ProjectColors.primary,
                          width: 2,
                        ))),
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 234, 234, 234)),
                    foregroundColor:
                        MaterialStatePropertyAll(ProjectColors.primary),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  _fetchData();
                },
                child: Text('TEST'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _docIdController.dispose();
    super.dispose();
  }
}
