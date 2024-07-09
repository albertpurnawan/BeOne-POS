// import 'package:pos_fe/core/resources/base_model.dart';
// import 'package:pos_fe/features/sales/domain/entities/netzme_data.dart';

// const String tableNetzme = "tntzm";

// class NetzmeFields {
//   static const List<String> values = [
//     docId,
//     url,
//     clientKey,
//     clientSecret,
//     privateKey,
//     custIdMerchant,
//   ];

//   static const String docId = "docid";
//   static const String url = "url";
//   static const String clientKey = "clientkey";
//   static const String clientSecret = "clientsecret";
//   static const String privateKey = "privatekey";
//   static const String custIdMerchant = "custidmerchant";
// }

// class NetzmeModel extends NetzmeEntity implements BaseModel {
//   NetzmeModel({
//     required super.docId,
//     required super.url,
//     required super.clientKey,
//     required super.clientSecret,
//     required super.privateKey,
//     required super.custIdMerchant,
//   });

//   @override
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'docid': docId,
//       'url': url,
//       'clientkey': clientKey,
//       'clientsecret': clientSecret,
//       'privatekey': privateKey,
//       'custidmerchant': custIdMerchant,
//     };
//   }

//   factory NetzmeModel.fromMap(Map<String, dynamic> map) {
//     return NetzmeModel(
//       docId: map['docid'] as String,
//       url: map['url'] as String,
//       clientKey: map['clientkey'] as String,
//       clientSecret: map['clientsecret'] as String,
//       privateKey: map['privatekey'] as String,
//       custIdMerchant: map['custidmerchant'] as String,
//     );
//   }

//   factory NetzmeModel.fromEntity(NetzmeEntity entity) {
//     return NetzmeModel(
//       docId: entity.docId,
//       url: entity.url,
//       clientKey: entity.clientKey,
//       clientSecret: entity.clientSecret,
//       privateKey: entity.privateKey,
//       custIdMerchant: entity.custIdMerchant,
//     );
//   }
// }
