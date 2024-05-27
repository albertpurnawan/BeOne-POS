import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/price_by_item.dart';

const String tablePricesByItem = "tpln2";

class PriceByItemFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tpln1Id,
    toitmId,
    tcurrId,
    price,
    // purchasePrice,
    // calculatedPrice,
    // marginPercentage,
    // marginValue,
    // costPrice,
    // afterRounding,
    // beforeRounding,
    // roundingDiff,
    form,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String tpln1Id = 'tpln1Id';
  static const String toitmId = 'toitmId';
  static const String tcurrId = 'tcurrId';
  static const String price = 'price';
  // static const String purchasePrice = 'purchaseprice';
  // static const String calculatedPrice = 'calculatedprice';
  // static const String marginPercentage = 'marginpercentage';
  // static const String marginValue = 'marginvalue';
  // static const String costPrice = 'costprice';
  // static const String afterRounding = 'afterrounding';
  // static const String beforeRounding = 'beforerounding';
  // static const String roundingDiff = 'roundingdiff';
  static const String form = 'form';
}

class PriceByItemModel extends PriceByItemEntity implements BaseModel {
  PriceByItemModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tpln1Id,
    required super.toitmId,
    required super.tcurrId,
    required super.price,
    // required super.purchasePrice,
    // required super.calculatedPrice,
    // required super.marginPercentage,
    // required super.marginValue,
    // required super.costPrice,
    // required super.afterRounding,
    // required super.beforeRounding,
    // required super.roundingDiff,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tpln1Id': tpln1Id,
      'toitmId': toitmId,
      'tcurrId': tcurrId,
      'price': price,
      // 'purchaseprice': purchasePrice,
      // 'calculatedprice': calculatedPrice,
      // 'marginpercentage': marginPercentage,
      // 'marginvalue': marginValue,
      // 'costprice': costPrice,
      // 'afterrounding': afterRounding,
      // 'beforerounding': beforeRounding,
      // 'roundingdiff': roundingDiff,
      'form': form,
    };
  }

  factory PriceByItemModel.fromMap(Map<String, dynamic> map) {
    return PriceByItemModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tpln1Id: map['tpln1Id'] != null ? map['tpln1Id'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
      // purchasePrice:
      //     map['purchaseprice'] != null ? map['purchaseprice'] as double : null,
      // calculatedPrice: map['calculatedprice'] != null
      //     ? map['calculatedprice'] as double
      //     : null,
      // marginPercentage: map['marginpercentage'] != null
      //     ? map['marginpercentage'] as double
      //     : null,
      // marginValue:
      //     map['marginvalue'] != null ? map['marginvalue'] as double : null,
      // costPrice: map['costprice'] != null ? map['costprice'] as double : null,
      // afterRounding:
      //     map['afterrounding'] != null ? map['afterrounding'] as double : null,
      // beforeRounding: map['beforerounding'] != null
      //     ? map['beforerounding'] as double
      //     : null,
      // roundingDiff:
      //     map['roundingdiff'] != null ? map['roundingdiff'] as double : null,
      form: map['form'] as String,
    );
  }

  factory PriceByItemModel.fromMapRemote(Map<String, dynamic> map) {
    return PriceByItemModel.fromMap({
      ...map,
      "tpln1Id": map['tpln1docid'] != null ? map['tpln1docid'] as String : null,
      "toitmId": map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
      "tcurrId": map['tcurrdocid'] != null ? map['tcurrdocid'] as String : null,
      "price": map['price'].toDouble() as double,
      // "purchaseprice": map['purchaseprice'] != null
      //     ? map['purchaseprice'].toDouble() as double
      //     : null,
      // "calculatedprice": map['calculatedprice'] != null
      //     ? map['calculatedprice'].toDouble() as double
      //     : null,
      // "marginpercentage": map['marginpercentage'] != null
      //     ? map['marginpercentage'].toDouble() as double
      //     : null,
      // "marginvalue": map['marginvalue'] != null
      //     ? map['marginvalue'].toDouble() as double
      //     : null,
      // "costprice": map['costprice'] != null
      //     ? map['costprice'].toDouble() as double
      //     : null,
      // "afterrounding": map['afterrounding'] != null
      //     ? map['afterrounding'].toDouble() as double
      //     : null,
      // "beforerounding": map['beforerounding'] != null
      //     ? map['beforerounding'].toDouble() as double
      //     : null,
      // "roundingdiff": map['roundingdiff'] != null
      //     ? map['roundingdiff'].toDouble() as double
      //     : null,
    });
  }

  factory PriceByItemModel.fromEntity(PriceByItemEntity entity) {
    return PriceByItemModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tpln1Id: entity.tpln1Id,
      toitmId: entity.toitmId,
      tcurrId: entity.tcurrId,
      price: entity.price,
      // purchasePrice: entity.purchasePrice,
      // calculatedPrice: entity.calculatedPrice,
      // marginPercentage: entity.marginPercentage,
      // marginValue: entity.marginValue,
      // costPrice: entity.costPrice,
      // afterRounding: entity.afterRounding,
      // beforeRounding: entity.beforeRounding,
      // roundingDiff: entity.roundingDiff,
      form: entity.form,
    );
  }
}
