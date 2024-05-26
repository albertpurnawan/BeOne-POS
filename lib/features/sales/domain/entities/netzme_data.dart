import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class NetzmeEntity {
  final String docId;
  final String url;
  final String clientKey;
  final String clientSecret;
  final String privateKey;
  final String custIdMerchant;

  NetzmeEntity({
    required this.docId,
    required this.url,
    required this.clientKey,
    required this.clientSecret,
    required this.privateKey,
    required this.custIdMerchant,
  });

  NetzmeEntity copyWith({
    String? docId,
    String? url,
    String? clientKey,
    String? clientSecret,
    String? privateKey,
    String? custIdMerchant,
  }) {
    return NetzmeEntity(
      docId: docId ?? this.docId,
      url: url ?? this.url,
      clientKey: clientKey ?? this.clientKey,
      clientSecret: clientSecret ?? this.clientSecret,
      privateKey: privateKey ?? this.privateKey,
      custIdMerchant: custIdMerchant ?? this.custIdMerchant,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'url': url,
      'clientKey': clientKey,
      'clientSecret': clientSecret,
      'privateKey': privateKey,
      'custIdMerchant': custIdMerchant,
    };
  }

  factory NetzmeEntity.fromMap(Map<String, dynamic> map) {
    return NetzmeEntity(
      docId: map['docId'] as String,
      url: map['url'] as String,
      clientKey: map['clientKey'] as String,
      clientSecret: map['clientSecret'] as String,
      privateKey: map['privateKey'] as String,
      custIdMerchant: map['custIdMerchant'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NetzmeEntity.fromJson(String source) =>
      NetzmeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NetzmeEntity(docId: $docId, url: $url, clientKey: $clientKey, clientSecret: $clientSecret, privateKey: $privateKey, custIdMerchant: $custIdMerchant)';
  }

  @override
  bool operator ==(covariant NetzmeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.url == url &&
        other.clientKey == clientKey &&
        other.clientSecret == clientSecret &&
        other.privateKey == privateKey &&
        other.custIdMerchant == custIdMerchant;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        url.hashCode ^
        clientKey.hashCode ^
        clientSecret.hashCode ^
        privateKey.hashCode ^
        custIdMerchant.hashCode;
  }
}
