import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/repository/credit_card_repository.dart';

class GetCreditCardUseCase implements UseCase<List<CreditCardEntity>, String?> {
  final CreditCardRepository _creditCardRepository;

  GetCreditCardUseCase(this._creditCardRepository);

  @override
  Future<List<CreditCardEntity>> call({String? params}) {
    return _creditCardRepository.getCrediCards(searchKeyword: params);
  }
}
