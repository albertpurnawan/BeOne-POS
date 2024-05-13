import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/result.dart';
import 'package:pos_fe/features/sales/data/models/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/repository/cash_register_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';

class CashRegisterRepositoryImpl implements CashRegisterRepository {
  final AppDatabase _appDatabase;
  CashRegisterRepositoryImpl(this._appDatabase);

  @override
  Future<CashRegisterEntity?> getCashRegisterByDocId(String tocsrId) {
    // TODO: implement getCustomers
    return _appDatabase.cashRegisterDao.readByDocId(tocsrId, null);
  }
}
