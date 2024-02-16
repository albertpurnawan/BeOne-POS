part of 'receipt_cubit.dart';

sealed class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

final class ReceiptInitial extends ReceiptState {}
