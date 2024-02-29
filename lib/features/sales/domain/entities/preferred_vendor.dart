// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PreferredVendorEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tsitmId;
  final String? tovenId;
  final int listing;
  final double minOrder;
  final double multipyOrder;
  final int canOrder;
  final int dflt;

  PreferredVendorEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tsitmId,
    required this.tovenId,
    required this.listing,
    required this.minOrder,
    required this.multipyOrder,
    required this.canOrder,
    required this.dflt,
  });

  PreferredVendorEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tsitmId,
    String? tovenId,
    int? listing,
    double? minOrder,
    double? multipyOrder,
    int? canOrder,
    int? dflt,
  }) {
    return PreferredVendorEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tsitmId: tsitmId ?? this.tsitmId,
      tovenId: tovenId ?? this.tovenId,
      listing: listing ?? this.listing,
      minOrder: minOrder ?? this.minOrder,
      multipyOrder: multipyOrder ?? this.multipyOrder,
      canOrder: canOrder ?? this.canOrder,
      dflt: dflt ?? this.dflt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tsitmId': tsitmId,
      'tovenId': tovenId,
      'listing': listing,
      'minOrder': minOrder,
      'multipyOrder': multipyOrder,
      'canOrder': canOrder,
      'dflt': dflt,
    };
  }

  factory PreferredVendorEntity.fromMap(Map<String, dynamic> map) {
    return PreferredVendorEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tsitmId: map['tsitmId'] != null ? map['tsitmId'] as String : null,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      listing: map['listing'] as int,
      minOrder: map['minOrder'] as double,
      multipyOrder: map['multipyOrder'] as double,
      canOrder: map['canOrder'] as int,
      dflt: map['dflt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferredVendorEntity.fromJson(String source) =>
      PreferredVendorEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PreferredVendorEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tsitmId: $tsitmId, tovenId: $tovenId, listing: $listing, minOrder: $minOrder, multipyOrder: $multipyOrder, canOrder: $canOrder, dflt: $dflt)';
  }

  @override
  bool operator ==(covariant PreferredVendorEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tsitmId == tsitmId &&
        other.tovenId == tovenId &&
        other.listing == listing &&
        other.minOrder == minOrder &&
        other.multipyOrder == multipyOrder &&
        other.canOrder == canOrder &&
        other.dflt == dflt;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tsitmId.hashCode ^
        tovenId.hashCode ^
        listing.hashCode ^
        minOrder.hashCode ^
        multipyOrder.hashCode ^
        canOrder.hashCode ^
        dflt.hashCode;
  }
}
