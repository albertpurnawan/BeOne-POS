// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/print_receipt_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

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
      PrintReceiptContent printReceiptContent) {
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
        return DateFormat('yyyy-MM-dd - hh:mm aaa')
            .format(currentPrintReceiptDetail!.receiptEntity.transDateTime!);
      case PrintReceiptContentType.docNum:
        return currentPrintReceiptDetail?.receiptEntity.docNum ?? "";
      case PrintReceiptContentType.employeeCodeAndName:
        // return "";
        return "${currentPrintReceiptDetail?.receiptEntity.employeeEntity?.empCode} - ${currentPrintReceiptDetail?.receiptEntity.employeeEntity?.empName}";
      case PrintReceiptContentType.mopAlias:
        return currentPrintReceiptDetail
                ?.receiptEntity.mopSelection?.mopAlias ??
            "";
      case PrintReceiptContentType.address1:
        return currentPrintReceiptDetail?.storeMasterEntity.addr1 ?? "";
      case PrintReceiptContentType.address2:
        return currentPrintReceiptDetail?.storeMasterEntity.addr2 ?? "";
      case PrintReceiptContentType.address3:
        return currentPrintReceiptDetail?.storeMasterEntity.addr3 ?? "";
      case PrintReceiptContentType.city:
        return currentPrintReceiptDetail?.storeMasterEntity.city ?? "";
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
      List<PrintReceiptContent> printReceiptContentsRow, Generator generator) {
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
            bytes += generator.text(
                "${Helpers.cleanDecimal(item.quantity, 3)}x${Helpers.parseMoney(item.itemEntity.dpp)} ${item.itemEntity.itemName}");
            bytes += generator.row([
              PosColumn(
                  width: 8,
                  text:
                      "   ${item.itemEntity.barcode} ${item.itemEntity.itemName}",
                  styles: PosStyles(
                    align: PosAlign.left,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                    bold: printReceiptContent.isBold,
                    // codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 4,
                  text: Helpers.parseMoney(item.totalGross),
                  styles: PosStyles(
                    align: PosAlign.right,
                    height: printReceiptContent.fontSize,
                    width: printReceiptContent.fontSize,
                    bold: printReceiptContent.isBold,
                    // codeTable: 'CP1252',
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
                  // codeTable: 'CP1252',
                )),
            PosColumn(
                width: 8,
                text: Helpers.parseMoney(
                    currentPrintReceiptDetail!.receiptEntity.grandTotal),
                styles: PosStyles(
                  align: PosAlign.right,
                  height: printReceiptContent.fontSize,
                  width: printReceiptContent.fontSize,
                  bold: printReceiptContent.isBold,
                  // codeTable: 'CP1252',
                )),
          ]);
        case PrintReceiptContentType.taxDetails:
          bytes += generator.row([
            PosColumn(
                width: 8,
                text: "Tax Amount",
                styles: const PosStyles(
                  align: PosAlign.left,
                  // codeTable: 'CP1252',
                )),
            PosColumn(
                width: 4,
                text: Helpers.parseMoney(
                    currentPrintReceiptDetail!.receiptEntity.taxAmount),
                styles: const PosStyles(
                  align: PosAlign.right,
                  // codeTable: 'CP1252',
                )),
          ]);
        case PrintReceiptContentType.totalQty:
          bytes += generator.text(
              'Total Qty. : ${currentPrintReceiptDetail!.receiptEntity.receiptItems.map((e) => e.quantity).reduce((value, element) => value + element).toString()}',
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
        case PrintReceiptContentType.logo:
        default:
          bytes += generator.text(
              _convertPrintReceiptContentToText(printReceiptContent),
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
              text: _convertPrintReceiptContentToText(e),
              styles: PosStyles(
                bold: e.isBold,
                height: e.fontSize,
                width: e.fontSize,
                align: e.alignment,
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

  Future<void> printReceipt(PrintReceiptDetail printReceiptDetail) async {
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
      bytes.addAll(_convertPrintReceiptContentToBytes(row, generator));
    }

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
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        connectedTCP = await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        if (!connectedTCP) print(' --- please review your connection ---');
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
}
