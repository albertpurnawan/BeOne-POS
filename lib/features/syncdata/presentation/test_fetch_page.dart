import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/assign_price_member_per_store.dart';
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
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
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

  // void updateFromBOS() async {
  //   late List<CurrencyModel> currenciesBOS, currenciesDAO;
  //   late List<CountryModel> countriesBOS, countriesDAO;
  //   late List<ProvinceModel> provincesBOS, provincesDAO;
  //   late List<ZipCodeModel> zipcodesBOS, zipcodesDAO;
  //   late List<EmployeeModel> employeesBOS, employeesDAO;
  //   late List<TaxMasterModel> taxesBOS, taxesDAO;
  //   late List<PaymentTypeModel> payTypesBOS, payTypesDAO;
  //   late List<MeansOfPaymentModel> mopsBOS, mopsDAO;
  //   late List<CreditCardModel> ccsBOS, ccsDAO;
  //   late List<PricelistModel> pricelistsBOS, pricelistsDAO;
  //   late List<StoreMasterModel> storesBOS, storesDAO;
  //   late List<MOPByStoreModel> mopStoresBOS, mopStoresDAO;
  //   late List<CashRegisterModel> cashiersBOS, cashiersDAO;
  //   late List<UomModel> uomsBOS, uomsDAO;
  //   late List<UserRoleModel> rolesBOS, rolesDAO;
  //   late List<UserModel> usersBOS, usersDAO;
  //   late List<PricelistPeriodModel> pricelistPeriodBOS, pricelistPeriodDAO;
  //   late List<ItemCategoryModel> itemCatBOS, itemCatDAO;
  //   late List<ItemMasterModel> itemsBOS, itemsDAO;
  //   late List<ItemByStoreModel> itemsStoresBOS, itemsStoresDAO;
  //   late List<ItemBarcodeModel> itemBarcodesBOS, itemBarcodesDAO;
  //   late List<ItemRemarksModel> itemRemarksBOS, itemRemarksDAO;
  //   late List<VendorGroupModel> venGroupsBOS, venGroupsDAO;
  //   late List<VendorModel> vendorBOS, vendorDAO;
  //   late List<PreferredVendorModel> prefVendorBOS, prefVendorDAO;
  //   late List<CustomerGroupModel> cusGroupBOS, cusGroupDAO;
  //   late List<CustomerCstModel> cusCstBOS, cusCstDAO;
  //   late List<PriceByItemModel> priceByItemBOS, priceByItemDAO;
  //   late List<AssignPriceMemberPerStoreModel> apmpsBOS, apmpsDAO;
  //   late List<PriceByItemBarcodeModel> priceItemBarcodeBOS, priceItemBarcodeDAO;

  //   final fetchFunctions = [
  //     () async {
  //       currenciesBOS = await GetIt.instance<CurrencyApi>().fetchData();
  //       currenciesDAO =
  //           await GetIt.instance<AppDatabase>().currencyDao.readAll();

  //       if (currenciesDAO.isEmpty) {
  //         await GetIt.instance<AppDatabase>()
  //             .currencyDao
  //             .bulkCreate(data: currenciesBOS);
  //         return;
  //       }

  //       for (var currencyBOS in currenciesBOS) {
  //         CurrencyModel? currencyDAO;
  //         try {
  //           currencyDAO = currenciesDAO.firstWhere(
  //             (currency) => currency.docId == currencyBOS.docId,
  //           );
  //         } catch (e) {
  //           currencyDAO = null;
  //         }

  //         if (currencyDAO == null) {
  //           await GetIt.instance<AppDatabase>()
  //               .currencyDao
  //               .create(data: currencyBOS);
  //           continue;
  //         }
  //         if ((currencyBOS.updateDate!).isAfter(currencyDAO.updateDate!)) {
  //           await GetIt.instance<AppDatabase>()
  //               .currencyDao
  //               .update(docId: currencyBOS.docId, data: currencyBOS);
  //         }
  //       }
  //     },
  //     () async {
  //       countriesBOS = await GetIt.instance<CountryApi>().fetchData();
  //       countriesDAO = await GetIt.instance<AppDatabase>().countryDao.readAll();

  //       if (countriesDAO.isEmpty) {
  //         await GetIt.instance<AppDatabase>()
  //             .countryDao
  //             .bulkCreate(data: countriesBOS);
  //         return;
  //       }

  //       for (var countryBOS in countriesBOS) {
  //         CountryModel? countryDAO;
  //         try {
  //           countryDAO = countriesDAO.firstWhere(
  //             (country) => country.docId == countryBOS.docId,
  //           );
  //         } catch (e) {
  //           countryDAO = null;
  //         }

  //         if (countryDAO == null) {
  //           await GetIt.instance<AppDatabase>()
  //               .countryDao
  //               .create(data: countryBOS);
  //           continue;
  //         }
  //         if ((countryBOS.updateDate!).isAfter(countryDAO.updateDate!)) {
  //           await GetIt.instance<AppDatabase>()
  //               .countryDao
  //               .update(docId: countryBOS.docId, data: countryBOS);
  //         }
  //       }
  //     },
  //     () async {
  //       provincesBOS = await GetIt.instance<ProvinceApi>().fetchData();
  //       provincesDAO =
  //           await GetIt.instance<AppDatabase>().provinceDao.readAll();

  //       if (provincesDAO.isEmpty) {
  //         await GetIt.instance<AppDatabase>()
  //             .provinceDao
  //             .bulkCreate(data: provincesBOS);
  //         return;
  //       }

  //       for (var datumBOS in provincesBOS) {
  //         ProvinceModel? datumDAO;
  //         try {
  //           datumDAO = provincesDAO.firstWhere(
  //             (datum) => datum.docId == datumBOS.docId,
  //           );
  //         } catch (e) {
  //           datumDAO = null;
  //         }

  //         if (datumDAO == null) {
  //           await GetIt.instance<AppDatabase>()
  //               .provinceDao
  //               .create(data: datumBOS);
  //           continue;
  //         }
  //         if ((datumBOS.updateDate!).isAfter(datumDAO.updateDate!)) {
  //           await GetIt.instance<AppDatabase>()
  //               .provinceDao
  //               .update(docId: datumBOS.docId, data: datumBOS);
  //         }
  //       }
  //     },
  //   ];

  //   for (final fetchFunction in fetchFunctions) {
  //     try {
  //       await fetchFunction();
  //     } catch (e) {
  //       handleError(e);
  //     }
  //   }

  // itemsBOS = await GetIt.instance<ItemMasterApi>().fetchData();
  // itemsDAO = await GetIt.instance<AppDatabase>().itemMasterDao.readAll();

  // log("BOS ===> $itemsBOS");
  // log("DAO B4 ===> $itemsDAO");

  // if (itemsDAO.isEmpty) {
  //   await GetIt.instance<AppDatabase>()
  //       .itemMasterDao
  //       .bulkCreate(data: itemsBOS);
  //   return;
  // }

  // for (var itemBOS in itemsBOS) {
  //   ItemMasterModel? itemDAO;
  //   try {
  //     itemDAO = itemsDAO.firstWhere(
  //       (item) => item.docId == itemBOS.docId,
  //     );
  //   } catch (e) {
  //     itemDAO = null;
  //   }

  //   if (itemDAO == null) {
  //     await GetIt.instance<AppDatabase>().itemMasterDao.create(data: itemBOS);
  //     continue;
  //   }
  //   if ((itemBOS.updateDate!).isAfter(itemDAO.updateDate!)) {
  //     await GetIt.instance<AppDatabase>()
  //         .itemMasterDao
  //         .update(docId: itemBOS.docId, data: itemBOS);
  //   }
  // }
  // itemsDAO = await GetIt.instance<AppDatabase>().itemMasterDao.readAll();
  // log("DAO AFTER ===> $itemsDAO");
  // }

  void manualSyncData() async {
    late List<CurrencyModel> currencies;
    late List<CountryModel> countries;
    late List<ProvinceModel> provinces;
    late List<ZipCodeModel> zipcodes;
    late List<EmployeeModel> employees;
    late List<TaxMasterModel> taxes;
    late List<PaymentTypeModel> payTypes;
    late List<MeansOfPaymentModel> mops;
    late List<CreditCardModel> ccs;
    late List<PricelistModel> pricelists;
    late List<StoreMasterModel> stores;
    late List<MOPByStoreModel> mopStores;
    late List<CashRegisterModel> cashiers;
    late List<UomModel> uoms;
    late List<UserRoleModel> roles;
    late List<UserModel> users;
    late List<PricelistPeriodModel> pricelistPeriod;
    late List<ItemCategoryModel> itemCat;
    late List<ItemMasterModel> items;
    late List<ItemByStoreModel> itemsStores;
    late List<ItemBarcodeModel> itemBarcodes;
    late List<ItemRemarksModel> itemRemarks;
    late List<VendorGroupModel> venGroups;
    late List<VendorModel> vendor;
    late List<PreferredVendorModel> prefVendor;
    late List<CustomerGroupModel> cusGroup;
    late List<CustomerCstModel> cusCst;
    late List<PriceByItemModel> priceByItem;
    late List<AssignPriceMemberPerStoreModel> apmps;
    late List<PriceByItemBarcodeModel> priceItemBarcode;
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

    print("Synching data...");
    try {
      await GetIt.instance<AppDatabase>().currencyDao.deleteAll();
      final fetchFunctions = [
        () async {
          try {
            currencies = await GetIt.instance<CurrencyApi>().fetchData();

            await GetIt.instance<AppDatabase>()
                .currencyDao
                .bulkCreate(data: currencies);
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
            countries = await GetIt.instance<CountryApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .countryDao
                .bulkCreate(data: countries);
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
            provinces = await GetIt.instance<ProvinceApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .provinceDao
                .bulkCreate(data: provinces);
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
            zipcodes = await GetIt.instance<ZipcodeApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .zipcodeDao
                .bulkCreate(data: zipcodes);
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
            employees = await GetIt.instance<EmployeeApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .employeeDao
                .bulkCreate(data: employees);
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
            taxes = await GetIt.instance<TaxMasterApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .taxMasterDao
                .bulkCreate(data: taxes);
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
            payTypes = await GetIt.instance<PaymentTypeApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .paymentTypeDao
                .bulkCreate(data: payTypes);
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
            mops = await GetIt.instance<MOPApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .meansOfPaymentDao
                .bulkCreate(data: mops);
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
            ccs = await GetIt.instance<CreditCardApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .creditCardDao
                .bulkCreate(data: ccs);
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
            pricelists = await GetIt.instance<PricelistApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .pricelistDao
                .bulkCreate(data: pricelists);
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
            stores = await GetIt.instance<StoreMasterApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .storeMasterDao
                .bulkCreate(data: stores);
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
            mopStores = await GetIt.instance<MOPByStoreApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .mopByStoreDao
                .bulkCreate(data: mopStores);
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
            cashiers = await GetIt.instance<CashRegisterApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .cashRegisterDao
                .bulkCreate(data: cashiers);
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
            uoms = await GetIt.instance<UoMApi>().fetchData();
            await GetIt.instance<AppDatabase>().uomDao.bulkCreate(data: uoms);
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
            roles = await GetIt.instance<UserRoleApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .userRoleDao
                .bulkCreate(data: roles);
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
            users = await GetIt.instance<UserApi>().fetchData();
            await GetIt.instance<AppDatabase>().userDao.bulkCreate(data: users);
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
            pricelistPeriod =
                await GetIt.instance<PricelistPeriodApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .pricelistPeriodDao
                .bulkCreate(data: pricelistPeriod);
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
            itemCat = await GetIt.instance<ItemCategoryApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .itemCategoryDao
                .bulkCreate(data: itemCat);
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
            items = await GetIt.instance<ItemMasterApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .itemMasterDao
                .bulkCreate(data: items);
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
            itemsStores = await GetIt.instance<ItemByStoreApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .itemByStoreDao
                .bulkCreate(data: itemsStores);
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
            itemBarcodes = await GetIt.instance<ItemBarcodeApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .itemBarcodeDao
                .bulkCreate(data: itemBarcodes);
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
            itemRemarks = await GetIt.instance<ItemRemarksApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .itemRemarkDao
                .bulkCreate(data: itemRemarks);
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
            venGroups = await GetIt.instance<VendorGroupApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .vendorGroupDao
                .bulkCreate(data: venGroups);
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
            vendor = await GetIt.instance<VendorApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .vendorDao
                .bulkCreate(data: vendor);
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
            prefVendor = await GetIt.instance<PreferredVendorApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .preferredVendorDao
                .bulkCreate(data: prefVendor);
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
            cusGroup = await GetIt.instance<CustomerGroupApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .customerGroupDao
                .bulkCreate(data: cusGroup);
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
            cusCst = await GetIt.instance<CustomerApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .customerCstDao
                .bulkCreate(data: cusCst);
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
            priceByItem = await GetIt.instance<PriceByItemApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .priceByItemDao
                .bulkCreate(data: priceByItem);
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
            apmps = await GetIt.instance<APMPSApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .assignPriceMemberPerStoreDao
                .bulkCreate(data: apmps);
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
            priceItemBarcode =
                await GetIt.instance<PriceByItemBarcodeApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .priceByItemBarcodeDao
                .bulkCreate(data: priceItemBarcode);
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
            topsb = await GetIt.instance<PromoHargaSpesialApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .promoHargaSpesialHeaderDao
                .bulkCreate(data: topsb);
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
            tpsb1 = await GetIt.instance<PromoHargaSpesialBuyApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .promoHargaSpesialBuyDao
                .bulkCreate(data: tpsb1);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoHargaSpesialAssignStoreDao
                .bulkCreate(data: tpsb2);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoHargaSpesialCustomerGroupDao
                .bulkCreate(data: tpsb4);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoHargaSpesialCustomerGroupDao
                .bulkCreate(data: tpsb4);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoMultiItemHeaderDao
                .bulkCreate(data: topmi);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoMultiItemBuyConditionDao
                .bulkCreate(data: tpmi1);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoMultiItemAssignStoreDao
                .bulkCreate(data: tpmi2);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoMultiItemGetConditionDao
                .bulkCreate(data: tpmi4);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoMultiItemCustomerGroupDao
                .bulkCreate(data: tpmi5);
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
            topdi =
                await GetIt.instance<PromoDiskonItemHeaderApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonItemHeaderDao
                .bulkCreate(data: topdi);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonItemBuyConditionDao
                .bulkCreate(data: tpdi1);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonItemAssignStoreDao
                .bulkCreate(data: tpdi2);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonItemGetConditionDao
                .bulkCreate(data: tpdi4);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonItemCustomerGroupDao
                .bulkCreate(data: tpdi5);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemHeaderDao
                .bulkCreate(data: topdg);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemBuyConditionDao
                .bulkCreate(data: tpdg1);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemAssignStoreDao
                .bulkCreate(data: tpdg2);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemGetConditionDao
                .bulkCreate(data: tpdg4);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoDiskonGroupItemCustomerGroupDao
                .bulkCreate(data: tpdg5);
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
            toprb = await GetIt.instance<PromoBuyXGetYHeaderApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .promoBuyXGetYHeaderDao
                .bulkCreate(data: toprb);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoBuyXGetYBuyConditionDao
                .bulkCreate(data: tprb1);
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
            tprb2 =
                await GetIt.instance<PromoBuyXGetYAssignStoreApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .promoBuyXGetYAssignStoreDao
                .bulkCreate(data: tprb2);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoBuyXGetYGetConditionDao
                .bulkCreate(data: tprb4);
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
                .fetchData();
            await GetIt.instance<AppDatabase>()
                .promoBuyXGetYCustomerGroupDao
                .bulkCreate(data: tprb5);
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
        } catch (e) {
          handleError(e);
        }
      }

      final promos = <PromotionsModel>[];

      // final topsb = await GetIt.instance<AppDatabase>()
      //     .promoHargaSpesialHeaderDao
      //     .readAll();

      for (final header in topsb) {
        final tpsb4 = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialCustomerGroupDao
            .readByTopsbId(header.docId, null);

        for (final customerGroup in tpsb4) {
          promos.add(PromotionsModel(
            toitmId: header.toitmId,
            promoType: 202,
            promoId: header.docId,
            date: DateTime.now(),
            startTime: header.startTime,
            endTime: header.endTime,
            tocrgId: customerGroup.tocrgId,
            promoDescription: header.description,
            tocatId: null,
          ));
        }
      }

      // final topdi =
      //     await GetIt.instance<AppDatabase>().promoMultiItemHeaderDao.readAll();

      for (final header in topmi) {
        final tpdi1 = await GetIt.instance<AppDatabase>()
            .promoMultiItemBuyConditionDao
            .readByTopmiId(header.docId, null);
        final tpdi5 = await GetIt.instance<AppDatabase>()
            .promoMultiItemCustomerGroupDao
            .readByTopmiId(header.docId, null);

        for (final buyCondition in tpdi1) {
          for (final customerGroup in tpdi5) {
            promos.add(PromotionsModel(
              toitmId: buyCondition.toitmId,
              promoType: 206,
              promoId: header.docId,
              date: DateTime.now(),
              startTime: header.startTime,
              endTime: header.endTime,
              tocrgId: customerGroup.tocrgId,
              promoDescription: header.description,
              tocatId: null,
            ));
          }
        }
      }

      for (final header in topdi) {
        final tpdi1 = await GetIt.instance<AppDatabase>()
            .promoDiskonItemBuyConditionDao
            .readByTopdiId(header.docId, null);
        final tpdi5 = await GetIt.instance<AppDatabase>()
            .promoDiskonItemCustomerGroupDao
            .readByTopdiId(header.docId, null);

        for (final buyCondition in tpdi1) {
          for (final customerGroup in tpdi5) {
            promos.add(PromotionsModel(
              toitmId: buyCondition.toitmId,
              promoType: 203,
              promoId: header.docId,
              date: DateTime.now(),
              startTime: header.startTime,
              endTime: header.endTime,
              tocrgId: customerGroup.tocrgId,
              promoDescription: header.description,
              tocatId: null,
            ));
          }
        }
      }

      for (final header in topdg) {
        final tpdg1 = await GetIt.instance<AppDatabase>()
            .promoDiskonGroupItemBuyConditionDao
            .readByTopdgId(header.docId, null);
        final tpdg5 = await GetIt.instance<AppDatabase>()
            .promoDiskonGroupItemCustomerGroupDao
            .readByTopdgId(header.docId, null);

        for (final buyCondition in tpdg1) {
          for (final customerGroup in tpdg5) {
            promos.add(PromotionsModel(
              toitmId: null,
              promoType: 204,
              promoId: header.docId,
              date: DateTime.now(),
              startTime: header.startTime,
              endTime: header.endTime,
              tocrgId: customerGroup.tocrgId,
              promoDescription: header.description,
              tocatId: buyCondition.tocatId,
            ));
          }
        }
      }

      for (final header in toprb) {
        final tprb1 = await GetIt.instance<AppDatabase>()
            .promoBuyXGetYBuyConditionDao
            .readByToprbid(header.docId, null);
        // final tprb5 = await GetIt.instance<AppDatabase>()
        //     .promoBuyXGetYCustomerGroupDao
        //     .readByToprbid(header.docId, null);

        for (final buyCondition in tprb1) {
          // for (final customerGroup in tprb5) {
          promos.add(PromotionsModel(
            toitmId: buyCondition.toitmId,
            promoType: 103,
            promoId: header.docId,
            date: DateTime.now(),
            startTime: header.startTime,
            endTime: header.endTime,
            tocrgId: null,
            promoDescription: header.description,
            tocatId: null,
          ));
          // }
        }
      }

      await GetIt.instance<AppDatabase>().promosDao.bulkCreate(data: promos);
      log("PROMOS INSERTED");

      // log("$priceItemBarcode\n");

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

      fetched = currencies.length +
          countries.length +
          provinces.length +
          zipcodes.length +
          employees.length +
          taxes.length +
          payTypes.length +
          mops.length +
          ccs.length +
          pricelists.length +
          stores.length +
          mopStores.length +
          cashiers.length +
          uoms.length +
          roles.length +
          users.length +
          pricelistPeriod.length +
          itemCat.length +
          items.length +
          itemsStores.length +
          itemBarcodes.length +
          itemRemarks.length +
          venGroups.length +
          vendor.length +
          prefVendor.length +
          cusGroup.length +
          cusCst.length +
          priceByItem.length +
          apmps.length +
          priceItemBarcode.length +
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
    await GetIt.instance<AppDatabase>().promosDao.deletePromos();
    try {
      // final createPromotionsUseCase = GetIt.instance<CreatePromotionsUseCase>();
      // if (createPromotionsUseCase != null) {
      //   await createPromotionsUseCase.call();
      // } else {
      //   // Handle the case where createPromotionsUseCase is null
      //   print('Error: createPromotionsUseCase is null');
      // }

      // final promos = <PromotionsModel>[];

      // final toprb =
      //     await GetIt.instance<AppDatabase>().promoBuyXGetYHeaderDao.readAll();
      // for (final header in toprb) {
      //   final tprb1 = await GetIt.instance<AppDatabase>()
      //       .promoBuyXGetYBuyConditionDao
      //       .readByToprbid(header.docId, null);
      // final tprb5 = await GetIt.instance<AppDatabase>()
      //     .promoBuyXGetYCustomerGroupDao
      //     .readByToprbid(header.docId, null);

      //   for (final buyCondition in tprb1) {
      //     promos.add(PromotionsModel(
      //       toitmId: buyCondition.toitmId,
      //       promoType: 103,
      //       promoId: header.docId,
      //       date: DateTime.now(),
      //       startTime: header.startTime,
      //       endTime: header.endTime,
      //       tocrgId: null,
      //       promoDescription: header.description,
      //       tocatId: null,
      //     ));
      //   }
      //   log("$promos");
      // }

      // await GetIt.instance<AppDatabase>().promosDao.bulkCreate(data: promos);
      // log("PROMOS INSERTED");

      setState(() {
        // _dataFetched = data.length;
        // _dataExample = data[0].docId;
        _errorMessage = '';
      });
      // print(data);
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

  void _fetchSingleData() async {
    print("CHECK PROMO");
    try {
      final promo = await GetIt.instance<AppDatabase>()
          .promosDao
          .readByToitmId("816902d3-eb12-4d20-862a-3c4c072b49a0", null);
      log("PROMO - $promo");
      // setState(() {
      //   _singleData = datum.docnum;
      // });
      print("Data Fetched");
    } catch (error) {
      handleError(error);
      setState(() {
        _statusCode = handleError(error)['statusCode'];
        _errorMessage = handleError(error)['message'];
        _clearErrorMessageAfterDelay();
      });
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
                onPressed: () {
                  _fetchData();
                },
                child: Text('FETCH'),
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
