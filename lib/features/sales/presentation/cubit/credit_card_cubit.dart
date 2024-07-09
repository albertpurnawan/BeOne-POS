import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_credit_cards.dart';

part 'credit_card_state.dart';

class CreditCardCubit extends Cubit<List<CreditCardEntity>> {
  final GetCreditCardUseCase _getCreditCardUseCase;

  CreditCardCubit(this._getCreditCardUseCase) : super([]);

  void getCreditCards({required String searchKeyword}) async {
    final List<CreditCardEntity> newState =
        await _getCreditCardUseCase.call(params: searchKeyword);
    emit(newState);
  }

  void clearCreditCards() async {
    emit([]);
  }
}
