// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DuitkuVADetailsEntity {
  final String docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String paymentMethod;
  final String paymentName;
  final String paymentImage;
  final int totalFee;
  final int statusActive;

  DuitkuVADetailsEntity({
    required this.docId,
    this.createDate,
    this.updateDate,
    required this.paymentMethod,
    required this.paymentName,
    required this.paymentImage,
    required this.totalFee,
    required this.statusActive,
  });

  DuitkuVADetailsEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? paymentMethod,
    String? paymentName,
    String? paymentImage,
    int? totalFee,
    int? statusActive,
  }) {
    return DuitkuVADetailsEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentName: paymentName ?? this.paymentName,
      paymentImage: paymentImage ?? this.paymentImage,
      totalFee: totalFee ?? this.totalFee,
      statusActive: statusActive ?? this.statusActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'paymentName': paymentName,
      'paymentImage': paymentImage,
      'totalFee': totalFee,
      'statusActive': statusActive,
    };
  }

  factory DuitkuVADetailsEntity.fromMap(Map<String, dynamic> map) {
    return DuitkuVADetailsEntity(
      docId: map['docId'] as String,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int) : null,
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      paymentMethod: map['paymentMethod'] as String,
      paymentName: map['paymentName'] as String,
      paymentImage: map['paymentImage'] as String,
      totalFee: map['totalFee'] as int,
      statusActive: map['statusActive'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DuitkuVADetailsEntity.fromJson(String source) =>
      DuitkuVADetailsEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DuitkuVADetailsEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, paymentMethod: $paymentMethod, paymentName: $paymentName, paymentImage: $paymentImage, totalFee: $totalFee, statusActive: $statusActive)';
  }

  @override
  bool operator ==(covariant DuitkuVADetailsEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.paymentMethod == paymentMethod &&
        other.paymentName == paymentName &&
        other.paymentImage == paymentImage &&
        other.totalFee == totalFee &&
        other.statusActive == statusActive;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        paymentMethod.hashCode ^
        paymentName.hashCode ^
        paymentImage.hashCode ^
        totalFee.hashCode ^
        statusActive.hashCode;
  }
}
