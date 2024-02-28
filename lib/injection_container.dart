import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/repository/item_repository_impl.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_items_cubit.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/local/user_masters_dao.dart';
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
import 'package:pos_fe/features/syncdata/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/user_masters_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<AppDatabase>(AppDatabase());

  sl.registerSingleton<UoMApi>(UoMApi(sl()));
  sl.registerSingleton<ItemBarcodeApi>(ItemBarcodeApi(sl()));
  sl.registerSingleton<ItemByStoreApi>(ItemByStoreApi(sl()));
  // sl.registerSingleton<CashRegisterApi>(CashRegisterApi(sl()));
  // sl.registerSingleton<ClosingStoreApi>(ClosingStoreApi(sl()));
  sl.registerSingleton<CurrencyApi>(CurrencyApi(sl()));
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
  sl.registerSingleton<UsersDao>(UsersDao(sl()));
  sl.registerSingleton<ItemCategoryApi>(ItemCategoryApi(sl()));
  sl.registerSingleton<ItemsApi>(ItemsApi(sl()));
  sl.registerSingleton<PricelistApi>(PricelistApi(sl()));
  sl.registerSingleton<PricelistPeriodApi>(PricelistPeriodApi(sl()));
  sl.registerSingleton<ProductHierarchyMasterApi>(
      ProductHierarchyMasterApi(sl()));
  sl.registerSingleton<ProductHierarchyApi>(ProductHierarchyApi(sl()));

  sl.registerSingleton<ItemRepository>(ItemRepositoryImpl(sl()));

  sl.registerSingleton<GetItemsUseCase>(GetItemsUseCase(sl()));
  sl.registerSingleton<GetItemUseCase>(GetItemUseCase(sl()));
  sl.registerSingleton<GetItemByBarcodeUseCase>(GetItemByBarcodeUseCase(sl()));

  sl.registerFactory<ReceiptItemsCubit>(() => ReceiptItemsCubit(sl()));
}
