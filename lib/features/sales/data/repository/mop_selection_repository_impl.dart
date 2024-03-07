import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';

class MopSelectionRepositoryImpl implements MopSelectionRepository {
  final AppDatabase _appDatabase;
  MopSelectionRepositoryImpl(this._appDatabase);

  @override
  Future<List<MopSelectionEntity>> getMopSelections() {
    // TODO: implement getMopSelections
    throw UnimplementedError();
  }
}
