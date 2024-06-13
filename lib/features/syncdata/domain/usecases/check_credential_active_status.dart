import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckCredentialActiveStatusUseCase implements UseCase<void, void> {
  final SharedPreferences _prefs;

  CheckCredentialActiveStatusUseCase(this._prefs);

  @override
  Future<void> call({void params}) async {
    try {
      final AppDatabase db = GetIt.instance<AppDatabase>();

      final List<POSParameterEntity> posParameterEntities =
          await db.posParameterDao.readAll();
      if (posParameterEntities.isEmpty) return;

      final bool? isLoggedIn = _prefs.getBool("logStatus");
      if (isLoggedIn == null) return;
      if (isLoggedIn == false) return;

      final POSParameterEntity posParameterEntity = posParameterEntities[0];
      if (posParameterEntity.tostrId == null) {
        throw "Store ID not found in POS Parameter";
      }
      if (posParameterEntity.tocsrId == null) {
        throw "Cash Register ID not found in POS Parameter";
      }

      final StoreMasterEntity? storeMasterEntity = await db.storeMasterDao
          .readByDocId(posParameterEntity.tostrId!, null);
      if (storeMasterEntity == null) throw "Store not found";
      if (storeMasterEntity.statusActive == 0) throw "Store inactive";

      final CashRegisterEntity? cashRegisterEntity = await db.cashRegisterDao
          .readByDocId(posParameterEntity.tocsrId!, null);
      if (cashRegisterEntity == null) throw "Cash register not found";
      if (cashRegisterEntity.statusActive == 0) throw "Cash register inactive";

      final String? tousrId = _prefs.getString("tousrId");
      if (tousrId == null) throw "Login credential missing";
      final UserEntity? userEntity =
          await db.userDao.readByDocId(tousrId, null);
      if (userEntity == null) throw "User not found";
      if (userEntity.statusActive == 0) throw "User inactive";

      final String? tohemId = _prefs.getString("tohemId");
      if (tohemId == null) throw "Login credential missing";
      final EmployeeEntity? employeeEntity =
          await db.employeeDao.readByDocId(tohemId, null);
      if (employeeEntity == null) throw "Employee not found";
      if (employeeEntity.statusActive == 0) throw "Employee inactive";

      return;
    } catch (e) {
      rethrow;
    }
  }
}
