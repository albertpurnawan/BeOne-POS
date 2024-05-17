import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/repository/promos_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class PromotionsRepositoryImpl extends PromotionsRepository {
  final AppDatabase _appDatabase;
  PromotionsRepositoryImpl(this._appDatabase);
  final String generatedPromoDocId = const Uuid().v4();

  @override
  Future<List<PromotionsEntity?>> createPromotions(
      PromotionsEntity promotionsEntity) async {
    final Database db = await _appDatabase.getDB();
    final promos = <PromotionsModel>[];

    await db.transaction((txn) async {
      final topsb = await GetIt.instance<AppDatabase>()
          .promoHargaSpesialHeaderDao
          .readAll();

      for (final header in topsb) {
        final tpsb4 = await GetIt.instance<AppDatabase>()
            .promoHargaSpesialCustomerGroupDao
            .readByTopsbId(header.docId, null);

        for (final customerGroup in tpsb4) {
          promos.add(PromotionsModel(
            docId: generatedPromoDocId,
            toitmId: header.toitmId,
            promoType: header.promoAlias,
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

      final topdi =
          await GetIt.instance<AppDatabase>().promoMultiItemHeaderDao.readAll();

      for (final header in topdi) {
        final tpdi1 = await GetIt.instance<AppDatabase>()
            .promoMultiItemBuyConditionDao
            .readByTopmiId(header.docId, null);
        final tpdi5 = await GetIt.instance<AppDatabase>()
            .promoMultiItemCustomerGroupDao
            .readByTopmiId(header.docId, null);

        for (final buyCondition in tpdi1) {
          for (final customerGroup in tpdi5) {
            promos.add(PromotionsModel(
              docId: generatedPromoDocId,
              toitmId: buyCondition.toitmId,
              promoType: header.promoType,
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
    });

    return promos;
  }

  @override
  Future<List<PromotionsEntity>> checkPromos(String toitmId) async {
    final Database db = await _appDatabase.getDB();

    return await db.transaction((txn) async {
      final List<PromotionsEntity> promos =
          await _appDatabase.promosDao.readByToitmId(toitmId, txn);

      return promos;
    });
  }
}
