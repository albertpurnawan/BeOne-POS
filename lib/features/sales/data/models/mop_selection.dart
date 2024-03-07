import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

class MopSelectionModel extends MopSelectionEntity {
  MopSelectionModel(
      {required super.tpmt3Id,
      required super.tpmt1Id,
      required super.mopAlias,
      required super.bankCharge});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tpmt3Id': tpmt3Id,
      'tpmt1Id': tpmt1Id,
      'mopAlias': mopAlias,
      'bankCharge': bankCharge,
    };
  }

  factory MopSelectionModel.fromMap(Map<String, dynamic> map) {
    return MopSelectionModel(
      tpmt3Id: map['tpmt3Id'] as String,
      tpmt1Id: map['tpmt1Id'] as String,
      mopAlias: map['mopAlias'] as String,
      bankCharge:
          map['bankCharge'] != null ? map['bankCharge'] as double : null,
    );
  }
}
