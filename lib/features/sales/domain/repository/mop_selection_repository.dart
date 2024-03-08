import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

abstract class MopSelectionRepository {
  Future<List<MopSelectionEntity>> getMopSelections();

  // Future<MopSelectionEntity?> getItemByBarcode(String barcode);

  // Future<MopSelectionEntity?> getItem(int id);
}
