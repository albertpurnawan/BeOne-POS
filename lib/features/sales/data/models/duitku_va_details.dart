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
    totalFee,
    statusActive
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String paymentMethod = "paymentmethod";
  static const String paymentName = "paymentname";
  static const String paymentImage = "paymentimage";
  static const String totalFee = "totalfee";
  static const String statusActive = "statusactive";
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
    required super.statusActive,
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
      'statusactive': statusActive,
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
      totalFee: map['totalfee'] as int,
      statusActive: map['statusactive'] as int,
    );
  }

  factory DuitkuVADetailsModel.fromMapRemote(Map<String, dynamic> map) {
    return DuitkuVADetailsModel.fromMap({
      ...map,
      "docid": map['toval_id']['docid'] as String,
      "paymentmethod": map['toval_id']?['paymentmethod'] != null ? map['toval_id']['paymentmethod'] as String : null,
      "paymentname": map['toval_id']?['paymentname'] != null ? map['toval_id']['paymentname'] as String : null,
      "paymentimage": map['toval_id']?['paymentimage'] != null ? map['toval_id']['paymentimage'] as String : null,
      "totalfee": map['toval_id']?['totalfee'] != null ? map['toval_id']['totalfee'] as int : null,
      "statusactive": map['toval_id']?['statusactive'] != null ? map['toval_id']['statusactive'] as int : null,
    });
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
      statusActive: entity.statusActive,
    );
  }
}
