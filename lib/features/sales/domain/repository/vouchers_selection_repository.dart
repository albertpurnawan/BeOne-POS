import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';

abstract class VouchersSelectionRepository {
  Future<VouchersSelectionEntity> checkVoucher(String serialno);
}
