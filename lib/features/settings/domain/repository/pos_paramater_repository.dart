import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';

abstract class POSParameterRepository {
  Future<POSParameterEntity> getPosParameter();

  Future<void> createPosParameter(POSParameterEntity posParameterEntity);

  Future<void> updatePosParemeter(POSParameterEntity posParameterEntity);
}
