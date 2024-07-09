import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/repository/credit_card_repository.dart';

class CreditCardRepositoryImpl extends CreditCardRepository {
  final AppDatabase _appDatabase;
  CreditCardRepositoryImpl(this._appDatabase);

  @override
  Future<CreditCardEntity?> getCrediCard(String docId) {
    return _appDatabase.creditCardDao.readByDocId(docId, null);
  }

  @override
  Future<List<CreditCardEntity>> getCrediCards({String? searchKeyword}) {
    return _appDatabase.creditCardDao
        .readAllWithSearch(searchKeyword: searchKeyword);
  }
}
