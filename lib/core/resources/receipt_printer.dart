// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/payment_type.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/print_receipt_detail.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_open_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_qris_payment.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';

class ReceiptPrinter {
  BluetoothPrinter? selectedPrinter;
  // BluetoothPrinter? selectedPrinter = BluetoothPrinter(
  //   // deviceName: "192.168.1.249:9100",
  //   // address: "192.168.1.249",
  //   // typePrinter: PrinterType.network,
  //   deviceName: "POS-80C",
  //   address: null,
  //   port: null,
  //   vendorId: null,
  //   productId: null,
  //   isBle: false,
  //   typePrinter: PrinterType.usb,
  //   state: null,
  // );
  List<int>? pendingTask;
  final bool _reconnect = true;
  final BTStatus _currentStatus = BTStatus.none;
  PrintReceiptDetail? currentPrintReceiptDetail;

  ReceiptPrinter._init();

  static Future<ReceiptPrinter> init() async {
    final receiptPrinter = ReceiptPrinter._init();

    if (GetIt.instance<SharedPreferences>().getStringList("defaultPrinter") != null) {
      final [deviceName, address, port, vendorId, productId, isBle, typePrinter, state] =
          GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")!;

      receiptPrinter.selectedPrinter = BluetoothPrinter(
        deviceName: deviceName == "null" ? null : deviceName,
        address: address == "null" ? null : address,
        port: port == "null" ? null : port,
        vendorId: vendorId == "null" ? null : vendorId,
        productId: productId == "null" ? null : productId,
        isBle: isBle == "true" ? true : false,
        typePrinter: typePrinter == "PrinterType.bluetooth"
            ? PrinterType.bluetooth
            : typePrinter == "PrinterType.network"
                ? PrinterType.network
                : PrinterType.usb,
        state: state == "null"
            ? null
            : state == "true"
                ? true
                : false,
      );
    }

    return receiptPrinter;
  }

  String _convertPrintReceiptContentToText(PrintReceiptContent printReceiptContent, int printType) {
    switch (printReceiptContent.printReceiptContentType) {
      case PrintReceiptContentType.storeName:
        return currentPrintReceiptDetail?.storeMasterEntity.storeName ?? "";
      case PrintReceiptContentType.date:
        return DateFormat('yyyy-MM-dd').format(currentPrintReceiptDetail!.receiptEntity.transDateTime!);
      case PrintReceiptContentType.time:
        return DateFormat('hh:mm aaa').format(currentPrintReceiptDetail!.receiptEntity.transDateTime!);
      case PrintReceiptContentType.datetime:
        dev.log(DateFormat('dd/MM/yy HH:mm')
            .format(printType == 2 ? DateTime.now() : currentPrintReceiptDetail!.receiptEntity.transDateTime!));
        return DateFormat('dd/MM/yy HH:mm')
            .format(printType == 2 ? DateTime.now() : currentPrintReceiptDetail!.receiptEntity.transDateTime!);
      case PrintReceiptContentType.docNum:
        return currentPrintReceiptDetail?.receiptEntity.docNum ?? "";
      case PrintReceiptContentType.employeeCodeAndName:
        // return "";
        return "${currentPrintReceiptDetail?.receiptEntity.employeeEntity?.empCode} - ${currentPrintReceiptDetail?.receiptEntity.employeeEntity?.empName}";
      // case PrintReceiptContentType.mopAlias:
      //   return currentPrintReceiptDetail
      //           ?.receiptEntity.mopSelection?.mopAlias ??
      //       "";
      case PrintReceiptContentType.address1:
        return currentPrintReceiptDetail?.storeMasterEntity.addr1 ?? "";
      case PrintReceiptContentType.address2:
        return currentPrintReceiptDetail?.storeMasterEntity.addr2 ?? "";
      case PrintReceiptContentType.address3:
        return currentPrintReceiptDetail?.storeMasterEntity.addr3 ?? "";
      case PrintReceiptContentType.city:
        return currentPrintReceiptDetail?.storeMasterEntity.city ?? "";
      case PrintReceiptContentType.header01:
        return currentPrintReceiptDetail?.storeMasterEntity.header01?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.header02:
        return currentPrintReceiptDetail?.storeMasterEntity.header02?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.header03:
        return currentPrintReceiptDetail?.storeMasterEntity.header03?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.header04:
        return currentPrintReceiptDetail?.storeMasterEntity.header04?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.header05:
        return currentPrintReceiptDetail?.storeMasterEntity.header05?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.footer01:
        return currentPrintReceiptDetail?.storeMasterEntity.footer01?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.footer02:
        return currentPrintReceiptDetail?.storeMasterEntity.footer02?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.footer03:
        return currentPrintReceiptDetail?.storeMasterEntity.footer03?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.footer04:
        return currentPrintReceiptDetail?.storeMasterEntity.footer04?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.footer05:
        return currentPrintReceiptDetail?.storeMasterEntity.footer05?.replaceAll("\\n", "\n") ?? "";
      case PrintReceiptContentType.customer:
        return "Customer: [${currentPrintReceiptDetail?.receiptEntity.customerEntity?.custCode ?? "-"}] ${currentPrintReceiptDetail?.receiptEntity.customerEntity?.custName ?? "-"}";
      case PrintReceiptContentType.customRow1:
      case PrintReceiptContentType.customRow2:
      case PrintReceiptContentType.customRow3:
      case PrintReceiptContentType.customRow4:
      case PrintReceiptContentType.customRow5:
      case PrintReceiptContentType.customRow6:
      case PrintReceiptContentType.customRow7:
      case PrintReceiptContentType.customRow8:
      case PrintReceiptContentType.customRow9:
      case PrintReceiptContentType.customRow10:
        return printReceiptContent.customValue ?? "";
      default:
        return "";
    }
  }

  Future<List<int>> _convertPrintReceiptContentToBytes(
    List<PrintReceiptContent> printReceiptContentsRow,
    Generator generator,
    int printType,
  ) async {
    List<int> bytes = [];

    final int maxLength = GetIt.instance<SharedPreferences>().getInt("charactersPerLine") ?? 42;

    final int width1Length = WidthNLength.getLength(maxLength, 1);
    final int width2Length = WidthNLength.getLength(maxLength, 2);
    final int width3Length = WidthNLength.getLength(maxLength, 3);
    final int width4Length = WidthNLength.getLength(maxLength, 4);
    final int width5Length = WidthNLength.getLength(maxLength, 5);
    final int width6Length = WidthNLength.getLength(maxLength, 6);
    final int width7Length = WidthNLength.getLength(maxLength, 7);
    final int width8Length = WidthNLength.getLength(maxLength, 8);
    final int width9Length = WidthNLength.getLength(maxLength, 9);
    final int width10Length = WidthNLength.getLength(maxLength, 10);
    final int width11Length = WidthNLength.getLength(maxLength, 11);
    final int width12Length = WidthNLength.getLength(maxLength, 12);

    if (printReceiptContentsRow.length == 1) {
      final PrintReceiptContent printReceiptContent = printReceiptContentsRow.first;
      switch (printReceiptContentsRow[0].printReceiptContentType) {
        case PrintReceiptContentType.emptyLine:
          bytes += generator.emptyLines(1);
        case PrintReceiptContentType.horizontalLine:
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
        case PrintReceiptContentType.items:
          int count = 1;
          for (final item in currentPrintReceiptDetail!.receiptEntity.receiptItems) {
            EmployeeEntity? salesEmployeeEntity;
            if (item.tohemId != null && item.tohemId != "") {
              salesEmployeeEntity = await GetIt.instance<EmployeeRepository>().getEmployee(item.tohemId!);
            } else if (currentPrintReceiptDetail!.receiptEntity.salesTohemId != null) {
              salesEmployeeEntity = await GetIt.instance<EmployeeRepository>()
                  .getEmployee(currentPrintReceiptDetail!.receiptEntity.salesTohemId!);
            }

            // Layout1
            // bytes += generator.row([
            //   PosColumn(
            //       width: 4,
            //       text:
            //           "${item.promos.isEmpty || item.discAmount! <= 0 ? "" : "*"}${item.itemEntity.itemCode}",
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: printReceiptContent.isBold,
            //
            //       )),
            //   PosColumn(
            //       width: 5,
            //       // text: Helpers.clipStringAndAddEllipsis(
            //       //     "${item.promos.isEmpty ? "" : "*"}${item.itemEntity.itemName}",
            //       //     35),
            //       text: " ${item.itemEntity.itemName}".substring(0, 19),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: printReceiptContent.isBold,
            //
            //       )),
            //   // PosColumn(
            //   //     width: 1,
            //   //     text: Helpers.alignRightByAddingSpace(
            //   //         Helpers.cleanDecimal(item.quantity, 3), 3),
            //   //     styles: PosStyles(
            //   //       align: PosAlign.left,
            //   //       height: printReceiptContent.fontSize,
            //   //       width: printReceiptContent.fontSize,
            //   //       bold: printReceiptContent.isBold,
            //   //
            //   //     )),
            //   // PosColumn(
            //   //     width: 3,
            //   //     text: Helpers.alignRightByAddingSpace(
            //   //         Helpers.parseMoney(item.itemEntity.price.round()), 10),
            //   //     styles: PosStyles(
            //   //       align: PosAlign.left,
            //   //       height: printReceiptContent.fontSize,
            //   //       width: printReceiptContent.fontSize,
            //   //       bold: printReceiptContent.isBold,
            //   //
            //   //     )),
            //   PosColumn(
            //       width: 3,
            //       text: Helpers.alignRightByAddingSpace(
            //           Helpers.parseMoney(item.totalAmount.round()), 11),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: printReceiptContent.isBold,
            //
            //       )),
            // ]);
            // bytes += generator.row([
            //   PosColumn(
            //       width: 5,
            //       text: Helpers.clipStringAndAddEllipsis(
            //           ' ${salesEmployeeEntity?.empName ?? ""}', 15),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: printReceiptContent.isBold,
            //
            //       )),
            //   // PosColumn(
            //   //     width: 1,
            //   //     // text: Helpers.clipStringAndAddEllipsis(
            //   //     //     "${item.promos.isEmpty ? "" : "*"}${item.itemEntity.itemName}",
            //   //     //     35),
            //   //     text: Helpers.alignRightByAddingSpace(
            //   //         "${Helpers.cleanDecimal(item.quantity, 3)}x", 3),
            //   //     styles: PosStyles(
            //   //       align: PosAlign.left,
            //   //       height: printReceiptContent.fontSize,
            //   //       width: printReceiptContent.fontSize,
            //   //       bold: printReceiptContent.isBold,
            //   //
            //   //     )),
            //   // PosColumn(
            //   //     width: 1,
            //   //     text: Helpers.alignRightByAddingSpace(
            //   //         Helpers.cleanDecimal(item.quantity, 3), 3),
            //   //     styles: PosStyles(
            //   //       align: PosAlign.left,
            //   //       height: printReceiptContent.fontSize,
            //   //       width: printReceiptContent.fontSize,
            //   //       bold: printReceiptContent.isBold,
            //   //
            //   //     )),
            //   // PosColumn(
            //   //     width: 3,
            //   //     text: Helpers.alignRightByAddingSpace(
            //   //         Helpers.parseMoney(item.itemEntity.price.round()), 10),
            //   //     styles: PosStyles(
            //   //       align: PosAlign.left,
            //   //       height: printReceiptContent.fontSize,
            //   //       width: printReceiptContent.fontSize,
            //   //       bold: printReceiptContent.isBold,
            //   //
            //   //     )),
            //   PosColumn(
            //       width: 4,
            //       text: Helpers.alignRightByAddingSpace(
            //           "${Helpers.cleanDecimal(item.quantity, 3)}x @${Helpers.parseMoney(item.sellingPrice.round())}",
            //           15),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: printReceiptContent.isBold,
            //
            //       )),
            //   PosColumn(
            //       width: 3,
            //       text: "",
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: printReceiptContent.isBold,
            //
            //       )),
            // ]);

            // // Layout2
            // bytes += generator.row([
            //   PosColumn(
            //       width: 5,
            //       text: ("${item.promos.isEmpty || (item.discAmount ?? 0) <= 0 ? "" : "*"}${item.itemEntity.barcode}"),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: true,
            //       )),
            //   PosColumn(
            //       width: 4,
            //       text: Helpers.alignLeftByAddingSpace(
            //           " ${Helpers.cleanDecimal(item.quantity, 3)}x${Helpers.parseMoney(item.sellingPrice.round())}",
            //           15),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: true,
            //       )),
            //   PosColumn(
            //       width: 3,
            //       text: Helpers.alignRightByAddingSpace(Helpers.parseMoney(item.totalAmount.round()), 11),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //         bold: true,
            //       )),
            // ]);
            // bytes += generator.text(
            //     Helpers.alignLeftByAddingSpace(item.itemEntity.shortName ?? item.itemEntity.itemName, 48),
            //     styles: PosStyles(
            //       align: PosAlign.left,
            //       height: printReceiptContent.fontSize,
            //       width: printReceiptContent.fontSize,
            //       bold: printReceiptContent.isBold,
            //     ));
            // if (salesEmployeeEntity?.empName == null) continue;
            // bytes += generator.text(Helpers.alignLeftByAddingSpace(">> ${salesEmployeeEntity!.empName}", 48),
            //     styles: PosStyles(
            //       align: PosAlign.left,
            //       height: printReceiptContent.fontSize,
            //       width: printReceiptContent.fontSize,
            //       bold: printReceiptContent.isBold,
            //     ));

            // // Layout3
            // String barcodeString = item.itemEntity.barcode;
            // int barcodeLength = barcodeString.length;
            // final int barcodeRequiredRow = (barcodeLength / 15).ceil();
            // String priceQtyString =
            //     " ${Helpers.cleanDecimal(item.quantity, 3)}x${Helpers.parseMoney(item.sellingPrice.round())}";
            // int priceQtyLength = priceQtyString.length;
            // final int priceQtyRequiredRow = (priceQtyLength / 15).ceil();
            // String totalAmountString =
            //     Helpers.alignRightByAddingSpace(Helpers.parseMoney(item.totalAmount.round()), 11);
            // int totalAmountLength = totalAmountString.length;
            // final int totalAmountRequiredRow = (totalAmountLength / 11).ceil();
            // for (int i = 0; i < max(max(barcodeRequiredRow, priceQtyRequiredRow), totalAmountRequiredRow); i++) {
            //   bytes += generator.row([
            //     PosColumn(
            //         width: 1,
            //         text: i == 0 ? count.toString() : "",
            //         styles: PosStyles(
            //           align: PosAlign.left,
            //           height: printReceiptContent.fontSize,
            //           width: printReceiptContent.fontSize,
            //           bold: true,
            //         )),
            //     PosColumn(
            //         width: 4,
            //         text: i < barcodeRequiredRow
            //             ? Helpers.alignLeftByAddingSpace(
            //                 barcodeString.substring(i * 15, i == barcodeRequiredRow - 1 ? null : (i + 1) * 15), 15)
            //             : Helpers.alignLeftByAddingSpace("", 15),
            //         styles: PosStyles(
            //           align: PosAlign.left,
            //           height: printReceiptContent.fontSize,
            //           width: printReceiptContent.fontSize,
            //           bold: true,
            //         )),
            //     PosColumn(
            //         width: 4,
            //         text: i < priceQtyRequiredRow
            //             ? Helpers.alignLeftByAddingSpace(
            //                 priceQtyString.substring(i * 15, i == priceQtyRequiredRow - 1 ? null : (i + 1) * 15), 15)
            //             : Helpers.alignLeftByAddingSpace("", 15),
            //         styles: PosStyles(
            //           align: PosAlign.left,
            //           height: printReceiptContent.fontSize,
            //           width: printReceiptContent.fontSize,
            //           bold: true,
            //         )),
            //     PosColumn(
            //         width: 3,
            //         text: i < totalAmountRequiredRow
            //             ? Helpers.alignRightByAddingSpace(
            //                 totalAmountString.substring(i * 11, i == totalAmountRequiredRow - 1 ? null : (i + 1) * 11),
            //                 11)
            //             : Helpers.alignLeftByAddingSpace("", 11),
            //         styles: PosStyles(
            //           align: PosAlign.left,
            //           height: printReceiptContent.fontSize,
            //           width: printReceiptContent.fontSize,
            //           bold: true,
            //         )),
            //   ]);
            // }
            // count += 1;
            // int itemNameLength = (item.itemEntity.shortName ?? item.itemEntity.itemName).length;
            // final int requiredRow = (itemNameLength / 42).ceil();
            // dev.log("$itemNameLength $requiredRow");
            // for (int i = 0; i < requiredRow; i++) {
            //   bytes += generator.row([
            //     PosColumn(
            //         width: 1,
            //         text: "",
            //         styles: PosStyles(
            //           align: PosAlign.left,
            //           height: printReceiptContent.fontSize,
            //           width: printReceiptContent.fontSize,
            //         )),
            //     PosColumn(
            //         width: 11,
            //         text: Helpers.alignLeftByAddingSpace(
            //             (item.itemEntity.shortName ?? item.itemEntity.itemName)
            //                 .substring(i * 42, i == requiredRow - 1 ? null : (i + 1) * 42),
            //             42),
            //         styles: PosStyles(
            //           align: PosAlign.left,
            //           height: printReceiptContent.fontSize,
            //           width: printReceiptContent.fontSize,
            //         )),
            //   ]);
            // }
            // if (salesEmployeeEntity?.empName == null) continue;
            // bytes += generator.row([
            //   PosColumn(
            //       width: 1,
            //       text: "",
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //       )),
            //   PosColumn(
            //       width: 11,
            //       text: Helpers.alignLeftByAddingSpace(">> ${salesEmployeeEntity!.empName}", 42).substring(0, 42),
            //       styles: PosStyles(
            //         align: PosAlign.left,
            //         height: printReceiptContent.fontSize,
            //         width: printReceiptContent.fontSize,
            //       )),
            // ]);

            // Layout4
            String barcodeString = "${(item.discAmount ?? 0) > 0 ? '*' : ''}${item.itemEntity.barcode}";
            int barcodeLength = barcodeString.length;
            final int barcodeRequiredRow = (barcodeLength / 42).ceil();

            for (int i = 0; i < barcodeRequiredRow; i++) {
              bytes += generator.row([
                PosColumn(
                    width: 1,
                    text: Helpers.alignLeftByAddingSpace(i == 0 ? count.toString() : "", width1Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                      bold: true,
                    )),
                PosColumn(
                    width: 11,
                    text: i < barcodeRequiredRow
                        ? Helpers.alignLeftByAddingSpace(
                            barcodeString.substring(
                                i * width11Length, i == barcodeRequiredRow - 1 ? null : (i + 1) * width11Length),
                            width11Length)
                        : Helpers.alignLeftByAddingSpace("", width11Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                      bold: true,
                    )),
              ]);
            }

            int itemNameLength = (item.itemEntity.shortName ?? item.itemEntity.itemName).length;
            final int requiredRow = (itemNameLength / width11Length).ceil();
            for (int i = 0; i < requiredRow; i++) {
              bytes += generator.row([
                PosColumn(
                    width: 1,
                    text: Helpers.alignLeftByAddingSpace("", width1Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
                PosColumn(
                    width: 11,
                    text: Helpers.alignLeftByAddingSpace(
                        (item.itemEntity.shortName ?? item.itemEntity.itemName)
                            .substring(i * width11Length, i == requiredRow - 1 ? null : (i + 1) * width11Length),
                        width11Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
              ]);
            }

            String priceQtyString =
                " ${Helpers.cleanDecimal(item.quantity, 3)}x${Helpers.parseMoney(item.sellingPrice.round())}";
            int priceQtyLength = priceQtyString.length;
            final int priceQtyRequiredRow = (priceQtyLength / width5Length).ceil();

            String totalAmountString = Helpers.parseMoney(item.totalAmount.round());
            int totalAmountLength = totalAmountString.length;
            final int totalAmountRequiredRow = (totalAmountLength / width4Length).ceil();

            for (int i = 0; i < max(priceQtyRequiredRow, totalAmountRequiredRow); i++) {
              bytes += generator.row([
                PosColumn(
                    width: 3,
                    text: Helpers.alignLeftByAddingSpace("", width3Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
                PosColumn(
                    width: 5,
                    text: i < priceQtyRequiredRow
                        ? Helpers.alignLeftByAddingSpace(
                            priceQtyString.substring(
                                i * width5Length, i == priceQtyRequiredRow - 1 ? null : (i + 1) * width5Length),
                            width5Length)
                        : Helpers.alignLeftByAddingSpace("", width5Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
                PosColumn(
                    width: 4,
                    text: i < totalAmountRequiredRow
                        ? Helpers.alignRightByAddingSpace(
                            totalAmountString.substring(
                                i * width4Length, i == totalAmountRequiredRow - 1 ? null : (i + 1) * width4Length),
                            width4Length)
                        : Helpers.alignLeftByAddingSpace("", width4Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
              ]);
            }

            count += 1;

            final double? lineDiscount =
                item.promos.where((element) => element.promoType == 998).firstOrNull?.discAmount;
            if (lineDiscount != null) {
              bytes += generator.row([
                PosColumn(
                    width: 1,
                    text: Helpers.alignLeftByAddingSpace("", width1Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
                PosColumn(
                    width: 11,
                    text: Helpers.alignLeftByAddingSpace(
                            ">> Discount: ${Helpers.parseMoney(lineDiscount * ((100 + item.itemEntity.taxRate) / 100))}",
                            width11Length)
                        .substring(0, width11Length),
                    styles: PosStyles(
                      align: PosAlign.left,
                      height: printReceiptContent.fontSize,
                      width: printReceiptContent.fontSize,
                    )),
              ]);
            }

            if (salesEmployeeEntity?.empName == null) continue;
            bytes += generator.row([
              PosColumn(
                  width: 1,
                  text: Helpers.alignLeftByAddingSpace("", width1Length),
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                  )),
              PosColumn(
                  width: 11,
                  text: Helpers.alignLeftByAddingSpace(">> ${salesEmployeeEntity!.empName}", width11Length)
                      .substring(0, width11Length),
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                  )),
            ]);
          }
        case PrintReceiptContentType.totalPrice:
          bytes += generator.emptyLines(1);
          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Total", width6Length),
                styles: PosStyles(
                  align: PosAlign.left,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.grandTotal.round()), width6Length),
                styles: PosStyles(
                  align: PosAlign.left,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                )),
          ]);
          // bytes += generator.emptyLines(1);
          // bytes += generator.text(
          //     Helpers.alignLeftByAddingSpace(
          //         'Total Qty.: ${Helpers.cleanDecimal(currentPrintReceiptDetail!.receiptEntity.receiptItems.map((e) => e.quantity).reduce((value, element) => value + element), 3)}',
          //         48),
          //     styles: const PosStyles(
          //       align: PosAlign.left,
          //       height: PosTextSize.size1,
          //       width: PosTextSize.size1,
          //       bold: true,
          //     ));

          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Total Qty.", width6Length),
                styles: PosStyles(
                  align: PosAlign.left,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.cleanDecimal(
                        currentPrintReceiptDetail!.receiptEntity.receiptItems
                            .map((e) => e.quantity)
                            .reduce((value, element) => value + element),
                        3),
                    width6Length),
                styles: PosStyles(
                  align: PosAlign.left,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                )),
          ]);
          bytes += generator.emptyLines(1);
        case PrintReceiptContentType.taxDetails:
          // bytes += generator.row([
          //   PosColumn(
          //       width: 8,
          //       text: "Total Gross",
          //       styles: const PosStyles(
          //         align: PosAlign.left,
          //
          //       )),
          //   PosColumn(
          //       width: 4,
          //       text: Helpers.alignRightByAddingSpace(
          //           Helpers.parseMoney(currentPrintReceiptDetail!
          //               .receiptEntity.subtotal
          //               .round()),
          //           15),
          //       styles: const PosStyles(
          //         align: PosAlign.left,
          //
          //       )),
          // ]);

          final double totalLineDiscount = currentPrintReceiptDetail!.receiptEntity.receiptItems.fold(
              0.0,
              (previousValue, e1) =>
                  previousValue +
                  (((100 + e1.itemEntity.taxRate) / 100) *
                      e1.promos
                          .where((e2) => e2.promoType == 998)
                          .fold(0.0, (previousValue, e3) => previousValue + (e3.discAmount ?? 0))));

          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Promotions Discount", width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.receiptItems
                            .map((e) => (e.discAmount ?? 0) * ((100 + e.itemEntity.taxRate) / 100))
                            .reduce((value, element) => value + element)
                            .round() -
                        totalLineDiscount),
                    width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
          ]);
          // bytes += generator.row([
          //   PosColumn(
          //       width: 8,
          //       text: "Subtotal",
          //       styles: const PosStyles(
          //         align: PosAlign.left,
          //         bold: true,
          //
          //       )),
          //   PosColumn(
          //       width: 4,
          //       text: Helpers.alignRightByAddingSpace(
          //           Helpers.parseMoney(
          //               (currentPrintReceiptDetail!.receiptEntity.subtotal -
          //                       (currentPrintReceiptDetail!
          //                               .receiptEntity.discAmount ??
          //                           0) +
          //                       (currentPrintReceiptDetail!
          //                               .receiptEntity.discHeaderManual ??
          //                           0))
          //                   .round()),
          //           15),
          //       styles: const PosStyles(
          //         align: PosAlign.left,
          //         bold: true,
          //
          //       )),
          // ]);

          if (currentPrintReceiptDetail!.receiptEntity.couponDiscount > 0) {
            bytes += generator.row([
              PosColumn(
                  width: 6,
                  text: Helpers.alignLeftByAddingSpace("Coupon Discount", width6Length),
                  styles: const PosStyles(
                    align: PosAlign.left,
                  )),
              PosColumn(
                  width: 6,
                  text: Helpers.alignRightByAddingSpace(
                      Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.couponDiscount), width6Length),
                  styles: const PosStyles(
                    align: PosAlign.left,
                  )),
            ]);
          }

          if (currentPrintReceiptDetail!.receiptEntity.receiptItems
              .any((e1) => e1.promos.any((e2) => e2.promoType == 998))) {
            bytes += generator.row([
              PosColumn(
                  width: 6,
                  text: Helpers.alignLeftByAddingSpace("Total Line Discount", width6Length),
                  styles: const PosStyles(
                    align: PosAlign.left,
                  )),
              PosColumn(
                  width: 6,
                  text: Helpers.alignRightByAddingSpace(Helpers.parseMoney(totalLineDiscount), width6Length),
                  styles: const PosStyles(
                    align: PosAlign.left,
                  )),
            ]);
          }

          // bytes += generator.emptyLines(1);
          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Header Discount", width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.discHeaderManual != null
                        ? currentPrintReceiptDetail!.receiptEntity.discHeaderManual!.round()
                        : 0),
                    width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
          ]);

          // bytes += generator.row([
          //   PosColumn(
          //       width: 8,
          //       text: "Tax Amount",
          //       styles: const PosStyles(
          //         align: PosAlign.left,
          //
          //       )),
          //   PosColumn(
          //       width: 4,
          //       text: Helpers.alignRightByAddingSpace(
          //           Helpers.parseMoney(currentPrintReceiptDetail!
          //               .receiptEntity.taxAmount
          //               .round()),
          //           15),
          //       styles: const PosStyles(
          //         align: PosAlign.left,
          //
          //       )),
          // ]);
          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Rounding", width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.rounding.round()), width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
          ]);
          bytes += generator.emptyLines(1);
          bytes += generator.text("*** Thank You ***", styles: const PosStyles(align: PosAlign.center));
        // bytes += generator.emptyLines(1);
        case PrintReceiptContentType.totalQty:
          bytes += generator.text(
              'Total Qty.: ${Helpers.cleanDecimal(currentPrintReceiptDetail!.receiptEntity.receiptItems.map((e) => e.quantity).reduce((value, element) => value + element), 3)}',
              styles: PosStyles(
                align: PosAlign.left,
                height: printReceiptContent.fontSize,
                width: printReceiptContent.fontSize,
                bold: printReceiptContent.isBold,
              ));
        case PrintReceiptContentType.receiptBarcode:
          // final List<String> barcodeData = currentPrintReceiptDetail!
          //     .receiptEntity.docNum
          //     .substring(0, 21) // max 21 char di 80mm
          //     .split("")
          //     .toList();
          // print(barcodeData);
          // print(generator.barcode(Barcode.code39(barcodeData)));
          // bytes += generator.barcode(Barcode.code39(barcodeData),
          //     width: 1, height: 60);
          bytes += generator.qrcode(currentPrintReceiptDetail!.receiptEntity.docNum, size: QRSize.Size6);
        case PrintReceiptContentType.mopAlias:
          for (final MopSelectionEntity mopSelection in currentPrintReceiptDetail!.receiptEntity.mopSelections) {
            bytes += generator.row([
              PosColumn(
                  width: 7,
                  text: Helpers.alignLeftByAddingSpace(
                      (mopSelection.tpmt2Id != null) ? mopSelection.cardName! : mopSelection.mopAlias, width7Length),
                  styles: const PosStyles(
                    align: PosAlign.left,
                  )),
              PosColumn(
                  width: 5,
                  text: Helpers.alignRightByAddingSpace(
                      Helpers.parseMoney(mopSelection.payTypeCode == "1"
                          ? (mopSelection.amount ?? 0) + (currentPrintReceiptDetail!.receiptEntity.changed ?? 0)
                          : mopSelection.amount ?? 0),
                      width5Length),
                  styles: const PosStyles(
                    align: PosAlign.left,
                  )),
            ]);
          }
          if (currentPrintReceiptDetail!.receiptEntity.vouchers.isNotEmpty) {
            final Map<String, num> amountByTpmt3Ids = {};

            for (final voucher in currentPrintReceiptDetail!.receiptEntity.vouchers) {
              if (amountByTpmt3Ids[voucher.tpmt3Id] == null) {
                amountByTpmt3Ids[voucher.tpmt3Id!] = voucher.voucherAmount;
              } else {
                amountByTpmt3Ids[voucher.tpmt3Id!] = amountByTpmt3Ids[voucher.tpmt3Id!]! + voucher.voucherAmount;
              }
            }

            for (final tpmt3Id in amountByTpmt3Ids.keys) {
              final MopSelectionEntity? mopSelectionEntity =
                  await GetIt.instance<MopSelectionRepository>().getMopSelectionByTpmt3Id(tpmt3Id);
              bytes += generator.row([
                PosColumn(
                    width: 7,
                    text:
                        Helpers.alignLeftByAddingSpace(mopSelectionEntity?.mopAlias ?? "Unknown Voucher", width7Length),
                    styles: const PosStyles(
                      align: PosAlign.left,
                    )),
                PosColumn(
                    width: 5,
                    text: Helpers.alignRightByAddingSpace(Helpers.parseMoney(amountByTpmt3Ids[tpmt3Id]!), width5Length),
                    styles: const PosStyles(
                      align: PosAlign.left,
                    )),
              ]);
            }
          }
          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Total Payment", width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                  bold: true,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.totalPayment ?? 0), width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                  bold: true,
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 6,
                text: Helpers.alignLeftByAddingSpace("Change", width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
            PosColumn(
                width: 6,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.changed ?? 0), width6Length),
                styles: const PosStyles(
                  align: PosAlign.left,
                )),
          ]);
        case PrintReceiptContentType.draftWatermarkTop:
          if (printType != 2) break;
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
          bytes += generator.text("PENDING ORDER",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
        case PrintReceiptContentType.draftWatermarkBottom:
          if (printType != 2) break;
          bytes += generator.text("PENDING ORDER",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
        case PrintReceiptContentType.copyWatermarkTop:
          if (printType != 3) break;
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
          bytes += generator.text("COPY BILL",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
        case PrintReceiptContentType.copyWatermarkBottom:
          if (printType != 3) break;
          bytes += generator.text("COPY BILL",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
          bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
        case PrintReceiptContentType.cashRegister:
          bytes += generator.row([
            PosColumn(
                width: 5,
                text: Helpers.alignLeftByAddingSpace('Cash Register', width5Length),
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                width: 7,
                text: Helpers.alignLeftByAddingSpace(
                    ": [${currentPrintReceiptDetail!.cashRegisterEntity.idKassa}] ${currentPrintReceiptDetail!.cashRegisterEntity.description}",
                    width7Length),
                styles: const PosStyles(align: PosAlign.left)),
          ]);
        case PrintReceiptContentType.employeeCodeAndName:
          bytes += generator.row([
            PosColumn(
                width: 5,
                text: Helpers.alignLeftByAddingSpace('Cashier', width5Length),
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                width: 7,
                text: Helpers.alignLeftByAddingSpace(
                    Helpers.clipStringAndAddEllipsis(
                        ": [${currentPrintReceiptDetail!.receiptEntity.employeeEntity?.empCode ?? "-"}] ${currentPrintReceiptDetail!.receiptEntity.employeeEntity?.empName ?? "-"}",
                        width7Length - 3),
                    width7Length),
                styles: const PosStyles(align: PosAlign.left)),
          ]);
        case PrintReceiptContentType.docNumAndDatetime:
          bytes += generator.row([
            PosColumn(
                width: 7,
                text:
                    Helpers.alignLeftByAddingSpace(currentPrintReceiptDetail?.receiptEntity.docNum ?? "", width7Length),
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                width: 5,
                text: Helpers.alignRightByAddingSpace(
                    DateFormat('dd/MM/yy HH:mm').format(
                        printType == 2 ? DateTime.now() : currentPrintReceiptDetail!.receiptEntity.transDateTime!),
                    width5Length),
                styles: const PosStyles(align: PosAlign.left)),
          ]);
        case PrintReceiptContentType.customer:
          bytes += generator.row([
            PosColumn(
                width: 5,
                text: Helpers.alignLeftByAddingSpace("Customer No.", width5Length),
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                width: 7,
                text: Helpers.alignLeftByAddingSpace(
                    ": ${currentPrintReceiptDetail?.receiptEntity.customerEntity?.custCode ?? "-"}", width7Length),
                styles: const PosStyles(align: PosAlign.left)),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 5,
                text: Helpers.alignLeftByAddingSpace("Customer Name", width5Length),
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                width: 7,
                text: Helpers.alignLeftByAddingSpace(
                    ": ${currentPrintReceiptDetail?.receiptEntity.customerEntity?.custName ?? "-"}", width7Length),
                styles: const PosStyles(align: PosAlign.left)),
          ]);
        case PrintReceiptContentType.logo:
          final ByteData data =
              // await rootBundle.load('assets/images/logo-topgolf.jpg');
              await rootBundle.load('assets/images/SESA-logo.png');

          final Uint8List imageBytes = data.buffer.asUint8List();
          // decode the bytes into an image
          final decodedImage = img.decodeImage(imageBytes)!;
          bytes += generator.imageRaster(img.copyResize(decodedImage, width: 200), align: PosAlign.center);
          bytes += generator.emptyLines(1);
        default:
          final String text = _convertPrintReceiptContentToText(printReceiptContent, printType);
          if (text == "") break;
          bytes += generator.text(text,
              styles: PosStyles(
                align: printReceiptContent.alignment,
                height: printReceiptContent.fontSize,
                width: printReceiptContent.fontSize,
                bold: printReceiptContent.isBold,
              ));
      }
    } else if (printReceiptContentsRow.length > 1) {
      bytes += generator.row(printReceiptContentsRow
          .map((e) => PosColumn(
              width: 12 ~/ printReceiptContentsRow.length,
              text: e.alignment == PosAlign.right
                  ? Helpers.alignRightByAddingSpace(_convertPrintReceiptContentToText(e, printType), width6Length)
                  : _convertPrintReceiptContentToText(e, printType),
              styles: PosStyles(
                bold: e.isBold,
                height: e.fontSize,
                width: e.fontSize,
                align: PosAlign.left,
              )))
          .toList());
    }

    return bytes;
  }

  PosTextSize _convertFontSizeToPosTextSize(int fontSize) {
    switch (fontSize) {
      case 1:
        return PosTextSize.size1;
      case 2:
        return PosTextSize.size2;
      case 3:
        return PosTextSize.size3;
      case 4:
        return PosTextSize.size4;
      case 5:
        return PosTextSize.size5;
      case 6:
        return PosTextSize.size6;
      case 7:
        return PosTextSize.size7;
      case 8:
        return PosTextSize.size8;
      default:
        return PosTextSize.size1;
    }
  }

  Future<void> printReceipt(PrintReceiptDetail printReceiptDetail, int printType) async {
    List<int> bytes = [];
    final String? paperSize = GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm80
            : paperSize == "58 mm"
                ? PaperSize.mm58
                : PaperSize.mm80,
        profile);
    currentPrintReceiptDetail = printReceiptDetail;

    List<List<PrintReceiptContent>> printReceiptContents = [];
    int currentRow = -1;

    for (int i = 0; i < printReceiptDetail.receiptContentEntities.length; i++) {
      final ReceiptContentEntity receiptContentEntity = printReceiptDetail.receiptContentEntities[i]!;
      final PrintReceiptContent printReceiptContent = PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.values.firstWhere(
            (printReceiptContentType) =>
                printReceiptContentType.toString().toLowerCase().split(".").last ==
                receiptContentEntity.content.toLowerCase(),
            orElse: () => PrintReceiptContentType.none,
          ),
          row: receiptContentEntity.row,
          fontSize: _convertFontSizeToPosTextSize(receiptContentEntity.fontSize),
          isBold: receiptContentEntity.isBold,
          alignment: receiptContentEntity.alignment == 2
              ? PosAlign.right
              : receiptContentEntity.alignment == 1
                  ? PosAlign.center
                  : PosAlign.left,
          customValue: receiptContentEntity.customValue);

      if (printReceiptContent.row != currentRow) {
        printReceiptContents.add([printReceiptContent]);
      } else {
        printReceiptContents.last.add(printReceiptContent);
      }
      currentRow = printReceiptContent.row;
    }

    for (int i = 0; i < printReceiptContents.length; i++) {
      final List<PrintReceiptContent> row = printReceiptContents[i];
      bytes.addAll(await _convertPrintReceiptContentToBytes(row, generator, printType));
    }

    _printEscPos(bytes, generator);
  }

  Future<void> openCashDrawer({PosDrawer pin = PosDrawer.pin2}) async {
    List<int> bytes = [];
    final String? paperSize = GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm58
            : paperSize == "80 mm"
                ? PaperSize.mm80
                : PaperSize.mm58,
        profile);

    bool connectedTCP = false;

    if (GetIt.instance<SharedPreferences>().getStringList("defaultPrinter") != null) {
      final [deviceName, address, port, vendorId, productId, isBle, typePrinter, state] =
          GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")!;

      selectedPrinter = BluetoothPrinter(
        deviceName: deviceName == "null" ? null : deviceName,
        address: address == "null" ? null : address,
        port: port == "null" ? null : port,
        vendorId: vendorId == "null" ? null : vendorId,
        productId: productId == "null" ? null : productId,
        isBle: isBle == "true" ? true : false,
        typePrinter: typePrinter == "PrinterType.bluetooth"
            ? PrinterType.bluetooth
            : typePrinter == "PrinterType.network"
                ? PrinterType.network
                : PrinterType.usb,
        state: state == "null"
            ? null
            : state == "true"
                ? true
                : false,
      );
    }

    if (selectedPrinter == null) return;

    PrinterManager printerManager = PrinterManager.instance;
    BluetoothPrinter bluetoothPrinter = selectedPrinter!;

    bytes += generator.drawer();

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
                name: bluetoothPrinter.deviceName,
                productId: bluetoothPrinter.productId,
                vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(
                name: bluetoothPrinter.deviceName,
                address: bluetoothPrinter.address!,
                isBle: bluetoothPrinter.isBle ?? false,
                autoConnect: _reconnect));
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        connectedTCP = await printerManager.connect(
            type: bluetoothPrinter.typePrinter, model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        if (!connectedTCP) dev.log(' --- please review your connection ---');
        break;
      default:
    }

    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  Future<void> printOpenShift(PrintOpenShiftDetail printOpenShiftDetail, int printType) async {
    List<int> bytes = [];
    final String? paperSize = GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm80
            : paperSize == "58 mm"
                ? PaperSize.mm58
                : PaperSize.mm80,
        profile);

    final int maxLength = GetIt.instance<SharedPreferences>().getInt("charactersPerLine") ?? 42;

    final int width1Length = WidthNLength.getLength(maxLength, 1);
    final int width2Length = WidthNLength.getLength(maxLength, 2);
    final int width3Length = WidthNLength.getLength(maxLength, 3);
    final int width4Length = WidthNLength.getLength(maxLength, 4);
    final int width5Length = WidthNLength.getLength(maxLength, 5);
    final int width6Length = WidthNLength.getLength(maxLength, 6);
    final int width7Length = WidthNLength.getLength(maxLength, 7);
    final int width8Length = WidthNLength.getLength(maxLength, 8);
    final int width9Length = WidthNLength.getLength(maxLength, 9);
    final int width10Length = WidthNLength.getLength(maxLength, 10);
    final int width11Length = WidthNLength.getLength(maxLength, 11);
    final int width12Length = WidthNLength.getLength(maxLength, 12);

    bytes += generator.text('Open Shift Success',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));
    if (printType == 2) {
      bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
      bytes += generator.text("COPY",
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
    } else {
      bytes += generator.emptyLines(1);
    }
    bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Store Name', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(":  ${printOpenShiftDetail.storeMasterEntity.storeName}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Cash Register', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text:
              Helpers.alignLeftByAddingSpace(":  ${printOpenShiftDetail.cashRegisterEntity.description}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Cashier', width4Length),
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(":  ${printOpenShiftDetail.userEntity.username}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Opened At', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.dateddMMMyyyyHHmmss(printOpenShiftDetail.cashierBalanceTransactionEntity.openDate)}",
              width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Opening Balance', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printOpenShiftDetail.cashierBalanceTransactionEntity.openValue)}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);

    _printEscPos(bytes, generator);
  }

  Future<void> printCloseShift(PrintCloseShiftDetail printCloseShiftDetail, int printType) async {
    List<int> bytes = [];
    final String? paperSize = GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm80
            : paperSize == "58 mm"
                ? PaperSize.mm58
                : PaperSize.mm80,
        profile);

    final int maxLength = GetIt.instance<SharedPreferences>().getInt("charactersPerLine") ?? 42;

    final int width1Length = WidthNLength.getLength(maxLength, 1);
    final int width2Length = WidthNLength.getLength(maxLength, 2);
    final int width3Length = WidthNLength.getLength(maxLength, 3);
    final int width4Length = WidthNLength.getLength(maxLength, 4);
    final int width5Length = WidthNLength.getLength(maxLength, 5);
    final int width6Length = WidthNLength.getLength(maxLength, 6);
    final int width7Length = WidthNLength.getLength(maxLength, 7);
    final int width8Length = WidthNLength.getLength(maxLength, 8);
    final int width9Length = WidthNLength.getLength(maxLength, 9);
    final int width10Length = WidthNLength.getLength(maxLength, 10);
    final int width11Length = WidthNLength.getLength(maxLength, 11);
    final int width12Length = WidthNLength.getLength(maxLength, 12);

    printCloseShiftDetail.transactionsTopmt.sort((a, b) {
      return a!.payTypeCode.compareTo(b!.payTypeCode);
    });

    Map<String, List> groupedTransactions = {};
    for (var transaction in printCloseShiftDetail.transactionsMOP) {
      groupedTransactions.putIfAbsent(transaction['paytypecode'], () => []);
      groupedTransactions[transaction['paytypecode']]!.add(transaction);
    }

    bytes += generator.text('Close Shift Success',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));
    if (printType == 2) {
      bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
      bytes += generator.text("COPY",
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
          ));
    } else {
      bytes += generator.emptyLines(1);
    }
    bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Store Name', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(":  ${printCloseShiftDetail.storeMasterEntity.storeName}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Cash Register', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${printCloseShiftDetail.cashRegisterEntity.description}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Cashier', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(":  ${printCloseShiftDetail.userEntity.username}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Opened at', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.dateddMMMyyyyHHmmss(printCloseShiftDetail.cashierBalanceTransactionEntity.openDate)}",
              width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Closed at', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.dateddMMMyyyyHHmmss(printCloseShiftDetail.cashierBalanceTransactionEntity.closeDate)}",
              width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Approved by', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(":  ${printCloseShiftDetail.approverName}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);

    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Opening Balance', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.cashierBalanceTransactionEntity.openValue.round())}",
              width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Total Cash Sales', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.totalCashSales)}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Expected Cash', width5Length),
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.expectedCash)}", width7Length),
          styles: const PosStyles(align: PosAlign.left, bold: true)),
    ]);
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Total Non Cash Sales', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.totalNonCashSales)}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Total Sales', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.totalSales)}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.emptyLines(1);

    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Inv. Count All', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(":  ${printCloseShiftDetail.transactions}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Inv. Count Return', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(":  ${printCloseShiftDetail.transactionsReturn}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
    bytes += generator.text('MOP Details',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ));
    for (PaymentTypeModel? paymentType in printCloseShiftDetail.transactionsTopmt) {
      if (paymentType == null) throw "Failed to retrieve Payment Type";

      String payTypeCode = paymentType.payTypeCode;
      String description = paymentType.description.trim();

      bytes += generator.text(description,
          styles: const PosStyles(
            align: PosAlign.left,
            bold: true,
          ));

      if (groupedTransactions.containsKey(payTypeCode)) {
        for (int i = 0; i < groupedTransactions[payTypeCode]!.length; i++) {
          var transaction = groupedTransactions[payTypeCode]![i];
          String detailDescription = transaction['description']?.trim() ?? "Unknown";
          String amount = Helpers.parseMoney(transaction['amount']);

          bytes += generator.row([
            PosColumn(
              width: 5,
              text: Helpers.alignLeftByAddingSpace(detailDescription, width5Length),
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              width: 7,
              text: Helpers.alignLeftByAddingSpace(":  $amount", width7Length),
              styles: const PosStyles(align: PosAlign.left),
            ),
          ]);
          dev.log("$i ${groupedTransactions[payTypeCode]!.length - 1}");
          if (i != groupedTransactions[payTypeCode]!.length - 1) bytes += generator.emptyLines(1);
        }
      }
    }
    bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Actual Cash', width5Length),
          styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.cashReceived)}", width7Length),
          styles: const PosStyles(align: PosAlign.left, bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: Helpers.alignLeftByAddingSpace('Difference', width5Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 7,
          text: Helpers.alignLeftByAddingSpace(
              ":  ${Helpers.parseMoney(printCloseShiftDetail.difference)}", width7Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);

    _printEscPos(bytes, generator);
  }

  Future<void> printQrisPayment(PrintQrisPaymentDetail printQrisPaymentDetail) async {
    List<int> bytes = [];
    final String? paperSize = GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm80
            : paperSize == "58 mm"
                ? PaperSize.mm58
                : PaperSize.mm80,
        profile);

    final int maxLength = GetIt.instance<SharedPreferences>().getInt("charactersPerLine") ?? 42;

    final int width1Length = WidthNLength.getLength(maxLength, 1);
    final int width2Length = WidthNLength.getLength(maxLength, 2);
    final int width3Length = WidthNLength.getLength(maxLength, 3);
    final int width4Length = WidthNLength.getLength(maxLength, 4);
    final int width5Length = WidthNLength.getLength(maxLength, 5);
    final int width6Length = WidthNLength.getLength(maxLength, 6);
    final int width7Length = WidthNLength.getLength(maxLength, 7);
    final int width8Length = WidthNLength.getLength(maxLength, 8);
    final int width9Length = WidthNLength.getLength(maxLength, 9);
    final int width10Length = WidthNLength.getLength(maxLength, 10);
    final int width11Length = WidthNLength.getLength(maxLength, 11);
    final int width12Length = WidthNLength.getLength(maxLength, 12);

    bytes += generator.text('QRIS Payment',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));
    bytes += generator.emptyLines(1);
    bytes += generator.text(List.generate(width12Length, (_) => "-").join(""));

    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Total Payment', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(":  ${printQrisPaymentDetail.totalPayment}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Expired at', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(":  ${printQrisPaymentDetail.expiredTime}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('NMID', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(":  ${printQrisPaymentDetail.nmid}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: Helpers.alignLeftByAddingSpace('Terminal ID', width4Length),
          styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
          width: 8,
          text: Helpers.alignLeftByAddingSpace(":  ${printQrisPaymentDetail.terminalId}", width8Length),
          styles: const PosStyles(align: PosAlign.left)),
    ]);
    bytes += generator.emptyLines(1);

    // Handle QRIS image
    img.Image decodedImage = img.copyResize(img.decodeImage(printQrisPaymentDetail.qrImage)!,
        width: maxLength == 48 ? 560 : 480, interpolation: img.Interpolation.cubic);

    bytes += generator.feed(1);
    bytes += generator.imageRaster(decodedImage, align: PosAlign.left);
    bytes += generator.feed(1);

    _printEscPos(bytes, generator);
  }

  void _printEscPos(List<int> bytes, Generator generator) async {
    bool connectedTCP = false;

    if (GetIt.instance<SharedPreferences>().getStringList("defaultPrinter") != null) {
      final [deviceName, address, port, vendorId, productId, isBle, typePrinter, state] =
          GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")!;

      selectedPrinter = BluetoothPrinter(
        deviceName: deviceName == "null" ? null : deviceName,
        address: address == "null" ? null : address,
        port: port == "null" ? null : port,
        vendorId: vendorId == "null" ? null : vendorId,
        productId: productId == "null" ? null : productId,
        isBle: isBle == "true" ? true : false,
        typePrinter: typePrinter == "PrinterType.bluetooth"
            ? PrinterType.bluetooth
            : typePrinter == "PrinterType.network"
                ? PrinterType.network
                : PrinterType.usb,
        state: state == "null"
            ? null
            : state == "true"
                ? true
                : false,
      );
    }

    if (selectedPrinter == null) return;

    PrinterManager printerManager = PrinterManager.instance;
    BluetoothPrinter bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
                name: bluetoothPrinter.deviceName,
                productId: bluetoothPrinter.productId,
                vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(
                name: bluetoothPrinter.deviceName,
                address: bluetoothPrinter.address!,
                isBle: bluetoothPrinter.isBle ?? false,
                autoConnect: _reconnect));
        pendingTask = null;
        // if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        connectedTCP = await printerManager.connect(
            type: bluetoothPrinter.typePrinter, model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        if (!connectedTCP) dev.log(' --- please review your connection ---');
        pendingTask = null;
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth && Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter(
      {this.deviceName,
      this.address,
      this.port,
      this.state,
      this.vendorId,
      this.productId,
      this.typePrinter = PrinterType.bluetooth,
      this.isBle = false});
}

class PrintReceiptContent {
  final PrintReceiptContentType printReceiptContentType;
  final PosTextSize fontSize;
  final bool isBold;
  final PosAlign alignment;
  final int row;
  final String? customValue;

  PrintReceiptContent({
    required this.printReceiptContentType,
    this.fontSize = PosTextSize.size1,
    this.isBold = false,
    this.alignment = PosAlign.left,
    required this.row,
    this.customValue,
  });

  @override
  String toString() {
    return 'PrintReceiptContent(printReceiptContentType: $printReceiptContentType, fontSize: $fontSize, isBold: $isBold, alignment: $alignment, row: $row, customValue: $customValue)';
  }
}

enum PrintReceiptContentType {
  none,
  emptyLine,
  horizontalLine,

  logo,
  storeName,

  date,
  time,
  datetime,
  docNum,
  docNumAndDatetime,
  employeeCodeAndName,
  cashRegister,
  customer,

  mopAlias,

  address1,
  address2,
  address3,
  city,

  items,
  totalPrice,
  taxDetails,
  totalQty,
  receiptBarcode,

  customRow1,
  customRow2,
  customRow3,
  customRow4,
  customRow5,
  customRow6,
  customRow7,
  customRow8,
  customRow9,
  customRow10,

  header01,
  header02,
  header03,
  header04,
  header05,

  footer01,
  footer02,
  footer03,
  footer04,
  footer05,

  draftWatermarkTop,
  draftWatermarkBottom,

  copyWatermarkTop,
  copyWatermarkBottom,
}

/// Draw the image [src] onto the image [dst].
///
/// In other words, drawImage will take an rectangular area from src of
/// width [src_w] and height [src_h] at position ([src_x],[src_y]) and place it
/// in a rectangular area of [dst] of width [dst_w] and height [dst_h] at
/// position ([dst_x],[dst_y]).
///
/// If the source and destination coordinates and width and heights differ,
/// appropriate stretching or shrinking of the image fragment will be performed.
/// The coordinates refer to the upper left corner. This function can be used to
/// copy regions within the same image (if [dst] is the same as [src])
/// but if the regions overlap the results will be unpredictable.
img.Image drawImage(img.Image dst, img.Image src,
    {int? dstX, int? dstY, int? dstW, int? dstH, int? srcX, int? srcY, int? srcW, int? srcH, bool blend = true}) {
  dstX ??= 0;
  dstY ??= 0;
  srcX ??= 0;
  srcY ??= 0;
  srcW ??= src.width;
  srcH ??= src.height;
  dstW ??= (dst.width < src.width) ? dstW = dst.width : src.width;
  dstH ??= (dst.height < src.height) ? dst.height : src.height;

  if (blend) {
    for (var y = 0; y < dstH; ++y) {
      for (var x = 0; x < dstW; ++x) {
        final stepX = (x * (srcW / dstW)).toInt();
        final stepY = (y * (srcH / dstH)).toInt();
        final srcPixel = src.getPixel(srcX + stepX, srcY + stepY);
        img.drawPixel(dst, dstX + x, dstY + y, srcPixel);
      }
    }
  } else {
    for (var y = 0; y < dstH; ++y) {
      for (var x = 0; x < dstW; ++x) {
        final stepX = (x * (srcW / dstW)).toInt();
        final stepY = (y * (srcH / dstH)).toInt();
        final srcPixel = src.getPixel(srcX + stepX, srcY + stepY);
        dst.setPixel(dstX + x, dstY + y, srcPixel);
      }
    }
  }

  return dst;
}

class WidthNLength {
  static int getLength(int maxLength, int width) {
    switch (maxLength) {
      case 48:
        switch (width) {
          case 1:
            return 3;
          case 2:
          case 3:
            return 11;
          case 4:
            return 15;
          case 5:
            return 19;
          case 6:
            return 23;
          case 7:
            return 27;
          case 8:
          case 9:
          case 10:
            return 31;
          case 11:
            return 42;
          case 12:
          default:
            return 48;
        }
      case 42:
      default:
        switch (width) {
          case 1:
          case 2:
            return 3;
          case 3:
            return 10;
          case 4:
            return 11;
          case 5:
            return 15;
          case 6:
            return 19;
          case 7:
            return 23;
          case 8:
          case 9:
          case 10:
            return 27;
          case 11:
            return 38;
          case 12:
          default:
            return 42;
        }
    }
  }
}
