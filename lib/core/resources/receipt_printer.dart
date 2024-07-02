// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/print_receipt_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_open_shift.dart';
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
  bool _reconnect = true;
  BTStatus _currentStatus = BTStatus.none;
  PrintReceiptDetail? currentPrintReceiptDetail;

  ReceiptPrinter._init();

  static Future<ReceiptPrinter> init() async {
    final receiptPrinter = ReceiptPrinter._init();

    if (GetIt.instance<SharedPreferences>().getStringList("defaultPrinter") !=
        null) {
      final [
        deviceName,
        address,
        port,
        vendorId,
        productId,
        isBle,
        typePrinter,
        state
      ] = GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")!;

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

  String _convertPrintReceiptContentToText(
      PrintReceiptContent printReceiptContent, bool isDraft) {
    switch (printReceiptContent.printReceiptContentType) {
      case PrintReceiptContentType.storeName:
        return currentPrintReceiptDetail?.storeMasterEntity.storeName ?? "";
      case PrintReceiptContentType.date:
        return DateFormat('yyyy-MM-dd')
            .format(currentPrintReceiptDetail!.receiptEntity.transDateTime!);
      case PrintReceiptContentType.time:
        return DateFormat('hh:mm aaa')
            .format(currentPrintReceiptDetail!.receiptEntity.transDateTime!);
      case PrintReceiptContentType.datetime:
        return DateFormat('yyyy-MM-dd hh:mm aaa').format(isDraft
            ? DateTime.now()
            : currentPrintReceiptDetail!.receiptEntity.transDateTime!);
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
      case PrintReceiptContentType.footer01:
        return currentPrintReceiptDetail?.storeMasterEntity.footer01
                ?.replaceAll("\\n", "\n") ??
            "";
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

  List<int> _convertPrintReceiptContentToBytes(
      List<PrintReceiptContent> printReceiptContentsRow,
      Generator generator,
      bool isDraft) {
    List<int> bytes = [];

    if (printReceiptContentsRow.length == 1) {
      final PrintReceiptContent printReceiptContent =
          printReceiptContentsRow.first;
      switch (printReceiptContentsRow[0].printReceiptContentType) {
        case PrintReceiptContentType.emptyLine:
          bytes += generator.emptyLines(1);
        case PrintReceiptContentType.horizontalLine:
          bytes += generator.hr();
        case PrintReceiptContentType.items:
          for (final item
              in currentPrintReceiptDetail!.receiptEntity.receiptItems) {
            bytes += generator.row([
              PosColumn(
                  width: 5,
                  text: Helpers.clipStringAndAddEllipsis(
                      "${item.promos.isEmpty ? "" : "*"}${item.itemEntity.itemName}",
                      35),
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                    bold: printReceiptContent.isBold,
                    codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 1,
                  text: Helpers.alignRightByAddingSpace(
                      Helpers.cleanDecimal(item.quantity, 3), 3),
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                    bold: printReceiptContent.isBold,
                    codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 3,
                  text: Helpers.alignRightByAddingSpace(
                      Helpers.parseMoney(item.itemEntity.price.round()), 10),
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                    bold: printReceiptContent.isBold,
                    codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 3,
                  text: Helpers.alignRightByAddingSpace(
                      Helpers.parseMoney(item.totalAmount.round()), 11),
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                    bold: printReceiptContent.isBold,
                    codeTable: 'CP1252',
                  )),
            ]);
          }
        case PrintReceiptContentType.totalPrice:
          bytes += generator.row([
            PosColumn(
                width: 4,
                text: "Total",
                styles: PosStyles(
                  align: PosAlign.left,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 8,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!
                        .receiptEntity.grandTotal
                        .round()),
                    15),
                styles: PosStyles(
                  align: PosAlign.left,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                  codeTable: 'CP1252',
                )),
          ]);
        case PrintReceiptContentType.taxDetails:
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Total Gross",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!
                        .receiptEntity.subtotal
                        .round()),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Promotions Discount",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    "(${Helpers.parseMoney(((currentPrintReceiptDetail!.receiptEntity.discAmount ?? 0) - (currentPrintReceiptDetail!.receiptEntity.discHeaderManual ?? 0)).round())})",
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Subtotal",
                styles: const PosStyles(
                  align: PosAlign.left,
                  bold: true,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(
                        (currentPrintReceiptDetail!.receiptEntity.subtotal -
                                (currentPrintReceiptDetail!
                                        .receiptEntity.discAmount ??
                                    0) +
                                (currentPrintReceiptDetail!
                                        .receiptEntity.discHeaderManual ??
                                    0))
                            .round()),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  bold: true,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.emptyLines(1);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Header Discount",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    "(${Helpers.parseMoney(currentPrintReceiptDetail!.receiptEntity.discHeaderManual != null ? currentPrintReceiptDetail!.receiptEntity.discHeaderManual!.round() : 0)})",
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Tax Amount",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!
                        .receiptEntity.taxAmount
                        .round()),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Rounding",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(currentPrintReceiptDetail!
                        .receiptEntity.rounding
                        .round()),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);

          bytes += generator.emptyLines(1);
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
          bytes += generator.qrcode(
              currentPrintReceiptDetail!.receiptEntity.docNum,
              size: QRSize.Size6);
        case PrintReceiptContentType.mopAlias:
          for (final MopSelectionEntity mopSelection
              in currentPrintReceiptDetail!.receiptEntity.mopSelections) {
            bytes += generator.row([
              PosColumn(
                  width: 8,
                  text: mopSelection.mopAlias,
                  styles: const PosStyles(
                    align: PosAlign.left,
                    codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 4,
                  text: Helpers.alignRightByAddingSpace(
                      Helpers.parseMoney(mopSelection.amount ?? 0), 15),
                  styles: const PosStyles(
                    align: PosAlign.left,
                    codeTable: 'CP1252',
                  )),
            ]);
          }
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Vouchers",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(
                        currentPrintReceiptDetail!.receiptEntity.totalVoucher ??
                            0),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Total Payment",
                styles: const PosStyles(
                  align: PosAlign.left,
                  bold: true,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(
                        currentPrintReceiptDetail!.receiptEntity.totalPayment ??
                            0),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  bold: true,
                  codeTable: 'CP1252',
                )),
          ]);
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Change",
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.alignRightByAddingSpace(
                    Helpers.parseMoney(
                        currentPrintReceiptDetail!.receiptEntity.changed ?? 0),
                    15),
                styles: const PosStyles(
                  align: PosAlign.left,
                  codeTable: 'CP1252',
                )),
          ]);
        case PrintReceiptContentType.draftWatermarkTop:
          if (isDraft == false) break;
          bytes += generator.hr();
          bytes += generator.text("DRAFT BILL",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
          bytes += generator.hr();
        case PrintReceiptContentType.draftWatermarkBottom:
          if (isDraft == false) break;
          bytes += generator.text("DRAFT BILL",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
          bytes += generator.hr();
        case PrintReceiptContentType.logo:
        default:
          final String text =
              _convertPrintReceiptContentToText(printReceiptContent, isDraft);
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
                  ? Helpers.alignRightByAddingSpace(
                      _convertPrintReceiptContentToText(e, isDraft), 23)
                  : _convertPrintReceiptContentToText(e, isDraft),
              styles: PosStyles(
                codeTable: 'CP1252',
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

  Future<void> printReceipt(
      PrintReceiptDetail printReceiptDetail, bool isDraft) async {
    List<int> bytes = [];
    final String? paperSize =
        GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm58
            : paperSize == "80 mm"
                ? PaperSize.mm80
                : PaperSize.mm58,
        profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    currentPrintReceiptDetail = printReceiptDetail;

    List<List<PrintReceiptContent>> printReceiptContents = [];
    int currentRow = -1;

    for (int i = 0; i < printReceiptDetail.receiptContentEntities.length; i++) {
      final ReceiptContentEntity receiptContentEntity =
          printReceiptDetail.receiptContentEntities[i]!;
      final PrintReceiptContent printReceiptContent = PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.values.firstWhere(
            (printReceiptContentType) =>
                printReceiptContentType
                    .toString()
                    .toLowerCase()
                    .split(".")
                    .last ==
                receiptContentEntity.content.toLowerCase(),
            orElse: () => PrintReceiptContentType.none,
          ),
          row: receiptContentEntity.row,
          fontSize:
              _convertFontSizeToPosTextSize(receiptContentEntity.fontSize),
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
      bytes.addAll(_convertPrintReceiptContentToBytes(row, generator, isDraft));
    }

    _printEscPos(bytes, generator);
  }

  Future<void> openCashDrawer({PosDrawer pin = PosDrawer.pin2}) async {
    List<int> bytes = [];
    final String? paperSize =
        GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm58
            : paperSize == "80 mm"
                ? PaperSize.mm80
                : PaperSize.mm58,
        profile);

    bool connectedTCP = false;

    if (GetIt.instance<SharedPreferences>().getStringList("defaultPrinter") !=
        null) {
      final [
        deviceName,
        address,
        port,
        vendorId,
        productId,
        isBle,
        typePrinter,
        state
      ] = GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")!;

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
            type: bluetoothPrinter.typePrinter,
            model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        if (!connectedTCP) log(' --- please review your connection ---');
        break;
      default:
    }

    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  Future<void> printOpenShift(PrintOpenShiftDetail printOpenShiftDetail) async {
    List<int> bytes = [];
    final String? paperSize =
        GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm58
            : paperSize == "80 mm"
                ? PaperSize.mm80
                : PaperSize.mm58,
        profile);

    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Open Shift Success',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));
    bytes += generator.emptyLines(1);
    bytes += generator.hr();
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'Store Name',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 8,
          text: ":  ${printOpenShiftDetail.storeMasterEntity.storeName}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'Cash Register',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 8,
          text: ":  ${printOpenShiftDetail.cashRegisterEntity.description}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'Cashier',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 8,
          text: ":  ${printOpenShiftDetail.userEntity.username}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'Opened At',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 8,
          text:
              ":  ${Helpers.dateddMMMyyyyHHmmss(printOpenShiftDetail.cashierBalanceTransactionEntity.openDate)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 4,
          text: 'Opening Balance',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 8,
          text:
              ":  ${Helpers.parseMoney(printOpenShiftDetail.cashierBalanceTransactionEntity.openValue)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);

    _printEscPos(bytes, generator);
  }

  Future<void> printCloseShift(
      PrintCloseShiftDetail printCloseShiftDetail) async {
    List<int> bytes = [];
    final String? paperSize =
        GetIt.instance<SharedPreferences>().getString("paperSize");
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        paperSize == null
            ? PaperSize.mm58
            : paperSize == "80 mm"
                ? PaperSize.mm80
                : PaperSize.mm58,
        profile);

    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Close Shift Success',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          bold: true,
        ));
    bytes += generator.emptyLines(1);
    bytes += generator.hr();
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Store Name',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text: ":  ${printCloseShiftDetail.storeMasterEntity.storeName}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Cash Register',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text: ":  ${printCloseShiftDetail.cashRegisterEntity.description}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Cashier',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text: ":  ${printCloseShiftDetail.userEntity.username}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Opened at',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text:
              ":  ${Helpers.dateddMMMyyyyHHmmss(printCloseShiftDetail.cashierBalanceTransactionEntity.openDate)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Closed at',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text:
              ":  ${Helpers.dateddMMMyyyyHHmmss(printCloseShiftDetail.cashierBalanceTransactionEntity.closeDate)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Approved by',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text: ":  ${printCloseShiftDetail.approverName}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);

    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Opening Balance',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text:
              ":  ${Helpers.parseMoney(printCloseShiftDetail.cashierBalanceTransactionEntity.openValue.round())}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Total Cash Sales',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text:
              ":  ${Helpers.parseMoney(printCloseShiftDetail.totalCashSales)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Expected Cash',
          styles: const PosStyles(
              align: PosAlign.left, codeTable: 'CP1252', bold: true)),
      PosColumn(
          width: 7,
          text: ":  ${Helpers.parseMoney(printCloseShiftDetail.expectedCash)}",
          styles: const PosStyles(
              align: PosAlign.left, codeTable: 'CP1252', bold: true)),
    ]);
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Total Non Cash Sales',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text:
              ":  ${Helpers.parseMoney(printCloseShiftDetail.totalNonCashSales)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Total Sales',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text: ":  ${Helpers.parseMoney(printCloseShiftDetail.totalSales)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);
    bytes += generator.emptyLines(1);

    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Actual Cash',
          styles: const PosStyles(
              align: PosAlign.left, codeTable: 'CP1252', bold: true)),
      PosColumn(
          width: 7,
          text: ":  ${Helpers.parseMoney(printCloseShiftDetail.cashReceived)}",
          styles: const PosStyles(
              align: PosAlign.left, codeTable: 'CP1252', bold: true)),
    ]);
    bytes += generator.row([
      PosColumn(
          width: 5,
          text: 'Difference',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 7,
          text: ":  ${Helpers.parseMoney(printCloseShiftDetail.difference)}",
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
    ]);

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    bool connectedTCP = false;

    if (GetIt.instance<SharedPreferences>().getStringList("defaultPrinter") !=
        null) {
      final [
        deviceName,
        address,
        port,
        vendorId,
        productId,
        isBle,
        typePrinter,
        state
      ] = GetIt.instance<SharedPreferences>().getStringList("defaultPrinter")!;

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
            type: bluetoothPrinter.typePrinter,
            model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        if (!connectedTCP) log(' --- please review your connection ---');
        pendingTask = null;
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
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
  employeeCodeAndName,

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

  footer01,

  draftWatermarkTop,
  draftWatermarkBottom,
}
