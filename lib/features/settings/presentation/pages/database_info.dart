import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';

class DatabaseInfoDialog extends StatefulWidget {
  const DatabaseInfoDialog({super.key});

  @override
  State<DatabaseInfoDialog> createState() => _DatabaseInfoDialogState();
}

class _DatabaseInfoDialogState extends State<DatabaseInfoDialog> {
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool isLoading = true;

  String storeName = "";
  String cashRegisterId = "";
  int databaseVersion = -1;
  int compiledItems = -1;
  int itemMaster = -1;
  int assignedItemMaster = -1;
  int compiledPromotions = -1;
  int promoHargaSpesial = -1;
  int activePromoHargaSpesial = -1;
  int promoBuyXGetY = -1;
  int activePromoBuyXGetY = -1;
  int promoCoupon = -1;
  int activePromoCoupon = -1;
  int promoDiscountItemByItem = -1;
  int activePromoDiscountItemByItem = -1;
  int promoDiscountItemByGroup = -1;
  int activePromoDiscountItemByGroup = -1;

  @override
  void initState() {
    super.initState();
    _getDatabaseInfo();
  }

  @override
  void dispose() {
    _keyboardListenerFocusNode.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _getDatabaseInfo() async {
    try {
      setState(() {
        isLoading = true;
      });

      final AppDatabase _appDatabase = GetIt.instance<AppDatabase>();

      final POSParameterEntity? topos =
          await GetIt.instance<GetPosParameterUseCase>().call();
      if (topos == null) throw "POS Parameter not Found";
      final CashRegisterEntity? cashRegisterEntity = await _appDatabase
          .cashRegisterDao
          .readByDocId(topos.tocsrId ?? "", null);
      if (cashRegisterEntity == null) throw "Cash Register not Found";

      storeName = topos.storeName ?? "-";
      cashRegisterId = cashRegisterEntity.idKassa ?? "-";
      databaseVersion = _appDatabase.databaseVersion;
      compiledItems = await _appDatabase.itemsDao.getLength();
      itemMaster = await _appDatabase.itemMasterDao.getLength();
      assignedItemMaster = await _appDatabase.itemByStoreDao.getLength();
      compiledPromotions =
          await _appDatabase.promosDao.getLengthUniqueByType(null);
      promoHargaSpesial =
          await _appDatabase.promoHargaSpesialHeaderDao.getLength();
      activePromoHargaSpesial =
          await _appDatabase.promosDao.getLengthUniqueByType(202);
      promoBuyXGetY = await _appDatabase.promoBuyXGetYHeaderDao.getLength();
      activePromoBuyXGetY =
          await _appDatabase.promosDao.getLengthUniqueByType(103);
      promoCoupon = await _appDatabase.promoCouponHeaderDao.getLength();
      activePromoCoupon =
          await _appDatabase.promosDao.getLengthUniqueByType(107);
      promoDiscountItemByItem =
          await _appDatabase.promoDiskonItemHeaderDao.getLength();
      activePromoDiscountItemByItem =
          await _appDatabase.promosDao.getLengthUniqueByType(203);
      promoDiscountItemByGroup =
          await _appDatabase.promoDiskonGroupItemHeaderDao.getLength();
      activePromoDiscountItemByGroup =
          await _appDatabase.promosDao.getLengthUniqueByType(204);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
      context.pop();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildParameterRow(String key, dynamic value, {bool isBold = false}) {
    final String stringValue =
        value is int ? Helpers.parseMoney(value) : value.toString();

    return Row(
      children: [
        Text(
          key,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Spacer(),
        Text(
          stringValue,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: FocusScope(
              autofocus: true,
              skipTraversal: true,
              node: _focusScopeNode,
              onKeyEvent: (node, event) {
                if (event.runtimeType == KeyUpEvent)
                  return KeyEventResult.handled;
                if (event.physicalKey == PhysicalKeyboardKey.f12) {
                  context.pop();
                  return KeyEventResult.handled;
                } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
                  context.pop();
                  return KeyEventResult.handled;
                }

                return KeyEventResult.ignored;
              },
              child: AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                titlePadding: EdgeInsets.zero,
                title: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: ProjectColors.primary,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(5)),
                  ),
                  child: const Text(
                    "Database Info",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                content: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 237, 237),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildParameterRow("Store Name", storeName),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Cash Register ID", cashRegisterId),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Database Version", databaseVersion),
                                const SizedBox(height: 20),
                                _buildParameterRow(
                                    "Compiled Items", compiledItems,
                                    isBold: true),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Assigned Item Master", assignedItemMaster),
                                const SizedBox(height: 5),
                                _buildParameterRow("Item Master", itemMaster),
                                const SizedBox(height: 20),
                                _buildParameterRow(
                                    "Compiled Promotions", compiledPromotions,
                                    isBold: true),
                                const SizedBox(height: 5),
                                _buildParameterRow("Active Promo Harga Spesial",
                                    activePromoHargaSpesial),
                                const SizedBox(height: 5),
                                _buildParameterRow("Active Promo Buy X Get Y",
                                    activePromoBuyXGetY),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Active Promo Coupon", activePromoCoupon),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Active Promo Discount Item (Item)",
                                    activePromoDiscountItemByItem),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Active Promo Discount Item (Group)",
                                    activePromoDiscountItemByGroup),
                                const SizedBox(height: 20),
                                _buildParameterRow(
                                    "Promo Harga Spesial", promoHargaSpesial),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Promo Buy X Get Y", promoBuyXGetY),
                                const SizedBox(height: 5),
                                _buildParameterRow("Promo Coupon", promoCoupon),
                                const SizedBox(height: 5),
                                _buildParameterRow("Promo Discount Item (Item)",
                                    promoDiscountItemByItem),
                                const SizedBox(height: 5),
                                _buildParameterRow(
                                    "Promo Discount Item (Group)",
                                    promoDiscountItemByGroup),
                              ],
                            ),
                          ),
                        ),
                      ),
                contentPadding: const EdgeInsets.all(0),
                actionsPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProjectColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
        );
      }),
    );
  }
}
