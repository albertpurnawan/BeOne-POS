import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';

part 'return_base_receipt_state.dart';

class ReturnReceiptCubit extends Cubit<ReturnReceiptEntity?> {
  ReturnReceiptCubit() : super(null);

  void replace(ReturnReceiptEntity? returnReceiptEntity) {
    emit(returnReceiptEntity);
  }
}
