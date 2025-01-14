import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/vouchers_selection_repository.dart';

class VouchersSelectionRepositoryImpl extends VouchersSelectionRepository {
  final AppDatabase _appDatabase;
  VouchersSelectionRepositoryImpl(this._appDatabase);

  @override
  Future<VouchersSelectionEntity> checkVoucher(String serialno) async {
    return await _appDatabase.vouchersSelectionDao.checkVoucher(serialno);
  }

  @override
  Future<List<VouchersSelectionEntity>> readBytinv2Id(String tinv2id) async {
    try {
      return await _appDatabase.vouchersSelectionDao.readBytinv2Id(tinv2id);
    } catch (e) {
      // Handle errors appropriately
      rethrow;
    }
  }
}
