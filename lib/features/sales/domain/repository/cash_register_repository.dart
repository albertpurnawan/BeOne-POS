import 'package:pos_fe/core/resources/result.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';

abstract class CashRegisterRepository {
  Future<CashRegisterEntity?> getCashRegisterByDocId(String tocsrId);
}
