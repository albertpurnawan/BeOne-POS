// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemRemarkEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toitmId;
  final String? remarks;
  final String form;

  ItemRemarkEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.toitmId,
    this.remarks,
    required this.form,
  });

  ItemRemarkEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toitmId,
    String? remarks,
    String? form,
  }) {
    return ItemRemarkEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toitmId: toitmId ?? this.toitmId,
      remarks: remarks ?? this.remarks,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toitmId': toitmId,
      'remarks': remarks,
      'form': form,
    };
  }

  factory ItemRemarkEntity.fromMap(Map<String, dynamic> map) {
    return ItemRemarkEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemRemarkEntity.fromJson(String source) =>
      ItemRemarkEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemRemarkEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toitmId: $toitmId, remarks: $remarks, form: $form)';
  }

  @override
  bool operator ==(covariant ItemRemarkEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toitmId == toitmId &&
        other.remarks == remarks &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toitmId.hashCode ^
        remarks.hashCode ^
        form.hashCode;
  }
}
