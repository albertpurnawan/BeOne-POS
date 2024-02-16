import 'package:pos_fe/features/sales/domain/entities/item.dart';

const String tableItems = 'moitm';

class ItemFields {
  static const List<String> values = [
    id,
    code,
    name,
    price,
  ];

  static const String id = "_id";
  static const String code = "code";
  static const String name = "name";
  static const String price = "price";
}

class ItemModel extends ItemEntity {
  const ItemModel({String? code, String? name, int? price, int? id})
      : super(id: id, code: code, name: name, price: price);

  factory ItemModel.fromJson(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? "",
      code: map['code'] ?? "",
      name: map['name'] ?? "",
      price: map['price'] ?? 0,
    );
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['_id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
    );
  }

  factory ItemModel.fromEntity(ItemEntity entity) {
    return ItemModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      price: entity.price,
    );
  }
}
