import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
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
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/preferred_vendor.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item.dart';
import 'package:pos_fe/features/sales/data/models/price_by_item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/pricelist.dart';
import 'package:pos_fe/features/sales/data/models/pricelist_period.dart';
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
import 'package:pos_fe/features/syncdata/data/data_sources/remote/invoice_header_service.dart';
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
  int totalTable = 30;
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

    print("Synching data...");
    try {
      final fetchFunctions = [
        () async {
          try {
            currencies = await GetIt.instance<CurrencyApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .currencyDao
                .resync(data: currencies);
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
                .resync(data: countries);
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
                .resync(data: provinces);
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
                .resync(data: zipcodes);
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
                .resync(data: employees);
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
                .resync(data: taxes);
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
                .resync(data: payTypes);
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
                .resync(data: mops);
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
            await GetIt.instance<AppDatabase>().creditCardDao.resync(data: ccs);
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
                .resync(data: pricelists);
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
                .resync(data: stores);
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
                .resync(data: mopStores);
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
                .resync(data: cashiers);
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
            await GetIt.instance<AppDatabase>().uomDao.resync(data: uoms);
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
            await GetIt.instance<AppDatabase>().userRoleDao.resync(data: roles);
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
            await GetIt.instance<AppDatabase>().userDao.resync(data: users);
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
                .resync(data: pricelistPeriod);
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
                .resync(data: itemCat);
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
                .resync(data: items);
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
            itemsStores = await GetIt.instance<ItemByStoreApi>().fetchData();
            await GetIt.instance<AppDatabase>()
                .itemByStoreDao
                .resync(data: itemsStores);
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
                .resync(data: itemBarcodes);
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
                .resync(data: itemRemarks);
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
                .resync(data: venGroups);
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
            await GetIt.instance<AppDatabase>().vendorDao.resync(data: vendor);
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
                .resync(data: prefVendor);
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
                .resync(data: cusGroup);
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
                .resync(data: cusCst);
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
                .resync(data: priceByItem);
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
                .resync(data: apmps);
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
                .resync(data: priceItemBarcode);
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
          "baseUrl": "someUrl",
          "user": "user",
          "password": "password",
        }
      ];

      await GetIt.instance<AppDatabase>().posParameterDao.resync(
          data: posParameter.map((e) => POSParameterModel.fromMap(e)).toList());

      // final auths = await GetIt.instance<AuthorizationApi>().fetchData();
      // await GetIt.instance<AppDatabase>().authorizationDao.resync(auths);
      // final itemPics = await GetIt.instance<ItemPictureApi>().fetchData();
      // await GetIt.instance<AppDatabase>().itemPictureDao.resync(itemPics);

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
          priceItemBarcode.length;

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
      final data = await GetIt.instance<InvoiceApi>().sendInvoice();

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

  void _fetchSingleData(String docid) async {
    print("Fetching single data...");
    try {
      final datum =
          await GetIt.instance<InvoiceHeaderApi>().fetchSingleData(docid);
      print(datum);
      setState(() {
        _singleData = datum.docnum;
      });
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
      appBar: AppBar(
        title: Text('Fetch Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // _fetchToken();
                manualSyncData();
              },
              child: Text('SYNC'),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 40,
                    child: LinearProgressIndicator(
                      value: _syncProgress,
                      backgroundColor: Colors.grey[300],
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
            ElevatedButton(
              onPressed: () {
                _fetchData();
              },
              child: Text('FETCH'),
            ),
            SizedBox(height: 20),
            Text(
              'Data Fetched: [$_dataFetched] $_dataExample',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _docIdController,
              decoration: InputDecoration(
                labelText: 'Enter Document ID',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchSingleData(_docIdController.text);
              },
              child: Text('SEARCH'),
            ),
            SizedBox(height: 20),
            Text(
              'Data Found: ${_singleData}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_statusCode != 0) Text(_statusCode.toString()),
            if (_errorMessage.isNotEmpty) Text(_errorMessage),
          ],
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
