// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerAddressEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tocusId;
  final int linenum;
  final String addr1;
  final String? addr2;
  final String? addr3;
  final String city;
  final String? toprvId;
  final String? tocryId;
  final String? tozcdId;

  CustomerAddressEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tocusId,
    required this.linenum,
    required this.addr1,
    required this.addr2,
    required this.addr3,
    required this.city,
    required this.toprvId,
    required this.tocryId,
    required this.tozcdId,
  });

  CustomerAddressEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tocusId,
    int? linenum,
    String? addr1,
    String? addr2,
    String? addr3,
    String? city,
    String? toprvId,
    String? tocryId,
    String? tozcdId,
  }) {
    return CustomerAddressEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tocusId: tocusId ?? this.tocusId,
      linenum: linenum ?? this.linenum,
      addr1: addr1 ?? this.addr1,
      addr2: addr2 ?? this.addr2,
      addr3: addr3 ?? this.addr3,
      city: city ?? this.city,
      toprvId: toprvId ?? this.toprvId,
      tocryId: tocryId ?? this.tocryId,
      tozcdId: tozcdId ?? this.tozcdId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tocusId': tocusId,
      'linenum': linenum,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'city': city,
      'toprvId': toprvId,
      'tocryId': tocryId,
      'tozcdId': tozcdId,
    };
  }

  factory CustomerAddressEntity.fromMap(Map<String, dynamic> map) {
    return CustomerAddressEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      linenum: map['linenum'] as int,
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdId: map['tozcdId'] != null ? map['tozcdId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerAddressEntity.fromJson(String source) =>
      CustomerAddressEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerAddressEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tocusId: $tocusId, linenum: $linenum, addr1: $addr1, addr2: $addr2, addr3: $addr3, city: $city, toprvId: $toprvId, tocryId: $tocryId, tozcdId: $tozcdId)';
  }

  @override
  bool operator ==(covariant CustomerAddressEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tocusId == tocusId &&
        other.linenum == linenum &&
        other.addr1 == addr1 &&
        other.addr2 == addr2 &&
        other.addr3 == addr3 &&
        other.city == city &&
        other.toprvId == toprvId &&
        other.tocryId == tocryId &&
        other.tozcdId == tozcdId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tocusId.hashCode ^
        linenum.hashCode ^
        addr1.hashCode ^
        addr2.hashCode ^
        addr3.hashCode ^
        city.hashCode ^
        toprvId.hashCode ^
        tocryId.hashCode ^
        tozcdId.hashCode;
  }
}
