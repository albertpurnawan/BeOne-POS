// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';

class ReceiptPrinter {
  BluetoothPrinter? selectedPrinter = BluetoothPrinter(
      deviceName: "192.168.1.249:9100",
      address: "192.168.1.249",
      typePrinter: PrinterType.network);
  List<int>? pendingTask;
  bool _reconnect = true;
  BTStatus _currentStatus = BTStatus.none;

  ReceiptPrinter();

  Future printReceiveTest(ReceiptEntity receiptEntity) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final List<List<PrintReceiptContent>> printReceiptContents = [
      [
        PrintReceiptContent(
            printReceiptContentType: PrintReceiptContentType.customRow1,
            order: 1,
            fontSize: 2,
            alignment: PosAlign.center,
            customText: "Testmart")
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.emptyLine,
          order: 2,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.docNum,
          order: 3,
        )
      ],
      // [
      //   PrintReceiptContent(
      //       printReceiptContentType:
      //           PrintReceiptContentType.employeeCodeAndName,
      //       order: 4,
      //       alignment: PosAlign.left),
      //   PrintReceiptContent(
      //     printReceiptContentType: PrintReceiptContentType.datetime,
      //     order: 4,
      //     alignment: PosAlign.right,
      //   )
      // ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.horizontalLine,
          order: 5,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.emptyLine,
          order: 6,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.items,
          order: 7,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.emptyLine,
          order: 8,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.totalPrice,
          order: 9,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.taxDetails,
          order: 10,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.emptyLine,
          order: 11,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.totalQty,
          order: 12,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.emptyLine,
          order: 13,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.mopAlias,
          order: 14,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.customRow2,
          order: 15,
          customText: "Belanja dari Rumah via",
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.customRow3,
          order: 16,
          customText: "waonline.testmart.co.id",
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.customRow4,
          order: 17,
          customText: "Untuk informasi dan saran, hubungi",
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.customRow5,
          order: 18,
          customText: "IG @testmart.id - WA 0810 0000 0000",
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.customRow6,
          order: 19,
          customText: "PT TESTMART JAYA",
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.customRow7,
          order: 20,
          customText: "NPWP: 13.000.000.8-888.888",
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.address1,
          order: 21,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.address2,
          order: 22,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.address3,
          order: 23,
        )
      ],
      [
        PrintReceiptContent(
          printReceiptContentType: PrintReceiptContentType.receiptBarcode,
          order: 24,
        )
      ],
    ];

    for (int i = 0; i < printReceiptContents.length; i++) {
      final List<PrintReceiptContent> row = printReceiptContents[i];

      for (int j = 0; j < row.length; j++) {
        switch (row[0].printReceiptContentType) {
          case PrintReceiptContentType.emptyLine:
            bytes += generator.emptyLines(1);
          case PrintReceiptContentType.horizontalLine:
            bytes += generator.hr();
          case PrintReceiptContentType.logo:
            continue;
          case PrintReceiptContentType.storeName:
            continue;
          case PrintReceiptContentType.date:
            bytes += generator.text(
                DateFormat('yyyy-MM-dd').format(receiptEntity.createdAt!));
          case PrintReceiptContentType.time:
            bytes += generator
                .text(DateFormat('hh:mm aaa').format(receiptEntity.createdAt!));
          case PrintReceiptContentType.datetime:
            bytes += generator.text(DateFormat('yyyy-MM-dd - hh:mm aaa')
                .format(receiptEntity.createdAt!));
          case PrintReceiptContentType.docNum:
            bytes += generator.text(receiptEntity.docNum);
          case PrintReceiptContentType.employeeCodeAndName:
            continue;
          case PrintReceiptContentType.mopAlias:
            bytes += generator.text(receiptEntity.mopSelection!.mopAlias);
          case PrintReceiptContentType.address1:
            bytes += generator.text("Test Business Park Lt. 8");
          case PrintReceiptContentType.address2:
            bytes += generator.text("Jl. Jend. Test Kav. 88");
          case PrintReceiptContentType.address3:
            bytes += generator.text("");
          case PrintReceiptContentType.city:
            bytes += generator.text("Jakarta");
          case PrintReceiptContentType.items:
            for (final item in receiptEntity.receiptItems) {
              bytes += generator.text(
                  "${item.quantity}x${item.itemEntity.price} ${item.itemEntity.itemName}");
              bytes += generator.row([
                PosColumn(
                    width: 8,
                    text:
                        "   ${item.itemEntity.barcode} ${item.itemEntity.itemName}",
                    styles: const PosStyles(
                      align: PosAlign.left,
                      // codeTable: 'CP1252',
                    )),
                PosColumn(
                    width: 4,
                    text: '${item.subtotal}',
                    styles: const PosStyles(
                      align: PosAlign.right,
                      // codeTable: 'CP1252',
                    )),
              ]);
            }
          case PrintReceiptContentType.totalPrice:
            bytes += generator.row([
              PosColumn(
                  width: 4,
                  text: "Total",
                  styles: const PosStyles(
                    bold: true,
                    height: PosTextSize.size2,
                    width: PosTextSize.size2,
                    align: PosAlign.left,
                    // codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 8,
                  text: Helpers.parseMoney(receiptEntity.totalPrice),
                  styles: const PosStyles(
                    bold: true,
                    height: PosTextSize.size2,
                    width: PosTextSize.size2,
                    align: PosAlign.right,
                    // codeTable: 'CP1252',
                  )),
            ]);
          case PrintReceiptContentType.taxDetails:
            bytes += generator.row([
              PosColumn(
                  width: 8,
                  text: "Net Sales - Non Taxable",
                  styles: const PosStyles(
                    align: PosAlign.left,
                    // codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 4,
                  text: 'Rp 0',
                  styles: const PosStyles(
                    align: PosAlign.right,
                    // codeTable: 'CP1252',
                  )),
            ]);
            bytes += generator.row([
              PosColumn(
                  width: 8,
                  text: "Net Sales - Tax Base",
                  styles: const PosStyles(
                    align: PosAlign.left,
                    // codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 4,
                  text: 'Rp 6,216',
                  styles: const PosStyles(
                    align: PosAlign.right,
                    // codeTable: 'CP1252',
                  )),
            ]);
            bytes += generator.row([
              PosColumn(
                  width: 8,
                  text: "PPN 11%",
                  styles: const PosStyles(
                    align: PosAlign.left,
                    // codeTable: 'CP1252',
                  )),
              PosColumn(
                  width: 4,
                  text: 'Rp 684',
                  styles: const PosStyles(
                    align: PosAlign.right,
                    // codeTable: 'CP1252',
                  )),
            ]);
          case PrintReceiptContentType.totalQty:
            bytes += generator.text(
                'Total Qty. : ${receiptEntity.receiptItems.map((e) => e.quantity).reduce((value, element) => value + element).toString()}',
                styles: const PosStyles(
                  bold: true,
                  height: PosTextSize.size2,
                  width: PosTextSize.size2,
                  align: PosAlign.left,
                ));
          case PrintReceiptContentType.receiptBarcode:
            final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
            bytes += generator.barcode(Barcode.upcA(barData));
          case PrintReceiptContentType.customRow1:
            bytes += generator.text("Testmart");
          case PrintReceiptContentType.customRow2:
            bytes += generator.text("Belanja dari Rumah via");
          case PrintReceiptContentType.customRow3:
            bytes += generator.text("waonline.testmart.co.id");
          case PrintReceiptContentType.customRow4:
            bytes += generator.text("Untuk Informasi dan Saran, Hubungi");
          case PrintReceiptContentType.customRow5:
            bytes += generator.text('IG @testmart.id - WA 0810 0000 0000');
          case PrintReceiptContentType.customRow6:
            bytes += generator.text('PT TESTMART JAYA');
          case PrintReceiptContentType.customRow7:
            bytes += generator.text('NPWP: 13.000.000.8-888.888');
          case PrintReceiptContentType.customRow8:
            continue;
          case PrintReceiptContentType.customRow9:
            continue;
          case PrintReceiptContentType.customRow10:
            continue;
          default:
            continue;
        }
      }
    }

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    bool connectedTCP = false;

    PrinterManager printerManager = PrinterManager.instance;
    if (selectedPrinter == null) return;
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
  final int fontSize;
  final bool isBold;
  final PosAlign alignment;
  final int order;
  final String? customText;

  PrintReceiptContent({
    required this.printReceiptContentType,
    this.fontSize = 1,
    this.isBold = false,
    this.alignment = PosAlign.left,
    required this.order,
    this.customText,
  });
}

enum PrintReceiptContentType {
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
