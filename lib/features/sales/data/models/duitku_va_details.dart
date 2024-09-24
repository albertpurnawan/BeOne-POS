import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_va_details.dart';

const String tableDuitkuVADetails = "toval";

class DuitkuVADetailsFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    paymentMethod,
    paymentName,
    paymentImage,
    totalFee
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String paymentMethod = "paymentmethod";
  static const String paymentName = "paymentname";
  static const String paymentImage = "paymentimage";
  static const String totalFee = "totalfee";
}

class DuitkuVADetailsModel extends DuitkuVADetailsEntity implements BaseModel {
  DuitkuVADetailsModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.paymentMethod,
    required super.paymentName,
    required super.paymentImage,
    required super.totalFee,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate?.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'paymentmethod': paymentMethod,
      'paymentname': paymentName,
      'paymentimage': paymentImage,
      'totalfee': totalFee,
    };
  }

  factory DuitkuVADetailsModel.fromMap(Map<String, dynamic> map) {
    return DuitkuVADetailsModel(
      docId: map['docid'] as String,
      createDate: map['createdate'] != null ? DateTime.parse(map['createdate'] as String).toLocal() : null,
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      paymentMethod: map['paymentmethod'] as String,
      paymentName: map['paymentname'] as String,
      paymentImage: map['paymentimage'] as String,
      totalFee: map['totalFee'] as int,
    );
  }

  factory DuitkuVADetailsModel.fromEntity(DuitkuVADetailsEntity entity) {
    return DuitkuVADetailsModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      paymentMethod: entity.paymentMethod,
      paymentName: entity.paymentName,
      paymentImage: entity.paymentImage,
      totalFee: entity.totalFee,
    );
  }
}
