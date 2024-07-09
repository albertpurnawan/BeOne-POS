import 'package:pos_fe/features/sales/domain/entities/edc_selection.dart';

class EDCSelectionModel extends EDCSelectionEntity {
  EDCSelectionModel({
    required super.docId,
    required super.creditCard,
    required super.cardNoPrefix,
    required super.cardNoSuffix,
    required super.campaign,
    required super.amount,
  });
}
