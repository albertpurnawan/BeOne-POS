import 'package:pos_fe/features/sales/domain/entities/uom.dart';

abstract class UoMRepository {
  Future<List<UomEntity>> getUoMs();

  Future<UomEntity?> getSingleUoM();
}
