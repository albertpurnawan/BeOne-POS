// import 'package:get_it/get_it.dart';
// import 'package:pos_fe/core/database/app_database.dart';
// import 'package:pos_fe/features/sales/data/models/currency.dart';
// import 'package:pos_fe/features/sales/domain/repository/currency_repository.dart';
// import 'package:pos_fe/features/syncdata/data/data_sources/remote/currency_masters_service.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class CurrencyRepositoryImpl implements CurrencyRepository {
//   final AppDatabase _appDatabase;
//   CurrencyRepositoryImpl(this._appDatabase);

//   @override
//   Future<void> deleteInsert(List<CurrencyModel> currencies) async {
//     final Database db = await _appDatabase.getDB();

//     await db.transaction((txn) async {
//       final List<CurrencyModel> currencies =
//           await GetIt.instance<CurrencyApi>().fetchData();

//       // await _appDatabase.currencyDao.deleteAll(data: currencies, txn: txn);
//       await _appDatabase.currencyDao.bulkCreate(data: currencies, txn: txn);
//     });

//     //
//     //   await GetIt.instance<AppDatabase>()
//     //       .currencyDao
//     //       .bulkCreate(data: currencies);
//   }
// }
