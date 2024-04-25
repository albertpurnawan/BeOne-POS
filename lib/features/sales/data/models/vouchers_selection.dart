import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';

const String tableVouchersSelection = "tvcr9";

class VoucherSelectionFields {
  static const List<String> values = [
    tovcrId,
    voucherAlias,
    voucherAmount,
    validFrom,
    validTo,
    serialNo,
    voucherStatus,
    statusActive,
    redeemDate,
    tinv2Id,
  ];

  static const String tovcrId = "tovcrId";
  static const String voucherAlias = "voucheralias";
  static const String voucherAmount = "voucheramount";
  static const String validFrom = "validfrom";
  static const String validTo = "validto";
  static const String serialNo = "serialno";
  static const String voucherStatus = "voucherstatus";
  static const String statusActive = "statusactive";
  static const String redeemDate = "redeemdate";
  static const String tinv2Id = "tinv2Id";
}

class VouchersSelectionModel extends VouchersSelectionEntity
    implements BaseModel {
  VouchersSelectionModel({
    required super.tovcrId,
    required super.voucherAlias,
    required super.voucherAmount,
    required super.validFrom,
    required super.validTo,
    required super.serialNo,
    required super.voucherStatus,
    required super.statusActive,
    required super.redeemDate,
    required super.tinv2Id,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tovcrId': tovcrId,
      'voucheralias': voucherAlias,
      'voucheramount': voucherAmount,
      'validfrom': validFrom.toUtc().toIso8601String(),
      'validto': validTo.toUtc().toIso8601String(),
      'serialno': serialNo,
      'voucherstatus': voucherStatus,
      'statusactive': statusActive,
      'redeemdate': redeemDate?.toUtc().toIso8601String(),
      'tinv2Id': tinv2Id,
    };
  }

  factory VouchersSelectionModel.fromMap(Map<String, dynamic> map) {
    return VouchersSelectionModel(
      tovcrId: map['tovcrId'] as String,
      voucherAlias: map['voucheralias'] as String,
      voucherAmount: map['voucheramount'] as int,
      validFrom: DateTime.parse(map['validfrom'] as String).toLocal(),
      validTo: DateTime.parse(map['validto'] as String).toLocal(),
      serialNo: map['serialno'] as String,
      voucherStatus: map['voucherstatus'] as int,
      statusActive: map['atatusActive'] as int,
      redeemDate: map['redeemdate'] != null
          ? DateTime.parse(map['redeemdate'] as String).toLocal()
          : null,
      tinv2Id: map['tinv2Id'] != null ? map['tinv2Id'] as String : null,
    );
  }

  factory VouchersSelectionModel.fromMapRemote(Map<String, dynamic> map) {
    return VouchersSelectionModel.fromMap({
      ...map,
      "tovcrId": map['tovcr_id'] != null ? map['tovcr_id'] as String : null,
      "voucheralias": map['tovcr_id']['remarks'] != null
          ? map['tovcr_id']['remarks'] as String
          : null,
      "voucheramount": map['tovcr_id']['voucheramount'] != null
          ? map['tovcr_id']['voucheramount'] as double
          : null,
      "validfrom": map['tovcr_id']['validfrom'] != null
          ? DateTime.parse(map['tovcr_id']['validfrom'] as String).toLocal()
          : null,
      "validto": map['tovcr_id']['validto'] != null
          ? DateTime.parse(map['tovcr_id']['validto'] as String).toLocal()
          : null,
    });
  }

  factory VouchersSelectionModel.fromEntity(VouchersSelectionEntity entity) {
    return VouchersSelectionModel(
      tovcrId: entity.tovcrId,
      voucherAlias: entity.voucherAlias,
      voucherAmount: entity.voucherAmount,
      validFrom: entity.validFrom,
      validTo: entity.validTo,
      serialNo: entity.serialNo,
      voucherStatus: entity.voucherStatus,
      statusActive: entity.statusActive,
      redeemDate: entity.redeemDate,
      tinv2Id: entity.tinv2Id,
    );
  }
}
