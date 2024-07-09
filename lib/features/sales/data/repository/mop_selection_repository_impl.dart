import 'dart:developer';

import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';

class MopSelectionRepositoryImpl implements MopSelectionRepository {
  final AppDatabase _appDatabase;
  MopSelectionRepositoryImpl(this._appDatabase);

  @override
  Future<List<MopSelectionModel>> getMopSelections() async {
    return await _appDatabase.mopByStoreDao.readAllIncludeRelations();
  }

  @override
  Future<MopSelectionModel?> getMopSelectionByTpmt3Id(String tpmt3Id) async {
    return await _appDatabase.mopByStoreDao
        .readByDocIdIncludeRelations(tpmt3Id, null);
  }

  @override
  Future<MopSelectionModel> getCashMopSelection() async {
    try {
      final List<MopSelectionModel> cashMopSelections = await _appDatabase
          .mopByStoreDao
          .readAllIncludeRelations(payTypeCode: "1");
      if (cashMopSelections.isEmpty) throw "Cash MOP not found";
      return cashMopSelections.first;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
