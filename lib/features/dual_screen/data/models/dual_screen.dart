import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/dual_screen/domain/entities/dual_screen.dart';

const String tableDualScreen = "tobnr";

class DualScreenFields {
  static const List<String> values = [
    id,
    description,
    type,
    order,
    path,
    duration,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';
  static const String description = 'description';
  static const String type = 'type';
  static const String order = 'order';
  static const String path = 'path';
  static const String duration = 'duration';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

class DualScreenModel extends DualScreenEntity implements BaseModel {
  DualScreenModel({
    required super.id,
    required super.description,
    required super.type,
    required super.order,
    required super.path,
    required super.duration,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DualScreenFields.id: id,
      DualScreenFields.description: description,
      DualScreenFields.type: type,
      DualScreenFields.order: order,
      DualScreenFields.path: path,
      DualScreenFields.duration: duration,
      DualScreenFields.createdAt: createdAt?.millisecondsSinceEpoch,
      DualScreenFields.updatedAt: updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory DualScreenModel.fromMap(Map<String, dynamic> map) {
    return DualScreenModel(
      id: map[DualScreenFields.id] as int,
      description: map[DualScreenFields.description] as String,
      type: map[DualScreenFields.type] as int,
      order: map[DualScreenFields.order] as int,
      path: map[DualScreenFields.path] as String,
      duration: (map[DualScreenFields.duration] as int),
      createdAt: map[DualScreenFields.createdAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[DualScreenFields.createdAt] as int)
          : null,
      updatedAt: map[DualScreenFields.updatedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[DualScreenFields.updatedAt] as int)
          : null,
    );
  }

  factory DualScreenModel.fromEntity(DualScreenEntity entity) {
    return DualScreenModel(
      id: entity.id,
      description: entity.description,
      type: entity.type,
      order: entity.order,
      path: entity.path,
      duration: entity.duration,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
