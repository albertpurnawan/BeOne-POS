import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/sales/data/models/promotions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      body: Row(
        children: [
          Expanded(
              child: Image.asset(
            'assets/images/supermarket-illustration.png',
            height: double.infinity,
            fit: BoxFit.cover,
          )),
          Expanded(
              child: Container(
            color: Color.fromRGBO(128, 0, 0, 1),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.36,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Good Afternoon ",
                                ),
                                TextSpan(
                                    text: GetIt.instance<SharedPreferences>()
                                        .getString("username"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                TextSpan(
                                  text: " ☀️",
                                )
                              ],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Have a Great Day!",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStatePropertyAll(2),
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () async {
                            // await GetIt.instance<AppDatabase>()
                            //     .refreshItemsTable();
                            await GetIt.instance<AppDatabase>()
                                .promosDao
                                .deletePromos();

                            final promos = <PromotionsModel>[];
                            final today = DateTime.now().weekday;

                            final topsb = await GetIt.instance<AppDatabase>()
                                .promoHargaSpesialHeaderDao
                                .readAll();

                            for (final header in topsb) {
                              final tpsb2 = await GetIt.instance<AppDatabase>()
                                  .promoHargaSpesialAssignStoreDao
                                  .readByTopsbId(header.docId, null);
                              final tpsb4 = await GetIt.instance<AppDatabase>()
                                  .promoHargaSpesialCustomerGroupDao
                                  .readByTopsbId(header.docId, null);

                              final dayProperties = {
                                1: tpsb2.day1,
                                2: tpsb2.day2,
                                3: tpsb2.day3,
                                4: tpsb2.day4,
                                5: tpsb2.day5,
                                6: tpsb2.day6,
                                7: tpsb2.day7,
                              };

                              final isValid = dayProperties[today] == 1;

                              if (isValid) {
                                for (final customerGroup in tpsb4) {
                                  promos.add(PromotionsModel(
                                    docId: const Uuid().v4(),
                                    toitmId: header.toitmId,
                                    promoType: 202,
                                    promoId: header.docId,
                                    date: DateTime.now(),
                                    startTime: header.startTime,
                                    endTime: header.endTime,
                                    tocrgId: customerGroup.tocrgId,
                                    promoDescription: header.description,
                                    tocatId: null,
                                    remarks: null,
                                  ));
                                }
                              }
                            }

                            final topmi = await GetIt.instance<AppDatabase>()
                                .promoMultiItemHeaderDao
                                .readAll();

                            for (final header in topmi) {
                              final tpmi1 = await GetIt.instance<AppDatabase>()
                                  .promoMultiItemBuyConditionDao
                                  .readByTopmiId(header.docId, null);
                              final tpmi2 = await GetIt.instance<AppDatabase>()
                                  .promoMultiItemAssignStoreDao
                                  .readByTopmiId(header.docId, null);
                              final tpmi5 = await GetIt.instance<AppDatabase>()
                                  .promoMultiItemCustomerGroupDao
                                  .readByTopmiId(header.docId, null);

                              final dayProperties = {
                                1: tpmi2.day1,
                                2: tpmi2.day2,
                                3: tpmi2.day3,
                                4: tpmi2.day4,
                                5: tpmi2.day5,
                                6: tpmi2.day6,
                                7: tpmi2.day7,
                              };

                              final isValid = dayProperties[today] == 1;
                              if (isValid) {
                                for (final buyCondition in tpmi1) {
                                  for (final customerGroup in tpmi5) {
                                    promos.add(PromotionsModel(
                                      docId: const Uuid().v4(),
                                      toitmId: buyCondition.toitmId,
                                      promoType: 206,
                                      promoId: header.docId,
                                      date: DateTime.now(),
                                      startTime: header.startTime,
                                      endTime: header.endTime,
                                      tocrgId: customerGroup.tocrgId,
                                      promoDescription: header.description,
                                      tocatId: null,
                                      remarks: null,
                                    ));
                                  }
                                }
                              }
                            }

                            final topdi = await GetIt.instance<AppDatabase>()
                                .promoDiskonItemHeaderDao
                                .readAll();

                            for (final header in topdi) {
                              final tpdi1 = await GetIt.instance<AppDatabase>()
                                  .promoDiskonItemBuyConditionDao
                                  .readByTopdiId(header.docId, null);
                              final tpdi2 = await GetIt.instance<AppDatabase>()
                                  .promoDiskonItemAssignStoreDao
                                  .readByTopdiId(header.docId, null);
                              final tpdi5 = await GetIt.instance<AppDatabase>()
                                  .promoDiskonItemCustomerGroupDao
                                  .readByTopdiId(header.docId, null);

                              final dayProperties = {
                                1: tpdi2.day1,
                                2: tpdi2.day2,
                                3: tpdi2.day3,
                                4: tpdi2.day4,
                                5: tpdi2.day5,
                                6: tpdi2.day6,
                                7: tpdi2.day7,
                              };

                              final isValid = dayProperties[today] == 1;
                              if (isValid) {
                                for (final buyCondition in tpdi1) {
                                  for (final customerGroup in tpdi5) {
                                    promos.add(PromotionsModel(
                                      docId: const Uuid().v4(),
                                      toitmId: buyCondition.toitmId,
                                      promoType: 203,
                                      promoId: header.docId,
                                      date: DateTime.now(),
                                      startTime: header.startTime,
                                      endTime: header.endTime,
                                      tocrgId: customerGroup.tocrgId,
                                      promoDescription: header.description,
                                      tocatId: null,
                                      remarks: null,
                                    ));
                                  }
                                }
                              }
                            }

                            final topdg = await GetIt.instance<AppDatabase>()
                                .promoDiskonGroupItemHeaderDao
                                .readAll();
                            for (final header in topdg) {
                              final tpdg1 = await GetIt.instance<AppDatabase>()
                                  .promoDiskonGroupItemBuyConditionDao
                                  .readByTopdgId(header.docId, null);
                              final tpdg2 = await GetIt.instance<AppDatabase>()
                                  .promoDiskonGroupItemAssignStoreDao
                                  .readByTodgId(header.docId, null);
                              final tpdg5 = await GetIt.instance<AppDatabase>()
                                  .promoDiskonGroupItemCustomerGroupDao
                                  .readByTopdgId(header.docId, null);

                              final dayProperties = {
                                1: tpdg2.day1,
                                2: tpdg2.day2,
                                3: tpdg2.day3,
                                4: tpdg2.day4,
                                5: tpdg2.day5,
                                6: tpdg2.day6,
                                7: tpdg2.day7,
                              };

                              final isValid = dayProperties[today] == 1;
                              if (isValid) {
                                for (final buyCondition in tpdg1) {
                                  for (final customerGroup in tpdg5) {
                                    promos.add(PromotionsModel(
                                      docId: const Uuid().v4(),
                                      toitmId: null,
                                      promoType: 204,
                                      promoId: header.docId,
                                      date: DateTime.now(),
                                      startTime: header.startTime,
                                      endTime: header.endTime,
                                      tocrgId: customerGroup.tocrgId,
                                      promoDescription: header.description,
                                      tocatId: buyCondition.tocatId,
                                      remarks: null,
                                    ));
                                  }
                                }
                              }
                            }

                            final toprb = await GetIt.instance<AppDatabase>()
                                .promoBuyXGetYHeaderDao
                                .readAll();

                            for (final header in toprb) {
                              final tprb1 = await GetIt.instance<AppDatabase>()
                                  .promoBuyXGetYBuyConditionDao
                                  .readByToprbId(header.docId, null);
                              final tprb2 = await GetIt.instance<AppDatabase>()
                                  .promoBuyXGetYAssignStoreDao
                                  .readByToprbId(header.docId, null);
                              // final tprb5 = await GetIt.instance<AppDatabase>()
                              //     .promoBuyXGetYCustomerGroupDao
                              //     .readByToprbid(header.docId, null);

                              final dayProperties = {
                                1: tprb2.day1,
                                2: tprb2.day2,
                                3: tprb2.day3,
                                4: tprb2.day4,
                                5: tprb2.day5,
                                6: tprb2.day6,
                                7: tprb2.day7,
                              };

                              final isValid = dayProperties[today] == 1;
                              if (isValid) {
                                for (final buyCondition in tprb1) {
                                  // for (final customerGroup in tprb5) {
                                  promos.add(PromotionsModel(
                                    docId: const Uuid().v4(),
                                    toitmId: buyCondition.toitmId,
                                    promoType: 103,
                                    promoId: header.docId,
                                    date: DateTime.now(),
                                    startTime: header.startTime,
                                    endTime: header.endTime,
                                    tocrgId: null,
                                    promoDescription: header.description,
                                    tocatId: null,
                                    remarks: null,
                                  ));
                                  // }
                                }
                              }
                            }

                            await GetIt.instance<AppDatabase>()
                                .promosDao
                                .bulkCreate(data: promos);
                            log("PROMOS INSERTED");

                            context.pushNamed(RouteConstants.sales);
                          },
                          child: const Text(
                            "Sales",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () =>
                              context.pushNamed(RouteConstants.shifts),
                          child: const Text(
                            "Shifts",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () {},
                          child: const Text(
                            "Reports",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () {
                            context
                                .pushNamed(RouteConstants.settings)
                                .then((value) {
                              if (!Platform.isWindows) {
                                Future.delayed(Durations.short1, () {
                                  SystemChrome.setSystemUIOverlayStyle(
                                      const SystemUiOverlayStyle(
                                          statusBarColor:
                                              Color.fromARGB(255, 134, 1, 1),
                                          statusBarBrightness: Brightness.light,
                                          statusBarIconBrightness:
                                              Brightness.light));
                                });
                              }
                            });
                          },
                          child: const Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 20)),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              )),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 255, 255, 255)),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () {
                            context.goNamed(RouteConstants.welcome);
                            GetIt.instance<LogoutUseCase>().call();
                          },
                          child: const Text(
                            "Logout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      // SizedBox.expand(),
                    ],
                  ),
                  Expanded(
                    // height: double.infinity,

                    // width: double.infinity,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          alignment: Alignment.centerRight,
                          height: 50,
                          width: 130,
                          padding: const EdgeInsets.fromLTRB(10, 16, 0, 15),
                          decoration: const BoxDecoration(
                            color: const Color.fromARGB(255, 85, 0, 0),
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(5),
                              topLeft: Radius.circular(60),
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/logo/white_only_pos.svg",
                            // alignment: Alignment.centerLeft,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
