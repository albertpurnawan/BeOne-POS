import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/promo_harga_spesial_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/repository/promos_repository.dart';
import 'package:sqflite/sqflite.dart';

class PromotionsRepositoryImpl extends PromotionsRepository {
  final AppDatabase _appDatabase;
  PromotionsRepositoryImpl(this._appDatabase);

  @override
  Future<PromotionsEntity?> createPromotion(PromotionsEntity promotionsEntity) {
    // TODO: implement createPromotion
    throw UnimplementedError();
  }

  @override
  Future<List<PromotionsEntity?>> checkPromos() async {
    final Database db = await _appDatabase.getDB();

    await db.transaction((txn) async {
      final List<PromoHargaSpesialHeaderModel> topsb =
          (await _appDatabase.promoHargaSpesialHeaderDao.readAll(txn: txn));
    });
    throw UnimplementedError();
  }
}
