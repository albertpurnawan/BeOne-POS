import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';

part 'queue_state.dart';

class QueueCubit extends Cubit<List<ReceiptEntity>> {
  final QueueReceiptUseCase _queueReceiptUseCase;

  QueueCubit(this._queueReceiptUseCase) : super([]);

  void addReceipt(ReceiptEntity receiptEntity) async {}

  void removeReceipt(ReceiptEntity receiptEntity) {}
}
