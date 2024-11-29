import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

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
  final TextEditingController _textEditingController = TextEditingController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool _shiftEnabled = false;
  bool _showKeyboard = true;
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _searchInputFocusNode.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      if (context.read<ReceiptCubit>().state.customerEntity == null) throw "Customer required";
      await context.read<ItemsCubit>().getItems(
          searchKeyword: _textEditingController.text,
          customerEntity: context.read<ReceiptCubit>().state.customerEntity!);
      _searchInputFocusNode.requestFocus();

      if (_scrollController.hasClients) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(_scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
        });
      }
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (childContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: FocusScope(
            node: _focusScopeNode,
            onKeyEvent: (node, event) {
              if (event.runtimeType == KeyUpEvent) {
                return KeyEventResult.handled;
              }

              if (event.character != null &&
                  RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(event.character!) &&
                  !_searchInputFocusNode.hasPrimaryFocus) {
                _searchInputFocusNode.unfocus();
                _textEditingController.text += event.character!;
                _searchInputFocusNode.requestFocus();
                return KeyEventResult.handled;
              } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && _searchInputFocusNode.hasPrimaryFocus) {
                _searchInputFocusNode.nextFocus();
                return KeyEventResult.handled;
              } else if (event.physicalKey == PhysicalKeyboardKey.f12) {
                _searchInputFocusNode.unfocus();
                FocusManager.instance.primaryFocus?.unfocus();

                if (radioValue == null) {
                  context.pop(null);
                  return KeyEventResult.handled;
                }
                context.pop(radioValue);
                return KeyEventResult.handled;
              } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
                Navigator.of(context).pop();
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item Search',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _showKeyboard ? const Color.fromARGB(255, 110, 0, 0) : ProjectColors.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(360)),
                      ),
                      child: IconButton(
                        focusColor: const Color.fromARGB(255, 110, 0, 0),
                        focusNode: _keyboardFocusNode,
                        icon: Icon(
                          _showKeyboard ? Icons.keyboard_hide_outlined : Icons.keyboard_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showKeyboard = !_showKeyboard;
                          });
                        },
                        tooltip: 'Toggle Keyboard',
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              contentPadding: const EdgeInsets.all(0),
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
                          controller: _textEditingController,
                          onSubmitted: (_) => onSubmit(),
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
                          keyboardType: TextInputType.none,
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
                              return const EmptyList(
                                imagePath: "assets/images/empty-search.svg",
                                sentence: "Tadaa.. There is nothing here!\nEnter any keyword to search.",
                              );
                            }
                            return ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                itemCount: state.length,
                                itemBuilder: ((context, index) {
                                  final ItemEntity itemEntity = state[index];

                                  return Column(
                                    children: [
                                      RadioListTile<ItemEntity>(
                                          activeColor: ProjectColors.primary,
                                          hoverColor: ProjectColors.primary,
                                          // selected: index == radioValue,
                                          selectedTileColor: ProjectColors.primary,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          value: state[index],
                                          groupValue: radioValue,
                                          dense: true,
                                          visualDensity: VisualDensity.compact,
                                          title: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (itemEntity.shortName != "")
                                                    ? itemEntity.shortName ?? itemEntity.itemName
                                                    : itemEntity.itemName,
                                                style: const TextStyle(fontSize: 14, height: 1),
                                              ),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                          subtitle: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/inventory.svg",
                                                height: 14,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                itemEntity.itemCode,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SvgPicture.asset(
                                                "assets/images/barcode.svg",
                                                height: 14,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                itemEntity.barcode,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              const Icon(
                                                Icons.sell_outlined,
                                                size: 14,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Rp ${Helpers.parseMoney(itemEntity.price.toInt())}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              radioValue = val;
                                            });
                                          }),
                                      const SizedBox(height: 3),
                                      const Divider(
                                        height: 1,
                                        thickness: 0.5,
                                        color: Color.fromARGB(100, 118, 118, 118),
                                      ),
                                    ],
                                  );
                                }));
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      (_showKeyboard)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: KeyboardWidget(
                                controller: _textEditingController,
                                isNumericMode: false,
                                onKeyPress: (key) async {
                                  String text = _textEditingController.text;
                                  if (key.keyType == VirtualKeyboardKeyType.String) {
                                    text = text + ((_shiftEnabled ? key.capsText : key.text) ?? '');
                                  } else if (key.keyType == VirtualKeyboardKeyType.Action) {
                                    switch (key.action) {
                                      case VirtualKeyboardKeyAction.Backspace:
                                        if (text.isNotEmpty) {
                                          text = text.substring(0, text.length - 1);
                                        }
                                        break;
                                      case VirtualKeyboardKeyAction.Return:
                                        _textEditingController.text = _textEditingController.text.trimRight();
                                        await onSubmit();
                                        break;
                                      case VirtualKeyboardKeyAction.Space:
                                        text = text + (key.text ?? '');
                                        break;
                                      case VirtualKeyboardKeyAction.Shift:
                                        _shiftEnabled = !_shiftEnabled;
                                        break;
                                      default:
                                        break;
                                    }
                                  }
                                  _textEditingController.text = text;
                                  _textEditingController.selection = TextSelection.collapsed(offset: text.length);

                                  setState(() {});
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      // Container(
                      //   color: Colors.white,
                      //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(5),
                      //       color: const Color.fromARGB(255, 245, 245, 245),
                      //     ),
                      //     child: VirtualKeyboard(
                      //       height: 200,
                      //       //width: 500,
                      //       textColor: ProjectColors.primary,
                      //       fontSize: 16,
                      //       textController: _textEditingController,
                      //       //customLayoutKeys: _customLayoutKeys,
                      //       defaultLayouts: [
                      //         // VirtualKeyboardDefaultLayouts.Arabic,
                      //         VirtualKeyboardDefaultLayouts.English
                      //       ],

                      //       //reverseLayout :true,
                      //       type: VirtualKeyboardType.Alphanumeric,

                      //       postKeyPress: (key) async {
                      //         if (key.action == VirtualKeyboardKeyAction.Return) {
                      //           _textEditingController.text = _textEditingController.text.trimRight();
                      //           await onSubmit();
                      //         }

                      //         _searchInputFocusNode.requestFocus();
                      //       },
                      //     ),
                      //   ),
                      // )
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
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black.withOpacity(.2))),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                          // Future.delayed(const Duration(milliseconds: 200),
                          //     () => _newReceiptItemCodeFocusNode.requestFocus());
                        });
                      },
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Cancel",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: "  (Esc)",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                            style: TextStyle(color: ProjectColors.primary),
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                            backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                        onPressed: () {
                          FocusScope.of(childContext).unfocus();
                          if (radioValue == null) return;

                          // Handle Item DP
                          if (radioValue!.itemCode == '99' || radioValue!.itemCode == '08700000002') {
                            SnackBarHelper.presentErrorSnackBar(childContext,
                                "Please use the Down Payment button to process a down payment transaction");
                            return;
                          }

                          context.pop(radioValue);
                        },
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Select",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: "  (F12)",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            ),
          ),
        );
      }),
    );
  }
}
