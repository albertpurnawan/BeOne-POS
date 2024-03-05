// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashRegisterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tostrId;
  final String hwkey;
  final String token;
  final String email;
  final int statusActive;
  final int activated;
  final String description;
  final String? ipKassa;
  final String? idKassa;
  final String? printerCode;
  final int? printerLogo;
  final int? strukType;
  final int? bigHeader;
  final int? syncCloud;

  CashRegisterEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tostrId,
    required this.hwkey,
    required this.token,
    required this.email,
    required this.statusActive,
    required this.activated,
    required this.description,
    required this.ipKassa,
    required this.idKassa,
    required this.printerCode,
    required this.printerLogo,
    required this.strukType,
    required this.bigHeader,
    required this.syncCloud,
  });

  CashRegisterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tostrId,
    String? hwkey,
    String? token,
    String? email,
    int? statusActive,
    int? activated,
    String? description,
    String? ipKassa,
    String? idKassa,
    String? printerCode,
    int? printerLogo,
    int? strukType,
    int? bigHeader,
    int? syncCloud,
  }) {
    return CashRegisterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tostrId: tostrId ?? this.tostrId,
      hwkey: hwkey ?? this.hwkey,
      token: token ?? this.token,
      email: email ?? this.email,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      description: description ?? this.description,
      ipKassa: ipKassa ?? this.ipKassa,
      idKassa: idKassa ?? this.idKassa,
      printerCode: printerCode ?? this.printerCode,
      printerLogo: printerLogo ?? this.printerLogo,
      strukType: strukType ?? this.strukType,
      bigHeader: bigHeader ?? this.bigHeader,
      syncCloud: syncCloud ?? this.syncCloud,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tostrId': tostrId,
      'hwkey': hwkey,
      'token': token,
      'email': email,
      'statusActive': statusActive,
      'activated': activated,
      'description': description,
      'ipKassa': ipKassa,
      'idKassa': idKassa,
      'printerCode': printerCode,
      'printerLogo': printerLogo,
      'strukType': strukType,
      'bigHeader': bigHeader,
      'syncCloud': syncCloud,
    };
  }

  factory CashRegisterEntity.fromMap(Map<String, dynamic> map) {
    return CashRegisterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      hwkey: map['hwkey'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      description: map['description'] as String,
      ipKassa: map['ipKassa'] != null ? map['ipKassa'] as String : null,
      idKassa: map['idKassa'] != null ? map['idKassa'] as String : null,
      printerCode:
          map['printerCode'] != null ? map['printerCode'] as String : null,
      printerLogo:
          map['printerLogo'] != null ? map['printerLogo'] as int : null,
      strukType: map['strukType'] != null ? map['strukType'] as int : null,
      bigHeader: map['bigHeader'] != null ? map['bigHeader'] as int : null,
      syncCloud: map['syncCloud'] != null ? map['syncCloud'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashRegisterEntity.fromJson(String source) =>
      CashRegisterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CashRegisterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tostrId: $tostrId, hwkey: $hwkey, token: $token, email: $email, statusActive: $statusActive, activated: $activated, description: $description, ipKassa: $ipKassa, idKassa: $idKassa, printerCode: $printerCode, printerLogo: $printerLogo, strukType: $strukType, bigHeader: $bigHeader, syncCloud: $syncCloud)';
  }

  @override
  bool operator ==(covariant CashRegisterEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tostrId == tostrId &&
        other.hwkey == hwkey &&
        other.token == token &&
        other.email == email &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.description == description &&
        other.ipKassa == ipKassa &&
        other.idKassa == idKassa &&
        other.printerCode == printerCode &&
        other.printerLogo == printerLogo &&
        other.strukType == strukType &&
        other.bigHeader == bigHeader &&
        other.syncCloud == syncCloud;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tostrId.hashCode ^
        hwkey.hashCode ^
        token.hashCode ^
        email.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        description.hashCode ^
        ipKassa.hashCode ^
        idKassa.hashCode ^
        printerCode.hashCode ^
        printerLogo.hashCode ^
        strukType.hashCode ^
        bigHeader.hashCode ^
        syncCloud.hashCode;
  }
}
