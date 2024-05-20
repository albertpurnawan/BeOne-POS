// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/promotion_detail.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_buy_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_get_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class CheckBuyXGetYApplicabilityUseCase
    implements
        UseCase<CheckBuyXGetYApplicabilityResult,
            CheckBuyXGetYApplicabilityParams> {
  CheckBuyXGetYApplicabilityUseCase();

  @override
  Future<CheckBuyXGetYApplicabilityResult> call(
      {CheckBuyXGetYApplicabilityParams? params}) async {
    try {
      if (params == null) throw "HandlePromosUseCase requires params";

      // Declare variables
      bool isApplicable = true;
      PromoBuyXGetYHeaderEntity? toprb;
      List<PromoBuyXGetYBuyConditionEntity> tprb1 = [];
      List<PromoBuyXGetYGetConditionEntity> tprb4 = [];
      final List<PromoBuyXGetYBuyConditionAndItemEntity> conditionAndItemXs =
          [];
      List<PromoBuyXGetYGetConditionAndItemEntity> conditionAndItemYs = [];
      List<String> itemXBarcodes = [];
      List<ReceiptItemEntity> existingReceiptItemXs = [];
      double qtySumOfExistingReceiptItemXs = 0;

      final List<Function> validations = [
        () async {
          // Get header and validate
          toprb = await GetIt.instance<AppDatabase>()
              .promoBuyXGetYHeaderDao
              .readByDocId(params.promo.promoId!, null);
          if (toprb == null) return isApplicable = false;
          if (params.receiptEntity.grandTotal < toprb!.minPurchase) {
            isApplicable = false;
          }
        },
        () async {
          // Check multiply
          final existingPromo = params.receiptEntity.promos
              .where((element) => element.promoId == params.promo.promoId);
          if (existingPromo.length > 1) return isApplicable = false;
          if (existingPromo.isNotEmpty) {
            if (existingPromo.first.promotionDetails == null) {
              return isApplicable = false;
            }
            final int applyCount =
                (existingPromo.first.promotionDetails as PromoBuyXGetYDetails)
                    .applyCount;
            if (applyCount > toprb!.maxMultiply) {
              return isApplicable = false;
            }
          }
        },
        () async {
          // Get X condition and validate
          tprb1 = await GetIt.instance<AppDatabase>()
              .promoBuyXGetYBuyConditionDao
              .readByToprbId(params.promo.promoId!, null);
          if (tprb1.isEmpty) isApplicable = false;

          for (final e in tprb1) {
            final ItemEntity? itemX = await GetIt.instance<AppDatabase>()
                .itemsDao
                .readByToitmId(e.toitmId!, null);
            if (itemX != null) {
              conditionAndItemXs.add(PromoBuyXGetYBuyConditionAndItemEntity(
                promoBuyXGetYBuyConditionEntity: e,
                itemEntity: itemX,
              ));
            }
          }
          if (conditionAndItemXs.isEmpty) isApplicable = false;
        },
        () async {
          // Get Y condition and validate
          tprb4 = await GetIt.instance<AppDatabase>()
              .promoBuyXGetYGetConditionDao
              .readByToprbId(params.promo.promoId!, null);
          if (tprb4.isEmpty) isApplicable = false;

          for (final e in tprb4) {
            final ItemEntity? itemY = await GetIt.instance<AppDatabase>()
                .itemsDao
                .readByToitmId(e.toitmId!, null);
            if (itemY != null) {
              conditionAndItemYs.add(PromoBuyXGetYGetConditionAndItemEntity(
                promoBuyXGetYGetConditionEntity: e,
                itemEntity: itemY,
              ));
            }
          }
          if (conditionAndItemYs.isEmpty) isApplicable = false;
        },
        () async {
          // Get existing item X from receipt and validate
          itemXBarcodes =
              conditionAndItemXs.map((e) => e.itemEntity.barcode).toList();
          existingReceiptItemXs = params.receiptEntity.receiptItems
              .where((e1) =>
                  itemXBarcodes.contains(e1.itemEntity.barcode) &&
                  e1.quantity >=
                      conditionAndItemXs
                          .firstWhere((e2) =>
                              e2.itemEntity.barcode == e1.itemEntity.barcode)
                          .promoBuyXGetYBuyConditionEntity
                          .quantity)
              .toList();
          if (toprb!.buyCondition == 1 &&
              existingReceiptItemXs.length != itemXBarcodes.length) {
            return isApplicable = false;
          }

          qtySumOfExistingReceiptItemXs = existingReceiptItemXs.isEmpty
              ? 0
              : existingReceiptItemXs
                  .map((e) => e.quantity)
                  .reduce((value, element) => value + element);
          if (qtySumOfExistingReceiptItemXs +
                  params.receiptItemEntity.quantity <
              toprb!.minBuy) {
            isApplicable = false;
          }
        },
      ];

      for (final validation in validations) {
        if (!isApplicable) {
          log("1");
          break;
        }
        await validation();
      }

      return CheckBuyXGetYApplicabilityResult(
        isApplicable: isApplicable,
        toprb: toprb,
        tprb1: tprb1,
        tprb4: tprb4,
        conditionAndItemXs: conditionAndItemXs,
        conditionAndItemYs: conditionAndItemYs,
        itemXBarcodes: itemXBarcodes,
        existingReceiptItemXs: existingReceiptItemXs,
        qtySumOfExistingReceiptItemXs: qtySumOfExistingReceiptItemXs,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class CheckBuyXGetYApplicabilityParams {
  ReceiptEntity receiptEntity;
  ReceiptItemEntity receiptItemEntity;
  PromotionsEntity promo;

  CheckBuyXGetYApplicabilityParams({
    required this.receiptEntity,
    required this.receiptItemEntity,
    required this.promo,
  });
}

class CheckBuyXGetYApplicabilityResult {
  final bool isApplicable;
  final PromoBuyXGetYHeaderEntity? toprb;
  final List<PromoBuyXGetYBuyConditionEntity> tprb1;
  final List<PromoBuyXGetYGetConditionEntity> tprb4;
  final List<PromoBuyXGetYBuyConditionAndItemEntity> conditionAndItemXs;
  final List<PromoBuyXGetYGetConditionAndItemEntity> conditionAndItemYs;
  final List<String> itemXBarcodes;
  final List<ReceiptItemEntity> existingReceiptItemXs;
  final double qtySumOfExistingReceiptItemXs;

  CheckBuyXGetYApplicabilityResult(
      {required this.isApplicable,
      required this.toprb,
      required this.tprb1,
      required this.tprb4,
      required this.conditionAndItemXs,
      required this.conditionAndItemYs,
      required this.itemXBarcodes,
      required this.existingReceiptItemXs,
      required this.qtySumOfExistingReceiptItemXs});
}

class PromoBuyXGetYBuyConditionAndItemEntity {
  final PromoBuyXGetYBuyConditionEntity promoBuyXGetYBuyConditionEntity;
  final ItemEntity itemEntity;

  PromoBuyXGetYBuyConditionAndItemEntity({
    required this.promoBuyXGetYBuyConditionEntity,
    required this.itemEntity,
  });

  PromoBuyXGetYBuyConditionAndItemEntity copyWith({
    PromoBuyXGetYBuyConditionEntity? promoBuyXGetYBuyConditionEntity,
    ItemEntity? itemEntity,
  }) {
    return PromoBuyXGetYBuyConditionAndItemEntity(
      promoBuyXGetYBuyConditionEntity: promoBuyXGetYBuyConditionEntity ??
          this.promoBuyXGetYBuyConditionEntity,
      itemEntity: itemEntity ?? this.itemEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promoBuyXGetYBuyConditionEntity':
          promoBuyXGetYBuyConditionEntity.toMap(),
      'itemEntity': itemEntity.toMap(),
    };
  }

  factory PromoBuyXGetYBuyConditionAndItemEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBuyXGetYBuyConditionAndItemEntity(
      promoBuyXGetYBuyConditionEntity: PromoBuyXGetYBuyConditionEntity.fromMap(
          map['promoBuyXGetYBuyConditionEntity'] as Map<String, dynamic>),
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYBuyConditionAndItemEntity.fromJson(String source) =>
      PromoBuyXGetYBuyConditionAndItemEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PromoBuyXGetYBuyConditionAndItemEntity(promoBuyXGetYBuyConditionEntity: $promoBuyXGetYBuyConditionEntity, itemEntity: $itemEntity)';

  @override
  bool operator ==(covariant PromoBuyXGetYBuyConditionAndItemEntity other) {
    if (identical(this, other)) return true;

    return other.promoBuyXGetYBuyConditionEntity ==
            promoBuyXGetYBuyConditionEntity &&
        other.itemEntity == itemEntity;
  }

  @override
  int get hashCode =>
      promoBuyXGetYBuyConditionEntity.hashCode ^ itemEntity.hashCode;
}

class PromoBuyXGetYGetConditionAndItemEntity {
  final PromoBuyXGetYGetConditionEntity promoBuyXGetYGetConditionEntity;
  final ItemEntity itemEntity;

  PromoBuyXGetYGetConditionAndItemEntity({
    required this.promoBuyXGetYGetConditionEntity,
    required this.itemEntity,
  });

  PromoBuyXGetYGetConditionAndItemEntity copyWith({
    PromoBuyXGetYGetConditionEntity? promoBuyXGetYGetConditionEntity,
    ItemEntity? itemEntity,
  }) {
    return PromoBuyXGetYGetConditionAndItemEntity(
      promoBuyXGetYGetConditionEntity: promoBuyXGetYGetConditionEntity ??
          this.promoBuyXGetYGetConditionEntity,
      itemEntity: itemEntity ?? this.itemEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promoBuyXGetYGetConditionEntity':
          promoBuyXGetYGetConditionEntity.toMap(),
      'itemEntity': itemEntity.toMap(),
    };
  }

  factory PromoBuyXGetYGetConditionAndItemEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBuyXGetYGetConditionAndItemEntity(
      promoBuyXGetYGetConditionEntity: PromoBuyXGetYGetConditionEntity.fromMap(
          map['promoBuyXGetYGetConditionEntity'] as Map<String, dynamic>),
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYGetConditionAndItemEntity.fromJson(String source) =>
      PromoBuyXGetYGetConditionAndItemEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PromoBuyXGetYGetConditionAndItemEntity(promoBuyXGetYGetConditionEntity: $promoBuyXGetYGetConditionEntity, itemEntity: $itemEntity)';

  @override
  bool operator ==(covariant PromoBuyXGetYGetConditionAndItemEntity other) {
    if (identical(this, other)) return true;

    return other.promoBuyXGetYGetConditionEntity ==
            promoBuyXGetYGetConditionEntity &&
        other.itemEntity == itemEntity;
  }

  @override
  int get hashCode =>
      promoBuyXGetYGetConditionEntity.hashCode ^ itemEntity.hashCode;
}
