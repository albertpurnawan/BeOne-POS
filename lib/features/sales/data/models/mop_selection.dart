import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

class MopSelectionModel extends MopSelectionEntity {
  MopSelectionModel(
      {required super.tpmt3Id,
      required super.tpmt1Id,
      required super.mopAlias,
      required super.bankCharge,
      required super.payTypeCode,
      required super.description});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tpmt3Id': tpmt3Id,
      'tpmt1Id': tpmt1Id,
      'mopalias': mopAlias,
      'bankcharge': bankCharge,
      'paytypecode': payTypeCode,
      'description': description,
    };
  }

  factory MopSelectionModel.fromMap(Map<String, dynamic> map) {
    return MopSelectionModel(
      tpmt3Id: map['tpmt3Id'] as String,
      tpmt1Id: map['tpmt1Id'] as String,
      mopAlias: map['mopalias'] as String,
      bankCharge:
          map['bankcharge'] != null ? map['bankcharge'] as double : null,
      payTypeCode:
          map['paytypecode'] != null ? map['paytypecode'] as String : null,
      description: map['description'] as String,
    );
  }
}
