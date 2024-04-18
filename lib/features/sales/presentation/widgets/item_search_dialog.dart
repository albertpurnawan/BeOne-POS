import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/open_price_dialog.dart';

class ItemSearchDialog extends StatefulWidget {
  const ItemSearchDialog({super.key});

  @override
  State<ItemSearchDialog> createState() => _ItemSearchDialogState();
}

class _ItemSearchDialogState extends State<ItemSearchDialog> {
  late final FocusNode _searchInputFocusNode = FocusNode();
  List<ItemEntity> itemEntities = [];
  ItemEntity? radioValue;
  ItemEntity? selectedItem;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _searchInputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: const Text(
          'Item Search',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: EdgeInsets.all(0),
      content: Theme(
        data: ThemeData(
          splashColor: const Color.fromARGB(40, 169, 0, 0),
          highlightColor: const Color.fromARGB(40, 169, 0, 0),
          colorScheme: ColorScheme.fromSeed(seedColor: ProjectColors.primary),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                height: 15,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    print(value);
                    context.read<ItemsCubit>().getItems(searchKeyword: value);
                    _searchInputFocusNode.unfocus();

                    Future.delayed(const Duration(milliseconds: 300))
                        .then((value) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn);
                      });
                    });
                  },
                  autofocus: true,
                  focusNode: _searchInputFocusNode,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      size: 16,
                    ),
                    hintText: "Enter item name, code, or barcode",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    // isCollapsed: true,
                    // contentPadding:
                    //     EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Text(
              //   "Name",
              //   textAlign: TextAlign.left,
              // ),
              Expanded(
                child: BlocBuilder<ItemsCubit, List<ItemEntity>>(
                  builder: (context, state) {
                    if (state.isEmpty) {
                      return const Expanded(
                          child: EmptyList(
                        imagePath: "assets/images/empty-search.svg",
                        sentence:
                            "Tadaa.. There is nothing here!\nEnter any keyword to search.",
                      ));
                    }
                    return Scrollbar(
                      controller: _scrollController,
                      thickness: 4,
                      radius: Radius.circular(30),
                      thumbVisibility: true,
                      child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          itemCount: state.length,
                          itemBuilder: ((context, index) {
                            final ItemEntity itemEntity = state[index];

                            return Column(
                              children: [
                                RadioListTile<ItemEntity>(
                                    // tileColor: index % 2 == 0
                                    //     ? Color.fromARGB(255, 253, 234, 234)
                                    //     : null,
                                    activeColor: ProjectColors.primary,
                                    hoverColor: ProjectColors.primary,
                                    // selected: index == radioValue,
                                    selectedTileColor: ProjectColors.primary,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: state[index],
                                    groupValue: radioValue,
                                    title: Text(itemEntity.itemName),
                                    subtitle: SizedBox(
                                      height: 25,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/inventory.svg",
                                            height: 18,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            itemEntity.itemCode,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SvgPicture.asset(
                                            "assets/images/barcode.svg",
                                            height: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            itemEntity.barcode,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.sell_outlined,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Rp " +
                                                Helpers.parseMoney(
                                                    itemEntity.dpp.toInt()),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius:
                                    //         BorderRadius.circular(5)),
                                    onChanged: (val) {
                                      setState(() {
                                        radioValue = val;
                                      });
                                    }),
                                Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Color.fromARGB(100, 118, 118, 118),
                                ),
                              ],
                            );
                          })),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 20, vertical: 5),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.black.withOpacity(.2))),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  // Future.delayed(const Duration(milliseconds: 200),
                  //     () => _newReceiptItemCodeFocusNode.requestFocus());
                });
              },
              child: const Center(
                  child: Text(
                "Cancel",
                style: TextStyle(color: ProjectColors.primary),
              )),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => ProjectColors.primary),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white.withOpacity(.2))),
              onPressed: () {
                if (radioValue == null) return;

                if (radioValue!.openPrice == 1) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => OpenPriceDialog(
                            itemEntity: radioValue!,
                            quantity: 1,
                          )).then((value) => Navigator.of(context).pop());
                } else {
                  setState(() {
                    context
                        .read<ReceiptCubit>()
                        .addOrUpdateReceiptItemsBySearch(radioValue!);
                    Navigator.of(context).pop();
                    // Future.delayed(const Duration(milliseconds: 200),
                    //     () => _newReceiptItemCodeFocusNode.requestFocus());
                  });
                }
                // try {
                //   final response = await api.trading
                //       .deleteTradingPost(tradingPost.id)
                //       .timeout(const Duration(seconds: 10));
                //   if (response.response.success) {
                //     Helpers.showSnackbar(context,
                //         content:
                //             const Text("Delete success"));
                //   } else {
                //     Helpers.showSnackbar(context,
                //         content: const Text("Delete failed"));
                //   }
                //   Navigator.of(context).pop();
                //   refresh();
                // } catch (e) {
                //   Navigator.of(context).pop();
                //   Navigator.of(context).pop();
                //   Helpers.showSnackbar(context,
                //       content:
                //           const Text("Connection timed out"));
                //   // refresh();
                // }
              },
              child: const Center(
                  child: Text(
                "Select",
                style: TextStyle(color: Colors.white),
              )),
            )),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    );
    ;
  }
}
