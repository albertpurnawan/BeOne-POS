import 'package:pos_fe/features/sales/domain/entities/store_master.dart';

abstract class StoreMasterRepository {
  Future<StoreMasterEntity?> getStoreMaster(String docId);
}
