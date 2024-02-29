import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/item_category_dao.dart';
import 'package:pos_fe/features/sales/data/data_sources/local/items_dao.dart';
import 'package:pos_fe/features/sales/data/repository/item_repository_impl.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_items_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<AppDatabase>(AppDatabase());

  sl.registerSingleton<ItemRepository>(ItemRepositoryImpl(sl()));

  sl.registerSingleton<GetItemsUseCase>(GetItemsUseCase(sl()));
  sl.registerSingleton<GetItemUseCase>(GetItemUseCase(sl()));
  sl.registerSingleton<GetItemByBarcodeUseCase>(GetItemByBarcodeUseCase(sl()));

  sl.registerFactory<ReceiptItemsCubit>(() => ReceiptItemsCubit(sl()));
}
