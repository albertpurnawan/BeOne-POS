import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';

class MopSelectionModel extends MopSelectionEntity {
  MopSelectionModel({
    required super.tpmt3Id,
    required super.tpmt1Id,
    required super.mopAlias,
    required super.bankCharge,
    required super.payTypeCode,
    required super.description,
    required super.amount,
    required super.subType,
    required super.tinv2Id,
    required super.tpmt4Id,
    required super.edcDesc,
    required super.tpmt2Id,
    required super.cardName,
    required super.cardNo,
    required super.cardHolder,
    required super.rrn,
    required super.tpmt6Id,
    required super.tpmt7Id,
  });

  factory MopSelectionModel.fromMap(Map<String, dynamic> map) {
    return MopSelectionModel(
      tpmt3Id: map['tpmt3Id'] as String,
      tpmt1Id: map['tpmt1Id'] as String,
      mopAlias: map['mopalias'] as String,
      bankCharge: map['bankcharge'] != null ? map['bankcharge'] as double : null,
      payTypeCode: map['paytypecode'] != null ? map['paytypecode'] as String : null,
      description: map['description'] as String,
      amount: map['amount'] != null ? map['amount'] as double : null,
      subType: map['subtype'],
      tinv2Id: map['tinv2Id'] != null ? map['tinv2Id'] as String : null,
      tpmt4Id: map['tpmt4Id'] != null ? map['tpmt4Id'] as String : null,
      edcDesc: map['edcdesc'] != null ? map['edcdesc'] as String : null,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
      cardName: map['cardname'] != null ? map['cardname'] as String : null,
      cardNo: map['cardno'] != null ? map['cardno'] as String : null,
      cardHolder: map['cardholder'] != null ? map['cardholder'] as String : null,
      rrn: map['rrn'] != null ? map['rrn'] as String : null,
      tpmt6Id: map['tpmt6Id'] != null ? map['tpmt6Id'] as String : null,
      tpmt7Id: map['tpmt7Id'] != null ? map['tpmt7Id'] as String : null,
    );
  }
}
