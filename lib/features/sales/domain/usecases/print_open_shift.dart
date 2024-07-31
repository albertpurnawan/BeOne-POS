import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/repository/cash_register_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/user_repository.dart';

class PrintOpenShiftUsecase implements UseCase<void, CashierBalanceTransactionEntity?> {
  // POS Parameter
  final ReceiptPrinter _receiptPrinter;
  final CashRegisterRepository _cashRegisterRepository;
  final StoreMasterRepository _storeMasterRepository;
  final UserRepository _userRepository;

  PrintOpenShiftUsecase(
      this._receiptPrinter, this._cashRegisterRepository, this._storeMasterRepository, this._userRepository);

  @override
  Future<void> call({CashierBalanceTransactionEntity? params, int? printType}) async {
    try {
      if (params == null || params.tocsrId == null || params.tousrId == null || printType == null) {
        return;
      }

      final CashRegisterEntity? cashRegisterEntityRes =
          await _cashRegisterRepository.getCashRegisterByDocId(params.tocsrId!);
      if (cashRegisterEntityRes == null) throw "Cash Register not found";
      if (cashRegisterEntityRes.tostrId == null) {
        throw "Cash Register does not contain store information";
      }

      final StoreMasterEntity? storeMasterEntityRes =
          await _storeMasterRepository.getStoreMaster(cashRegisterEntityRes.tostrId!);
      if (storeMasterEntityRes == null) throw "Store Master not found";

      final UserEntity? userEntityRes = await _userRepository.getUser(params.tousrId!);
      if (userEntityRes == null) throw "User not found";

      await _receiptPrinter.printOpenShift(
          PrintOpenShiftDetail(
              storeMasterEntity: storeMasterEntityRes,
              cashRegisterEntity: cashRegisterEntityRes,
              userEntity: userEntityRes,
              cashierBalanceTransactionEntity: params),
          printType);
    } catch (e) {
      rethrow;
    }
  }
}

class PrintOpenShiftDetail {
  final StoreMasterEntity storeMasterEntity;
  final CashRegisterEntity cashRegisterEntity;
  final UserEntity userEntity;
  final CashierBalanceTransactionEntity cashierBalanceTransactionEntity;

  PrintOpenShiftDetail({
    required this.storeMasterEntity,
    required this.cashRegisterEntity,
    required this.userEntity,
    required this.cashierBalanceTransactionEntity,
  });
}
