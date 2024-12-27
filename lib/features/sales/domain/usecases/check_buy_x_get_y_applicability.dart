// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/promotion_detail.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_buy_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_get_condition.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';

class CheckBuyXGetYApplicabilityUseCase
    implements UseCase<CheckBuyXGetYApplicabilityResult, CheckBuyXGetYApplicabilityParams> {
  CheckBuyXGetYApplicabilityUseCase();

  @override
  Future<CheckBuyXGetYApplicabilityResult> call({CheckBuyXGetYApplicabilityParams? params}) async {
    try {
      if (params == null) throw "HandlePromosUseCase requires params";

      // Declare variables
      bool isApplicable = true;
      PromoBuyXGetYHeaderEntity? toprb;
      List<PromoBuyXGetYBuyConditionEntity> tprb1 = [];
      List<PromoBuyXGetYGetConditionEntity> tprb4 = [];
      final List<PromoBuyXGetYBuyConditionAndItemEntity> conditionAndItemXs = [];
      List<PromoBuyXGetYGetConditionAndItemEntity> conditionAndItemYs = [];
      List<String> itemXBarcodes = [];
      List<ReceiptItemEntity> existingReceiptItemXs = [];
      double qtySumOfExistingReceiptItemXs = 0;
      int availableApplyCount = 0;

      final List<Function> validations = [
        () async {
          try {
            // Get header and validate
            log("Get header and validate");
            toprb = await GetIt.instance<AppDatabase>().promoBuyXGetYHeaderDao.readByDocId(params.promo.promoId!, null);
            log("toprb $toprb");

            if (toprb == null) return isApplicable = false;
            if (params.receiptEntity.grandTotal < toprb!.minPurchase) {
              isApplicable = false;
            }

            // Check header: waktu, amount vs %
            final DateTime now = DateTime.now();
            final DateTime startPromo = DateTime(
              now.year,
              now.month,
              now.day,
              toprb!.startTime.hour,
              toprb!.startTime.minute,
              toprb!.startTime.second,
            );
            final DateTime endPromo = DateTime(
              now.year,
              now.month,
              now.day,
              toprb!.endTime.hour,
              toprb!.endTime.minute,
              toprb!.endTime.second,
            );

            log("${toprb!.startDate} ${toprb!.endDate}");
            log("${toprb!.endDate.hour}, ${toprb!.endDate.minute}, ${toprb!.endDate.second},");
            log("waktu $startPromo $endPromo");

            if (now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch ||
                now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch) {
              log("efefefeefqqw ${now.millisecondsSinceEpoch < startPromo.millisecondsSinceEpoch}");
              log("knienifn ${now.millisecondsSinceEpoch > endPromo.millisecondsSinceEpoch}");
              log("now ${now.millisecondsSinceEpoch}");
              log("endPromo ${endPromo.millisecondsSinceEpoch}");
              return isApplicable = false;
            }
          } catch (e) {
            rethrow;
          }
        },
        () async {
          try {
            // Check multiply
            log("Check multiply");

            final existingPromo =
                params.receiptEntity.promos.where((element) => element.promoId == params.promo.promoId);
            if (existingPromo.isNotEmpty) return isApplicable = false;

            if (existingPromo.length > 1) return isApplicable = false;
            if (existingPromo.isNotEmpty) {
              if (existingPromo.first.promotionDetails == null) {
                return isApplicable = false;
              }
              final int applyCount = (existingPromo.first.promotionDetails as PromoBuyXGetYDetails).applyCount;
              if (applyCount > toprb!.maxMultiply) {
                return isApplicable = false;
              }

              // log("$applyCount apply");
            }

            // log("Check multiply");
            // log(existingPromo.length.toString());
          } catch (e) {
            rethrow;
          }
        },
        () async {
          try {
            // Get X condition and validate
            log("Get X condition and validate");
            tprb1 = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYBuyConditionDao
                .readByToprbId(params.promo.promoId!, null);
            if (tprb1.isEmpty) isApplicable = false;

            final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
            if (posParameterEntity?.tostrId == null) throw "Invalid POS Parameter";
            final StoreMasterEntity? storeMasterEntity =
                await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity!.tostrId!);
            if (storeMasterEntity == null) throw "Store master not found";

            for (final e in tprb1) {
              ItemEntity? itemX;
              if (params.receiptEntity.customerEntity?.toplnId != null) {
                itemX = await GetIt.instance<AppDatabase>().itemsDao.readItemWithAndCondition({
                  ItemFields.toitmId: e.toitmId!,
                  ItemFields.toplnId: params.receiptEntity.customerEntity!.toplnId,
                }, null);
              }

              itemX ??= await GetIt.instance<AppDatabase>().itemsDao.readItemWithAndCondition(
                  {ItemFields.toitmId: e.toitmId!, ItemFields.toplnId: storeMasterEntity.toplnId}, null);

              if (itemX != null) {
                conditionAndItemXs.add(PromoBuyXGetYBuyConditionAndItemEntity(
                  promoBuyXGetYBuyConditionEntity: e,
                  itemEntity: itemX,
                ));
              }
            }
            if (conditionAndItemXs.isEmpty) isApplicable = false;
          } catch (e) {
            rethrow;
          }
        },
        () async {
          try {
            // Get Y condition and validate
            log("Get Y condition and validate");

            tprb4 = await GetIt.instance<AppDatabase>()
                .promoBuyXGetYGetConditionDao
                .readByToprbId(params.promo.promoId!, null);
            if (tprb4.isEmpty) isApplicable = false;

            final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
            if (posParameterEntity?.tostrId == null) throw "Invalid POS Parameter";
            final StoreMasterEntity? storeMasterEntity =
                await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity!.tostrId!);
            if (storeMasterEntity == null) throw "Store master not found";

            for (final e in tprb4) {
              if (params.returnItems.where((e1) => e1.itemEntity.toitmId == e.toitmId).isNotEmpty) {
                return isApplicable = false;
              }
              if (e.quantity < 1) return isApplicable = false;
              ItemEntity? itemY;

              if (params.receiptEntity.customerEntity?.toplnId != null) {
                itemY = await GetIt.instance<AppDatabase>().itemsDao.readItemWithAndCondition({
                  ItemFields.toitmId: e.toitmId!,
                  ItemFields.toplnId: params.receiptEntity.customerEntity?.toplnId,
                }, null);
              }

              itemY ??= await GetIt.instance<AppDatabase>().itemsDao.readItemWithAndCondition({
                ItemFields.toitmId: e.toitmId!,
                ItemFields.toplnId: storeMasterEntity.toplnId,
              }, null);

              if (itemY != null) {
                conditionAndItemYs.add(PromoBuyXGetYGetConditionAndItemEntity(
                  promoBuyXGetYGetConditionEntity: e,
                  itemEntity: itemY,
                  multiply: 0,
                ));
              }
            }
            if (conditionAndItemYs.isEmpty) isApplicable = false;
          } catch (e) {
            rethrow;
          }
        },
        () async {
          try {
            // Get existing item X from receipt and validate
            log("Get existing item X from receipt and validate");

            itemXBarcodes = conditionAndItemXs.map((e) => e.itemEntity.barcode).toList();
            existingReceiptItemXs = params.receiptEntity.receiptItems
                .where((e1) =>
                    itemXBarcodes.contains(e1.itemEntity.barcode) &&
                    e1.quantity >=
                        conditionAndItemXs
                            .firstWhere((e2) => e2.itemEntity.barcode == e1.itemEntity.barcode)
                            .promoBuyXGetYBuyConditionEntity
                            .quantity)
                .toList();
            if (toprb!.buyCondition == 1 && existingReceiptItemXs.length != itemXBarcodes.length) {
              return isApplicable = false;
            }

            qtySumOfExistingReceiptItemXs = existingReceiptItemXs.isEmpty
                ? 0
                : existingReceiptItemXs.map((e) => e.quantity).reduce((value, element) => value + element);
            if (qtySumOfExistingReceiptItemXs < toprb!.minBuy) {
              isApplicable = false;
            }
          } catch (e) {
            rethrow;
          }
        },
        () async {
          try {
            // Find available apply count
            log("Find available apply count");
            final List<ReceiptItemEntity> existingReceiptItemXsCopy =
                existingReceiptItemXs.map((e) => e.copyWith()).toList();

            if (toprb!.buyCondition == 1) {
              bool isAvailable = true;
              while (isAvailable) {
                for (final existingReceiptItemXCopy in existingReceiptItemXsCopy) {
                  final double conditionQty = conditionAndItemXs
                      .firstWhere(
                          (element) => element.itemEntity.barcode == existingReceiptItemXCopy.itemEntity.barcode)
                      .promoBuyXGetYBuyConditionEntity
                      .quantity;
                  if (conditionQty > existingReceiptItemXCopy.quantity) {
                    isAvailable = false;
                    break;
                  }
                  existingReceiptItemXCopy.quantity -= conditionQty;
                }
                if (!isAvailable) break;
                availableApplyCount += 1;
              }
            } else {
              while (true) {
                List<bool> availability = List<bool>.generate(existingReceiptItemXsCopy.length, (index) => true);
                for (int i = 0; i < existingReceiptItemXsCopy.length; i++) {
                  final ReceiptItemEntity existingReceiptItemXCopy = existingReceiptItemXsCopy[i];
                  double conditionQty = conditionAndItemXs
                      .firstWhere(
                          (element) => element.itemEntity.barcode == existingReceiptItemXCopy.itemEntity.barcode)
                      .promoBuyXGetYBuyConditionEntity
                      .quantity;
                  if (conditionQty == 0) conditionQty = 1;
                  if (conditionQty > existingReceiptItemXCopy.quantity) {
                    availability[i] = false;
                    continue;
                  }
                  existingReceiptItemXCopy.quantity -= conditionQty;
                  availableApplyCount += 1;
                }
                if (availability.every((element) => element == false)) break;
              }
            }

            availableApplyCount =
                toprb!.maxMultiply < availableApplyCount ? toprb!.maxMultiply.toInt() : availableApplyCount;
            // log("AVAILABLE APPLY COUNT $availableApplyCount");
          } catch (e) {
            rethrow;
          }
        }
      ];

      for (final validation in validations) {
        if (!isApplicable) {
          break;
        }
        try {
          await validation();
        } catch (e) {
          log(e.toString());
          isApplicable = false;
        }
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
        availableApplyCount: availableApplyCount,
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
  List<ReceiptItemEntity> returnItems;

  CheckBuyXGetYApplicabilityParams({
    required this.receiptEntity,
    required this.receiptItemEntity,
    required this.promo,
    required this.returnItems,
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
  final int availableApplyCount;

  CheckBuyXGetYApplicabilityResult({
    required this.isApplicable,
    required this.toprb,
    required this.tprb1,
    required this.tprb4,
    required this.conditionAndItemXs,
    required this.conditionAndItemYs,
    required this.itemXBarcodes,
    required this.existingReceiptItemXs,
    required this.qtySumOfExistingReceiptItemXs,
    required this.availableApplyCount,
  });
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
      promoBuyXGetYBuyConditionEntity: promoBuyXGetYBuyConditionEntity ?? this.promoBuyXGetYBuyConditionEntity,
      itemEntity: itemEntity ?? this.itemEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promoBuyXGetYBuyConditionEntity': promoBuyXGetYBuyConditionEntity.toMap(),
      'itemEntity': itemEntity.toMap(),
    };
  }

  factory PromoBuyXGetYBuyConditionAndItemEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYBuyConditionAndItemEntity(
      promoBuyXGetYBuyConditionEntity:
          PromoBuyXGetYBuyConditionEntity.fromMap(map['promoBuyXGetYBuyConditionEntity'] as Map<String, dynamic>),
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYBuyConditionAndItemEntity.fromJson(String source) =>
      PromoBuyXGetYBuyConditionAndItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PromoBuyXGetYBuyConditionAndItemEntity(promoBuyXGetYBuyConditionEntity: $promoBuyXGetYBuyConditionEntity, itemEntity: $itemEntity)';

  @override
  bool operator ==(covariant PromoBuyXGetYBuyConditionAndItemEntity other) {
    if (identical(this, other)) return true;

    return other.promoBuyXGetYBuyConditionEntity == promoBuyXGetYBuyConditionEntity && other.itemEntity == itemEntity;
  }

  @override
  int get hashCode => promoBuyXGetYBuyConditionEntity.hashCode ^ itemEntity.hashCode;
}

class PromoBuyXGetYGetConditionAndItemEntity {
  final PromoBuyXGetYGetConditionEntity promoBuyXGetYGetConditionEntity;
  final ItemEntity itemEntity;
  int multiply;

  PromoBuyXGetYGetConditionAndItemEntity({
    required this.promoBuyXGetYGetConditionEntity,
    required this.itemEntity,
    required this.multiply,
  });

  PromoBuyXGetYGetConditionAndItemEntity copyWith({
    PromoBuyXGetYGetConditionEntity? promoBuyXGetYGetConditionEntity,
    ItemEntity? itemEntity,
    int? multiply,
  }) {
    return PromoBuyXGetYGetConditionAndItemEntity(
      promoBuyXGetYGetConditionEntity: promoBuyXGetYGetConditionEntity ?? this.promoBuyXGetYGetConditionEntity,
      itemEntity: itemEntity ?? this.itemEntity,
      multiply: multiply ?? this.multiply,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'promoBuyXGetYGetConditionEntity': promoBuyXGetYGetConditionEntity.toMap(),
      'itemEntity': itemEntity.toMap(),
      'multiply': multiply,
    };
  }

  factory PromoBuyXGetYGetConditionAndItemEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYGetConditionAndItemEntity(
      promoBuyXGetYGetConditionEntity:
          PromoBuyXGetYGetConditionEntity.fromMap(map['promoBuyXGetYGetConditionEntity'] as Map<String, dynamic>),
      itemEntity: ItemEntity.fromMap(map['itemEntity'] as Map<String, dynamic>),
      multiply: map['multiply'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYGetConditionAndItemEntity.fromJson(String source) =>
      PromoBuyXGetYGetConditionAndItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PromoBuyXGetYGetConditionAndItemEntity(promoBuyXGetYGetConditionEntity: $promoBuyXGetYGetConditionEntity, itemEntity: $itemEntity, multiply: $multiply)';

  @override
  bool operator ==(covariant PromoBuyXGetYGetConditionAndItemEntity other) {
    if (identical(this, other)) return true;

    return other.promoBuyXGetYGetConditionEntity == promoBuyXGetYGetConditionEntity &&
        other.itemEntity == itemEntity &&
        other.multiply == multiply;
  }

  @override
  int get hashCode => promoBuyXGetYGetConditionEntity.hashCode ^ itemEntity.hashCode ^ multiply.hashCode;
}
