import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';

abstract class CreditCardRepository {
  Future<CreditCardEntity?> getCrediCard(String docId);

  Future<List<CreditCardEntity>> getCrediCards({String? searchKeyword});
}
