// import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

// class NetzmeEntity {
//   final String docId;
//   final String url;
//   final String clientKey;
//   final String clientSecret;
//   final String privateKey;
//   final String custIdMerchant;
// // {
// //    "merchantUserId":"M_czBSCDVY", // kode merchant bak
// //    "buyerUserId":"9360081413398781", // dari user
// //    "buyerFullname":"4L4y W4S h3r3_________________", // dari user
// //    "netAmount":"IDR 2085.00", // total
// //    "merchantFee":"IDR 15.00",
// //    "issuerName":"93600814", //
// //    "acquirerName":"Netzme",
// //    "customerPan":"9360081413398781", //
// //    "merchantPan":"936008140100000002", //
// //    "merchantName":"Gulu Gulu Mall Ambassador",
// //    "merchantLocation":"Jakarta Selat", // from response createQRIS
// //    "transactionId":"9933033931", // from response createQRIS (trxId)
// //    "ts":"2021-03-09 13:21:54.629000+0700", // from response createQRIS, expireTs
// //    "tsLong":1615270914629, // ts convert timestamp
// //    "amount":"IDR 2100.00", // grandTotal
// //    "status":"100", // from response createQRIS, status ()?
// //    "statusMessage":"success", // from response createQRIS,
// //    "type":"pay_qris", //from response payMethod
// //    "referenceId":"306410381877" //body partner reference No
// // }

//   NetzmeEntity({
//     required this.docId,
//     required this.url,
//     required this.clientKey,
//     required this.clientSecret,
//     required this.privateKey,
//     required this.custIdMerchant,
//   });

//   NetzmeEntity copyWith({
//     String? docId,
//     String? url,
//     String? clientKey,
//     String? clientSecret,
//     String? privateKey,
//     String? custIdMerchant,
//   }) {
//     return NetzmeEntity(
//       docId: docId ?? this.docId,
//       url: url ?? this.url,
//       clientKey: clientKey ?? this.clientKey,
//       clientSecret: clientSecret ?? this.clientSecret,
//       privateKey: privateKey ?? this.privateKey,
//       custIdMerchant: custIdMerchant ?? this.custIdMerchant,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'docId': docId,
//       'url': url,
//       'clientKey': clientKey,
//       'clientSecret': clientSecret,
//       'privateKey': privateKey,
//       'custIdMerchant': custIdMerchant,
//     };
//   }

//   factory NetzmeEntity.fromMap(Map<String, dynamic> map) {
//     return NetzmeEntity(
//       docId: map['docId'] as String,
//       url: map['url'] as String,
//       clientKey: map['clientKey'] as String,
//       clientSecret: map['clientSecret'] as String,
//       privateKey: map['privateKey'] as String,
//       custIdMerchant: map['custIdMerchant'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory NetzmeEntity.fromJson(String source) =>
//       NetzmeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'NetzmeEntity(docId: $docId, url: $url, clientKey: $clientKey, clientSecret: $clientSecret, privateKey: $privateKey, custIdMerchant: $custIdMerchant)';
//   }

//   @override
//   bool operator ==(covariant NetzmeEntity other) {
//     if (identical(this, other)) return true;

//     return other.docId == docId &&
//         other.url == url &&
//         other.clientKey == clientKey &&
//         other.clientSecret == clientSecret &&
//         other.privateKey == privateKey &&
//         other.custIdMerchant == custIdMerchant;
//   }

//   @override
//   int get hashCode {
//     return docId.hashCode ^
//         url.hashCode ^
//         clientKey.hashCode ^
//         clientSecret.hashCode ^
//         privateKey.hashCode ^
//         custIdMerchant.hashCode;
//   }
// }
