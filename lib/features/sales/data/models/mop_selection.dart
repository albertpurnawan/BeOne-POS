import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';
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
    required super.creditCard,
    required super.cardNo,
    required super.cardHolder,
    required super.rrn,
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
      creditCard: map['creditcard'] != null ? CreditCardEntity.fromMap(map['creditcard'] as Map<String, dynamic>) : null,
      cardNo: map['cardno'] != null ? map['cardno'] as String : null,
      cardHolder: map['cardholder'] != null ? map['cardholder'] as String : null,
      rrn: map['rrn'] != null ? map['rrn'] as String : null,
    );
  }
}
