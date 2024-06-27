import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:pos_fe/features/sales/domain/repository/cash_register_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/user_repository.dart';

class PrintCloseShiftUsecase
    implements UseCase<void, PrintCloseShiftUsecaseParams> {
  // POS Parameter
  final ReceiptPrinter _receiptPrinter;
  final CashRegisterRepository _cashRegisterRepository;
  final StoreMasterRepository _storeMasterRepository;
  final UserRepository _userRepository;

  PrintCloseShiftUsecase(this._receiptPrinter, this._cashRegisterRepository,
      this._storeMasterRepository, this._userRepository);

  @override
  Future<void> call({PrintCloseShiftUsecaseParams? params}) async {
    try {
      if (params == null ||
          params.cashierBalanceTransactionEntity.tocsrId == null ||
          params.cashierBalanceTransactionEntity.tousrId == null) {
        return;
      }

      final CashRegisterEntity? cashRegisterEntityRes =
          await _cashRegisterRepository.getCashRegisterByDocId(
              params.cashierBalanceTransactionEntity.tocsrId!);
      if (cashRegisterEntityRes == null) throw "Cash Register not found";
      if (cashRegisterEntityRes.tostrId == null) {
        throw "Cash Register does not contain store information";
      }

      final StoreMasterEntity? storeMasterEntityRes =
          await _storeMasterRepository
              .getStoreMaster(cashRegisterEntityRes.tostrId!);
      if (storeMasterEntityRes == null) throw "Store Master not found";

      final UserEntity? userEntityRes = await _userRepository
          .getUser(params.cashierBalanceTransactionEntity.tousrId!);
      if (userEntityRes == null) throw "User not found";

      await _receiptPrinter.printCloseShift(PrintCloseShiftDetail(
        storeMasterEntity: storeMasterEntityRes,
        cashRegisterEntity: cashRegisterEntityRes,
        userEntity: userEntityRes,
        cashierBalanceTransactionEntity: params.cashierBalanceTransactionEntity,
        totalCashSales: params.totalCashSales.round(),
        expectedCash: params.expectedCash.round(),
        totalNonCashSales: params.totalCashSales.round(),
        totalSales: params.totalSales.round(),
        cashReceived: params.cashReceived.round(),
        difference: params.difference.round(),
        approverName: params.approverName,
      ));
    } catch (e) {
      rethrow;
    }
  }
}

class PrintCloseShiftUsecaseParams {
  final CashierBalanceTransactionEntity cashierBalanceTransactionEntity;
  final double totalCashSales;
  final double expectedCash;
  final double totalNonCashSales;
  final double totalSales;
  final double cashReceived;
  final double difference;
  final String approverName;

  PrintCloseShiftUsecaseParams({
    required this.cashierBalanceTransactionEntity,
    required this.totalCashSales,
    required this.expectedCash,
    required this.totalNonCashSales,
    required this.totalSales,
    required this.cashReceived,
    required this.difference,
    required this.approverName,
  });
}

class PrintCloseShiftDetail {
  final StoreMasterEntity storeMasterEntity;
  final CashRegisterEntity cashRegisterEntity;
  final UserEntity userEntity;
  final CashierBalanceTransactionEntity cashierBalanceTransactionEntity;
  final int totalCashSales;
  final int expectedCash;
  final int totalNonCashSales;
  final int totalSales;
  final int cashReceived;
  final int difference;
  final String approverName;

  PrintCloseShiftDetail({
    required this.storeMasterEntity,
    required this.cashRegisterEntity,
    required this.userEntity,
    required this.cashierBalanceTransactionEntity,
    required this.totalCashSales,
    required this.expectedCash,
    required this.totalNonCashSales,
    required this.totalSales,
    required this.cashReceived,
    required this.difference,
    required this.approverName,
  });
}
