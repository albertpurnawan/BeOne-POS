import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

abstract class MopSelectionRepository {
  Future<List<MopSelectionEntity>> getMopSelections();

  Future<MopSelectionEntity?> getMopSelectionByTpmt3Id(String tpmt3Id);

  Future<MopSelectionEntity> getCashMopSelection();
}
