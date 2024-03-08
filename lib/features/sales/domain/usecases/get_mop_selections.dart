import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';

class GetMopSelectionsUseCase
    implements UseCase<List<MopSelectionEntity>, void> {
  final MopSelectionRepository _mopSelectionRepository;

  GetMopSelectionsUseCase(this._mopSelectionRepository);

  @override
  Future<List<MopSelectionEntity>> call({void params}) {
    // TODO: implement call
    return _mopSelectionRepository.getMopSelections();
  }
}
