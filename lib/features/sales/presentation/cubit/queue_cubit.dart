import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<List<ReceiptEntity>> {
  QueueCubit() : super([]);

  void addReceipt(ReceiptEntity receiptEntity) {
    emit([...state, receiptEntity]);
  }

  void removeReceipt(ReceiptEntity receiptEntity) {}
}
