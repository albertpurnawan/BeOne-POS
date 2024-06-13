import 'dart:developer';

import 'package:flutter/material.dart';
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
  String? salesSelected;
  String? tohemIdSelected;

  @override
  void initState() {
    super.initState();
    final ReceiptItemEntity stateItem =
        context.read<ReceiptCubit>().state.receiptItems[widget.indexSelected];
    _noteController.text = stateItem.remarks ?? "";
    tohemIdSelected = stateItem.tohemId;
    getEmployee(tohemIdSelected ?? "");
  }

  void getEmployee(String tohemId) async {
    final result = await GetIt.instance<AppDatabase>()
        .employeeDao
        .readByDocId(tohemId, null);
    if (result != null) {
      setState(() {
        salesSelected = result.empName;
      });
    } else {
      setState(() {
        salesSelected = "Not Found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ReceiptItemEntity stateItem =
        context.read<ReceiptCubit>().state.receiptItems[(widget.indexSelected)];

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
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'Item Details',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
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
                      Text(
                        "Item - ${widget.indexSelected} - ${stateItem.itemEntity.itemName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 66, 66, 66),
                          fontSize: 16,
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 15),
                          const Divider(
                            height: 0,
                          ),
                          InkWell(
                            onTap: () => showDialog<EmployeeEntity>(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectEmployee(),
                            ).then((selectedEmployee) {
                              if (selectedEmployee != null) {
                                setState(() {
                                  salesSelected = selectedEmployee.empName;
                                  tohemIdSelected = selectedEmployee.docId;
                                });
                                log("selectedEmployee - $selectedEmployee");
                              }
                            }),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.handshake_outlined,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                        ),
                                        SizedBox(width: 30),
                                        Text(
                                          "Sales",
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
                                            color:
                                                Color.fromARGB(255, 66, 66, 66),
                                          ),
                                        ),
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
                                "Note",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ProjectColors.primary, width: 2)),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextField(
                                    maxLines: 5,
                                    maxLength: 300,
                                    controller: _noteController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: "",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                                color: ProjectColors.primary))),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.white),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => ProjectColors.primary
                                                .withOpacity(.2))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Cancel",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "  (Esc)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                      style: TextStyle(
                                          color: ProjectColors.primary),
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: ProjectColors.primary),
                                    )),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => ProjectColors.primary),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.white.withOpacity(.2))),
                                onPressed: () {
                                  context
                                      .read<ReceiptCubit>()
                                      .updateTohemIdRemarks(
                                          tohemIdSelected ?? "",
                                          _noteController.text,
                                          widget.indexSelected);
                                  Navigator.of(context).pop();
                                  log("receiptAfUpdate - ${context.read<ReceiptCubit>().state.receiptItems[(widget.indexSelected)]}");
                                },
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Save",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                          text: "  (Enter)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
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
                )),
          ),
        ),
      ),
    );
  }
}
