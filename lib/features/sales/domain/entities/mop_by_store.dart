// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MOPByStoreEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tpmt1Id;
  final String? tostrId;
  final String form;

  MOPByStoreEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.tpmt1Id,
    this.tostrId,
    required this.form,
  });

  MOPByStoreEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tpmt1Id,
    String? tostrId,
    String? form,
  }) {
    return MOPByStoreEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      tostrId: tostrId ?? this.tostrId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tpmt1Id': tpmt1Id,
      'tostrId': tostrId,
      'form': form,
    };
  }

  factory MOPByStoreEntity.fromMap(Map<String, dynamic> map) {
    return MOPByStoreEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MOPByStoreEntity.fromJson(String source) =>
      MOPByStoreEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MOPByStoreEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tpmt1Id: $tpmt1Id, tostrId: $tostrId, form: $form)';
  }

  @override
  bool operator ==(covariant MOPByStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tpmt1Id == tpmt1Id &&
        other.tostrId == tostrId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tpmt1Id.hashCode ^
        tostrId.hashCode ^
        form.hashCode;
  }
}
