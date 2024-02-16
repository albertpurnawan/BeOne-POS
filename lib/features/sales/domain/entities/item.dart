// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemEntity {
  final int? id;
  final String? code;
  final String? name;
  final int? price;

  const ItemEntity({
    this.id,
    this.code,
    this.name,
    this.price,
  });

  ItemEntity copyWith({
    int? id,
    String? code,
    String? name,
    int? price,
  }) {
    return ItemEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'price': price,
    };
  }

  factory ItemEntity.fromMap(Map<String, dynamic> map) {
    return ItemEntity(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemEntity.fromJson(String source) =>
      ItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemEntity(id: $id, code: $code, name: $name, price: $price)';
  }

  @override
  bool operator ==(covariant ItemEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ code.hashCode ^ name.hashCode ^ price.hashCode;
  }
}
