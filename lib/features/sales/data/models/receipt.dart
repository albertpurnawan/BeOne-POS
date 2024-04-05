import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/data/models/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ReceiptModel extends ReceiptEntity implements BaseModel {
  ReceiptModel({
    required super.receiptItems,
    required super.totalPrice,
    super.createdAt,
    required super.docNum,
  });

  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
      receiptItems: List<ReceiptItemModel>.from(
        (map['receiptItems'] as List<int>).map<ReceiptItemModel>(
          (x) => ReceiptItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalprice'] as int,
      createdAt: map['createdat'] != null
          ? DateTime.parse(map['createdAt']).toLocal()
          : null,
      docNum: map['docNum'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiptItems': receiptItems.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt?.toUtc().toIso8601String(),
      'docNum': docNum
    };
  }

  factory ReceiptModel.fromEntity(ReceiptEntity entity) {
    return ReceiptModel(
      docNum: entity.docNum,
      receiptItems: entity.receiptItems,
      totalPrice: entity.totalPrice,
    );
  }
}
