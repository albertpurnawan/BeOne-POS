import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/vouchers_selection_repository.dart';

class ReadVouchersByTinv2IdUseCase
    implements UseCase<List<VouchersSelectionEntity>, String?> {
  final VouchersSelectionRepository _vouchersSelectionRepository;

  ReadVouchersByTinv2IdUseCase(this._vouchersSelectionRepository);

  @override
  Future<List<VouchersSelectionEntity>> call({String? params}) async {
    return _vouchersSelectionRepository.readBytinv2Id(params!);
  }
}
