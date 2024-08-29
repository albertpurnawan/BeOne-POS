import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_employee_dialog.dart';

class ItemDetailsDialog extends StatefulWidget {
  final int indexSelected;
  const ItemDetailsDialog({super.key, required this.indexSelected});

  @override
  State<ItemDetailsDialog> createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends State<ItemDetailsDialog> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  late final ReceiptItemEntity stateItem;
  String? salesSelected;
  String? tohemIdSelected;

  @override
  void initState() {
    super.initState();
    stateItem = context.read<ReceiptCubit>().state.receiptItems[widget.indexSelected];
    _noteController.text = stateItem.remarks ?? "";
    tohemIdSelected = stateItem.tohemId;
    getEmployee(tohemIdSelected ?? "");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void getEmployee(String tohemId) async {
    final result = await GetIt.instance<AppDatabase>().employeeDao.readByDocId(tohemId, null);
    if (result != null) {
      setState(() {
        salesSelected = result.empName;
      });
    } else {
      setState(() {
        salesSelected = "Not Set";
      });
    }
  }

  void removeSalesPerson() async {
    setState(() {
      salesSelected = "Not Set";
      tohemIdSelected = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) {
          return KeyEventResult.handled;
        }

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          context
              .read<ReceiptCubit>()
              .updateTohemIdRemarksOnReceiptItem(tohemIdSelected ?? "", _noteController.text, widget.indexSelected);
          _noteFocusNode.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.of(context).pop();
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.escape && !_noteFocusNode.hasPrimaryFocus) {
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown && !_noteFocusNode.hasPrimaryFocus) {
          _noteFocusNode.nextFocus();
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
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: const Text(
            'Item Attributes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Scrollbar(
              controller: _scrollController,
              thickness: 4,
              radius: const Radius.circular(30),
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      ExcludeFocus(
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            // width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                            decoration: BoxDecoration(
                              color: ProjectColors.primary,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.222),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.inventory_2_outlined, color: Colors.white),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  (stateItem.itemEntity.shortName ?? stateItem.itemEntity.itemName),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          const Divider(height: 0),
                          InkWell(
                            onTap: () => showDialog<EmployeeEntity>(
                              context: context,
                              builder: (BuildContext context) => const SelectEmployee(),
                            ).then((selectedEmployee) {
                              if (selectedEmployee != null) {
                                setState(() {
                                  salesSelected = selectedEmployee.empName;
                                  tohemIdSelected = selectedEmployee.docId;
                                });
                                // log("selectedEmployee - $selectedEmployee");
                              }
                            }),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.handshake_outlined,
                                          color: Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(width: 30),
                                        Text(
                                          "Salesperson",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          salesSelected.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(255, 66, 66, 66),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        (salesSelected != "Not Set" && salesSelected != null)
                                            ? IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: ProjectColors.primary,
                                                ),
                                                onPressed: () {
                                                  removeSalesPerson();
                                                },
                                              )
                                            : IconButton(
                                                icon: const Icon(
                                                  Icons.navigate_next,
                                                  color: Color.fromARGB(255, 66, 66, 66),
                                                ),
                                                onPressed: () => showDialog<EmployeeEntity>(
                                                      context: context,
                                                      builder: (BuildContext context) => const SelectEmployee(),
                                                    ).then((selectedEmployee) {
                                                      if (selectedEmployee != null) {
                                                        setState(() {
                                                          salesSelected = selectedEmployee.empName;
                                                          tohemIdSelected = selectedEmployee.docId;
                                                        });
                                                      }
                                                    })),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const Divider(height: 0),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.note_alt_outlined,
                                color: Color.fromARGB(255, 66, 66, 66),
                              ),
                              SizedBox(width: 30),
                              Text(
                                "Remarks",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(54, 10, 5, 10),
                            child: Container(
                              // height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                maxLines: 3,
                                maxLength: 300,
                                focusNode: _noteFocusNode,
                                controller: _noteController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(),
                                  counterText: "",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 0),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(color: ProjectColors.primary))),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                    overlayColor: MaterialStateColor.resolveWith(
                                        (states) => ProjectColors.primary.withOpacity(.2))),
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                              const SizedBox(width: 10),
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(color: ProjectColors.primary),
                                    )),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () {
                                  context.read<ReceiptCubit>().updateTohemIdRemarksOnReceiptItem(
                                      tohemIdSelected ?? "", _noteController.text, widget.indexSelected);
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Save",
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
                              )),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
