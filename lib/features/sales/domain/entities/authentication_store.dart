import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class AuthStoreEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String tostrdocid;
  final String tousrdocid;
  final int statusActive;
  final int? dflt;
  final int discAndRound;
  final int nonPositiveTrx;
  final int closeShift;
  final String form;

  AuthStoreEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.tostrdocid,
    required this.tousrdocid,
    required this.statusActive,
    this.dflt,
    required this.discAndRound,
    required this.nonPositiveTrx,
    required this.closeShift,
    required this.form,
  });

  AuthStoreEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tostrdocid,
    String? tousrdocid,
    int? statusActive,
    int? dflt,
    int? discAndRound,
    int? nonPositiveTrx,
    int? closeShift,
    String? form,
  }) {
    return AuthStoreEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tostrdocid: tostrdocid ?? this.tostrdocid,
      tousrdocid: tousrdocid ?? this.tousrdocid,
      statusActive: statusActive ?? this.statusActive,
      dflt: dflt ?? this.dflt,
      discAndRound: discAndRound ?? this.discAndRound,
      nonPositiveTrx: nonPositiveTrx ?? this.nonPositiveTrx,
      closeShift: closeShift ?? this.closeShift,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tostrdocid': tostrdocid,
      'tousrdocid': tousrdocid,
      'statusActive': statusActive,
      'dflt': dflt,
      'discAndRound': discAndRound,
      'nonPositiveTrx': nonPositiveTrx,
      'closeShift': closeShift,
      'form': form,
    };
  }

  factory AuthStoreEntity.fromMap(Map<String, dynamic> map) {
    return AuthStoreEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      tostrdocid: map['tostrdocid'] as String,
      tousrdocid: map['tousrdocid'] as String,
      statusActive: map['statusActive'] as int,
      dflt: map['dflt'] != null ? map['dflt'] as int : null,
      discAndRound: map['discAndRound'] as int,
      nonPositiveTrx: map['nonPositiveTrx'] as int,
      closeShift: map['closeShift'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthStoreEntity.fromJson(String source) =>
      AuthStoreEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthStoreEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tostrdocid: $tostrdocid, tousrdocid: $tousrdocid, statusActive: $statusActive, dflt: $dflt, discAndRound: $discAndRound, nonPositiveTrx: $nonPositiveTrx, closeShift: $closeShift, form: $form)';
  }

  @override
  bool operator ==(covariant AuthStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tostrdocid == tostrdocid &&
        other.tousrdocid == tousrdocid &&
        other.statusActive == statusActive &&
        other.dflt == dflt &&
        other.discAndRound == discAndRound &&
        other.nonPositiveTrx == nonPositiveTrx &&
        other.closeShift == closeShift &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tostrdocid.hashCode ^
        tousrdocid.hashCode ^
        statusActive.hashCode ^
        dflt.hashCode ^
        discAndRound.hashCode ^
        nonPositiveTrx.hashCode ^
        closeShift.hashCode ^
        form.hashCode;
  }
}
