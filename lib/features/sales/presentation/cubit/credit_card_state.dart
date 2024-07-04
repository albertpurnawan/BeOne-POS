part of 'credit_card_cubit.dart';

sealed class CreditCardState extends Equatable {
  const CreditCardState();

  @override
  List<Object> get props => [];
}

final class CreditCardInitial extends CreditCardState {}
