import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/vouchers_selection_repository.dart';

class CheckVoucherUseCase implements UseCase<VouchersSelectionEntity, String?> {
  final VouchersSelectionRepository _vouchersSelectionRepository;

  CheckVoucherUseCase(this._vouchersSelectionRepository);

  @override
  Future<VouchersSelectionEntity> call({String? params}) {
    // TODO: implement call
    return _vouchersSelectionRepository.checkVoucher(params!);
  }
}
