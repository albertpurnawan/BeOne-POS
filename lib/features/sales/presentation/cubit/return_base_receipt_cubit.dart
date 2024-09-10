import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';

part 'return_base_receipt_state.dart';

class ReturnBaseReceiptCubit extends Cubit<ReturnBaseReceiptEntity?> {
  ReturnBaseReceiptCubit() : super(null);

  void replace(ReturnBaseReceiptEntity? returnBaseReceiptEntity) {
    emit(returnBaseReceiptEntity);
  }
}
