import 'package:pos_fe/features/sales/data/models/down_payment_items_model.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';

class DownPaymetModel extends DownPaymentEntity {
  DownPaymetModel({
    super.refpos2,
    super.toinvDocId,
    required super.amount,
    super.tinv7,
  });

  factory DownPaymetModel.fromMap(Map<String, dynamic> map) {
    return DownPaymetModel(
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      amount: map['amount'] as double,
      tinv7: map['tinv7'] != null
          ? List<DownPaymentItemsModel>.from(
              (map['tinv7'] as List<dynamic>).map<DownPaymentItemsModel?>(
                (x) => DownPaymentItemsModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory DownPaymetModel.fromMapRemote(Map<String, dynamic> map) {
    return DownPaymetModel.fromMap({
      ...map,
      'toinvDocId': map['toinvdocid'] != null ? map['toinvdocid'] as String : null,
      'amount': map['balance'] is int ? (map['balance'] as int).toDouble() : map['balance'] as double,
    });
  }
}
