// import 'package:get_it/get_it.dart';
// import 'package:pos_fe/core/database/app_database.dart';
// import 'package:pos_fe/features/sales/data/data_sources/local/currency_dao.dart';
// import 'package:pos_fe/features/sales/data/models/currency.dart';
// import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';

// void syncData() async {
//   print("Synching data...");
//   try {
//     final syncFunctions = [
//       () => _syncTable<CurrencyModel, CurrencyApi, CurrencyDao>(),
//       () => _syncTable<CountryModel, CountryApi, CountryDao>(),
//       () => _syncTable<ProvinceModel, ProvinceApi, ProvinceDao>(),
//       () => _syncTable<ZipcodeModel, ZipcodeApi, ZipcodeDao>(),
//       // Add synchronization functions for other tables
//     ];

//     for (final syncFunction in syncFunctions) {
//       await syncFunction();
//     }

//     print('Data synched');
//   } catch (error) {
//     print("Error synchronizing: $error");
//   }
// }

// Future<void> _syncTable<T, A, D>() async {
//   final data = await GetIt.instance<A>().fetchData();
//   await GetIt.instance<AppDatabase>().daoFor<T>().bulkCreate(data);
// }
