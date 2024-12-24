// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DualScreenEntity {
  final int id;
  final String description;
  final int type;
  final int order;
  final String path;
  final int duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DualScreenEntity({
    required this.id,
    required this.description,
    required this.type,
    required this.order,
    required this.path,
    required this.duration,
    this.createdAt,
    this.updatedAt,
  });

  DualScreenEntity copyWith({
    int? id,
    String? description,
    int? type,
    int? order,
    String? path,
    int? duration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DualScreenEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      type: type ?? this.type,
      order: order ?? this.order,
      path: path ?? this.path,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'type': type,
      'order': order,
      'path': path,
      'duration': duration,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory DualScreenEntity.fromMap(Map<String, dynamic> map) {
    return DualScreenEntity(
      id: map['id'] as int,
      description: map['description'] as String,
      type: map['type'] as int,
      order: map['order'] as int,
      path: map['path'] as String,
      duration: map['duration'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DualScreenEntity.fromJson(String source) =>
      DualScreenEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DualScreenEntity(id: $id, description: $description, type: $type, order: $order, path: $path, duration: $duration, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DualScreenEntity &&
        other.id == id &&
        other.description == description &&
        other.type == type &&
        other.order == order &&
        other.path == path &&
        other.duration == duration &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        type.hashCode ^
        order.hashCode ^
        path.hashCode ^
        duration.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
