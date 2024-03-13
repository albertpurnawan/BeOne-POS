import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/login/domain/repository/user_auth.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_category_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/repository/customer_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/item_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/mop_selection_repository_impl.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_mop_selections.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_items_cubit.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/country_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_barcode_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/closing_store_transactions_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_group_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/customer_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_by_store_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_adjustment_transactions_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/opening_store_transactions_services.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/price_by_item_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/pricelist_period_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/product_hierarchy_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/product_hierarchy_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/zipcode_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingletonAsync<AppDatabase>(() => AppDatabase.init());

  sl.registerSingleton<UoMApi>(UoMApi(sl()));
  sl.registerSingleton<ItemBarcodeApi>(ItemBarcodeApi(sl()));
  sl.registerSingleton<ItemByStoreApi>(ItemByStoreApi(sl()));
  // sl.registerSingleton<CashRegisterApi>(CashRegisterApi(sl()));
  // sl.registerSingleton<ClosingStoreApi>(ClosingStoreApi(sl()));
  sl.registerSingleton<CurrencyApi>(CurrencyApi(sl()));
  sl.registerSingleton<CountryApi>(CountryApi(sl()));
  sl.registerSingleton<ProvinceApi>(ProvinceApi(sl()));
  sl.registerSingleton<ZipcodeApi>(ZipcodeApi(sl()));
  // sl.registerSingleton<CustomerGroupApi>(CustomerGroupApi(sl()));
  // sl.registerSingleton<CustomerApi>(CustomerApi(sl()));
  // sl.registerSingleton<MOPAdjustmentApi>(MOPAdjustmentApi(sl()));
  // sl.registerSingleton<MOPApi>(MOPApi(sl()));
  // sl.registerSingleton<OpeningStoreApi>(OpeningStoreApi(sl()));
  sl.registerSingleton<PriceByItemBarcodeApi>(PriceByItemBarcodeApi(sl()));
  sl.registerSingleton<PriceByItemApi>(PriceByItemApi(sl()));
  // sl.registerSingleton<StoreApi>(StoreApi(sl()));
  // sl.registerSingleton<TaxApi>(TaxApi(sl()));
  sl.registerSingleton<UsersApi>(UsersApi(sl()));
  sl.registerSingletonWithDependencies<UsersDao>(() => UsersDao(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingleton<ItemCategoryApi>(ItemCategoryApi(sl()));
  sl.registerSingleton<ItemsApi>(ItemsApi(sl()));
  sl.registerSingleton<PricelistApi>(PricelistApi(sl()));
  sl.registerSingleton<PricelistPeriodApi>(PricelistPeriodApi(sl()));
  sl.registerSingleton<ProductHierarchyMasterApi>(
      ProductHierarchyMasterApi(sl()));
  sl.registerSingleton<ProductHierarchyApi>(ProductHierarchyApi(sl()));

  sl.registerSingletonWithDependencies<ItemRepository>(
      () => ItemRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CustomerRepository>(
      () => CustomerRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<MopSelectionRepository>(
      () => MopSelectionRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);

  sl.registerSingletonWithDependencies<GetItemsUseCase>(
      () => GetItemsUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetItemUseCase>(
      () => GetItemUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetItemByBarcodeUseCase>(
      () => GetItemByBarcodeUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetCustomersUseCase>(
      () => GetCustomersUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetMopSelectionsUseCase>(
      () => GetMopSelectionsUseCase(sl()),
      dependsOn: [AppDatabase]);
  // sl.registerFactory<ReceiptItemsCubit>(() => ReceiptItemsCubit(sl()));

  return;
}
