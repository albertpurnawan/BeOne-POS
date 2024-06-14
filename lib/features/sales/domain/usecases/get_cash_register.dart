import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/repository/cash_register_repository.dart';

class GetCashRegisterUseCase implements UseCase<CashRegisterEntity?, String> {
  final CashRegisterRepository _cashRegisterRepository;

  GetCashRegisterUseCase(this._cashRegisterRepository);

  @override
  Future<CashRegisterEntity?> call({String params = ""}) async {
    if (params.isEmpty) return null;
    return await _cashRegisterRepository.getCashRegisterByDocId(params);
  }
}
