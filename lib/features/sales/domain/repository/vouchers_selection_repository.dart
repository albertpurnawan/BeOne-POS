import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';

abstract class VouchersSelectionRepository {
  Future<VouchersSelectionEntity> checkVoucher(String serialno);

  Future<List<VouchersSelectionEntity>> readBytinv2Id(String tinv2id);
}
