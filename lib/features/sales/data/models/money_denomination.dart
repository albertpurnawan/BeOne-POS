import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/money_denomination.dart';

const String tableMoneyDenomination = "tcsr2";

class MoneyDenominationFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    nominal,
    count,
    tcsr1Id,
  ];
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String nominal = "nominal";
  static const String count = "count";
  static const String tcsr1Id = "tcsr1Id";
}

class MoneyDenominationModel extends MoneyDenominationEntity
    implements BaseModel {
  MoneyDenominationModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.nominal,
    required super.count,
    required super.tcsr1Id,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'nominal': nominal,
      'count': count,
      'tcsr1Id': tcsr1Id,
    };
  }

  factory MoneyDenominationModel.fromMapRemote(Map<String, dynamic> map) {
    return MoneyDenominationModel.fromMap({
      ...map,
      "tcsr1Id": map['tcsr1docid'] != null ? map['tcsr1docid'] as String : null,
    });
  }

  factory MoneyDenominationModel.fromMap(Map<String, dynamic> map) {
    return MoneyDenominationModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      nominal: map['nominal'] != null ? map['nominal'] as int : null,
      count: map['count'] != null ? map['count'] as int : null,
      tcsr1Id: map['tcsr1Id'] != null ? map['tcsr1Id'] as String : null,
    );
  }

  factory MoneyDenominationModel.fromEntity(MoneyDenominationEntity entity) {
    return MoneyDenominationModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      nominal: entity.nominal,
      count: entity.count,
      tcsr1Id: entity.tcsr1Id,
    );
  }
}
