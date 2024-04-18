import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

class OpenShiftPrint {
  final POSParameterEntity posParameterEntity;
  final StoreMasterEntity storeMasterEntity;
  final EmployeeEntity? employeeEntity;
  final List<ReceiptContentEntity?> receiptContentEntities;

  OpenShiftPrint({
    required this.posParameterEntity,
    required this.storeMasterEntity,
    this.employeeEntity,
    required this.receiptContentEntities,
  });
}
