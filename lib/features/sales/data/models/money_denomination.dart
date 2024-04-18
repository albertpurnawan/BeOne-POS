import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/money_denomination.dart';

const String tableMoneyDemonination = "moneydeno";

class MoneyDenominationFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tcsr1Id,
    coin50,
    coin100,
    coin200,
    coin500,
    coin1k,
    paper1k,
    paper2k,
    paper5k,
    paper10k,
    paper20k,
    paper50k,
    paper100k,
  ];
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tcsr1Id = "tcsr1Id";
  static const String coin50 = "coin50";
  static const String coin100 = "coin100";
  static const String coin200 = "coin200";
  static const String coin500 = "coin500";
  static const String coin1k = "coin1k";
  static const String paper1k = "paper1k";
  static const String paper2k = "paper2k";
  static const String paper5k = "paper5k";
  static const String paper10k = "paper10k";
  static const String paper20k = "paper20k";
  static const String paper50k = "paper50k";
  static const String paper100k = "paper100k";
}

class MoneyDenominationModel extends MoneyDenominationEntity
    implements BaseModel {
  MoneyDenominationModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tcsr1Id,
    required super.coin50,
    required super.coin100,
    required super.coin200,
    required super.coin500,
    required super.coin1k,
    required super.paper1k,
    required super.paper2k,
    required super.paper5k,
    required super.paper10k,
    required super.paper20k,
    required super.paper50k,
    required super.paper100k,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'tcsr1Id': tcsr1Id,
      'coin50': coin50,
      'coin100': coin100,
      'coin200': coin200,
      'coin500': coin500,
      'coin1k': coin1k,
      'paper1k': paper1k,
      'paper2k': paper2k,
      'paper5k': paper5k,
      'paper10k': paper10k,
      'paper20k': paper20k,
      'paper50k': paper50k,
      'paper100k': paper100k,
    };
  }

  factory MoneyDenominationModel.fromMap(Map<String, dynamic> map) {
    return MoneyDenominationModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      tcsr1Id: map['tcsr1Id'] != null ? map['tcsr1Id'] as String : null,
      coin50: map['coin50'] != null ? map['coin50'] as int : null,
      coin100: map['coin100'] != null ? map['coin100'] as int : null,
      coin200: map['coin200'] != null ? map['coin200'] as int : null,
      coin500: map['coin500'] != null ? map['coin500'] as int : null,
      coin1k: map['coin1k'] != null ? map['coin1k'] as int : null,
      paper1k: map['paper1k'] != null ? map['paper1k'] as int : null,
      paper2k: map['paper2k'] != null ? map['paper2k'] as int : null,
      paper5k: map['paper5k'] != null ? map['paper5k'] as int : null,
      paper10k: map['paper10k'] != null ? map['paper10k'] as int : null,
      paper20k: map['paper20k'] != null ? map['paper20k'] as int : null,
      paper50k: map['paper50k'] != null ? map['paper50k'] as int : null,
      paper100k: map['paper100k'] != null ? map['paper100k'] as int : null,
    );
  }

  factory MoneyDenominationModel.fromEntity(MoneyDenominationEntity entity) {
    return MoneyDenominationModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tcsr1Id: entity.tcsr1Id,
      coin50: entity.coin50,
      coin100: entity.coin100,
      coin200: entity.coin200,
      coin500: entity.coin500,
      coin1k: entity.coin1k,
      paper1k: entity.paper1k,
      paper2k: entity.paper2k,
      paper5k: entity.paper5k,
      paper10k: entity.paper10k,
      paper20k: entity.paper20k,
      paper50k: entity.paper50k,
      paper100k: entity.paper100k,
    );
  }
}
