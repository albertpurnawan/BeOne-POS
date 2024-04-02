import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thermal_printer/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:thermal_printer/thermal_printer.dart';

class DefaultPrinterSettings extends StatefulWidget {
  const DefaultPrinterSettings({Key? key}) : super(key: key);

  @override
  State<DefaultPrinterSettings> createState() => _DefaultPrinterSettingsState();
}

class _DefaultPrinterSettingsState extends State<DefaultPrinterSettings> {
  // Printer Type [bluetooth, usb, network]
  var defaultPrinterType = PrinterType.bluetooth;
  var _isBle = false;
  var _reconnect = false;
  var _isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <BluetoothPrinter>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  StreamSubscription<TCPStatus>? _subscriptionTCPStatus;
  BTStatus _currentStatus = BTStatus.none;
  // ignore: unused_field
  TCPStatus _currentTCPStatus = TCPStatus.none;
  // _currentUsbStatus is only supports on Android
  // ignore: unused_field
  USBStatus _currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  BluetoothPrinter? selectedPrinter;

  @override
  void initState() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();

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
    _portController.text = _port;
    _scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus =
        PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;
      if (status == BTStatus.connected) {
        setState(() {
          _isConnected = true;
        });
      }
      if (status == BTStatus.none) {
        setState(() {
          _isConnected = false;
        });
      }
      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance
                .send(type: PrinterType.bluetooth, bytes: pendingTask!);
            pendingTask = null;
          });
        } else if (Platform.isIOS) {
          PrinterManager.instance
              .send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        }
      }
    });
    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance
                .send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });

    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionTCPStatus = PrinterManager.instance.stateTCP.listen((status) {
      log(' ----------------- status tcp $status ------------------ ');
      _currentTCPStatus = status;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _subscriptionTCPStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void _scan() {
    devices.clear();
    _subscription = printerManager
        .discovery(type: defaultPrinterType, isBle: _isBle)
        .listen((device) {
      devices.add(BluetoothPrinter(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
      setState(() {});
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = BluetoothPrinter(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance
            .disconnect(type: selectedPrinter!.typePrinter);
      }
    }

    setState(() {
      selectedPrinter = device;
    });
  }

  void _setDeviceAsDefault() {
    final BluetoothPrinter? device = selectedPrinter;
    if (device == null) return;

    /**
     * Urutan info printer di list default printer
     * 0 deviceName
     * 1 address
     * 2 port
     * 3 vendorId
     * 4 productId
     * 5 isBle
     * 6 typePrinter
     * 7 state
     */
    GetIt.instance<SharedPreferences>().setStringList("defaultPrinter", [
      device.deviceName ?? "null",
      device.address ?? "null",
      device.port ?? "null",
      device.vendorId ?? "null",
      device.productId ?? "null",
      device.isBle.toString(),
      device.typePrinter.toString(),
      device.state?.toString() ?? "null",
    ]);
    GetIt.instance<ReceiptPrinter>().selectedPrinter = device;
    setState(() {});
  }

  Future _printReceiveTest() async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');

    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Test Print',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Product 1');
    bytes += generator.text('Product 2');

    // bytes += generator.text('￥1,990', containsChinese: true, styles: const PosStyles(align: PosAlign.left));
    // bytes += generator.emptyLines(1);

    // sum width total column must be 12
    bytes += generator.row([
      PosColumn(
          width: 8,
          text: 'Lemon lime export quality per pound x 5 units',
          styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
      PosColumn(
          width: 4,
          text: 'USD 2.00',
          styles: const PosStyles(align: PosAlign.right, codeTable: 'CP1252')),
    ]);

    // final ByteData data = await rootBundle.load('assets/ic_launcher.png');
    // if (data.lengthInBytes > 0) {
    //   final Uint8List imageBytes = data.buffer.asUint8List();
    //   // decode the bytes into an image
    //   final decodedImage = img.decodeImage(imageBytes)!;
    //   // Create a black bottom layer
    //   // Resize the image to a 130x? thumbnail (maintaining the aspect ratio).
    //   img.Image thumbnail = img.copyResize(decodedImage, height: 130);
    //   // creates a copy of the original image with set dimensions
    //   img.Image originalImg = img.copyResize(decodedImage, width: 380, height: 130);
    //   // fills the original image with a white background
    //   img.fill(originalImg, color: img.ColorRgb8(255, 255, 255));
    //   var padding = (originalImg.width - thumbnail.width) / 2;

    //   //insert the image inside the frame and center it
    //   drawImage(originalImg, thumbnail, dstX: padding.toInt());

    //   // convert image to grayscale
    //   var grayscaleImage = img.grayscale(originalImg);

    //   bytes += generator.feed(1);
    //   // bytes += generator.imageRaster(img.decodeImage(imageBytes)!, align: PosAlign.center);
    //   bytes += generator.imageRaster(grayscaleImage, align: PosAlign.center);
    //   bytes += generator.feed(1);
    // }

    // // Chinese characters
    bytes += generator.row([
      PosColumn(
          width: 8,
          text: '豚肉・木耳と玉子炒め弁当',
          styles: const PosStyles(align: PosAlign.left),
          containsChinese: true),
      PosColumn(
          width: 4,
          text: '￥1,990',
          styles: const PosStyles(align: PosAlign.right),
          containsChinese: true),
    ]);
    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    var connectedTCP = false;
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

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

  // conectar dispositivo
  _connectDevice() async {
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(
                name: selectedPrinter!.deviceName,
                productId: selectedPrinter!.productId,
                vendorId: selectedPrinter!.vendorId));
        _isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(
                name: selectedPrinter!.deviceName,
                address: selectedPrinter!.address!,
                isBle: selectedPrinter!.isBle ?? false,
                autoConnect: _reconnect));
        break;
      case PrinterType.network:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        _isConnected = true;
        break;
      default:
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: const Text('Default Printer'),
        backgroundColor: ProjectColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 0.5 * MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<PrinterType>(
                focusColor: Colors.white,
                value: defaultPrinterType,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.print,
                    size: 24,
                  ),
                  labelText: "Type Printer Device",
                  labelStyle: TextStyle(fontSize: 18.0),
                  // focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 169, 0, 0),
                    ),
                  ),
                ),
                items: <DropdownMenuItem<PrinterType>>[
                  if (Platform.isAndroid || Platform.isIOS)
                    const DropdownMenuItem(
                      value: PrinterType.bluetooth,
                      child: Text("Bluetooth"),
                    ),
                  if (Platform.isAndroid || Platform.isWindows)
                    const DropdownMenuItem(
                      value: PrinterType.usb,
                      child: Text("USB"),
                    ),
                  const DropdownMenuItem(
                    value: PrinterType.network,
                    child: Text("Wi-Fi"),
                  ),
                ],
                onChanged: (PrinterType? value) {
                  setState(() {
                    if (value != null) {
                      setState(() {
                        defaultPrinterType = value;
                        selectedPrinter = null;
                        _isBle = false;
                        _isConnected = false;
                        _scan();
                      });
                    }
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.bluetooth &&
                    Platform.isAndroid,
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.all(10),
                  title: const Text(
                    "This device supports ble (low energy)",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  value: _isBle,
                  onChanged: (bool? value) {
                    setState(() {
                      _isBle = value ?? false;
                      _isConnected = false;
                      selectedPrinter = null;
                      _scan();
                    });
                  },
                ),
              ),
              Visibility(
                visible: defaultPrinterType == PrinterType.bluetooth &&
                    Platform.isAndroid,
                child: SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.all(10),
                  title: const Text(
                    "reconnect",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  value: _reconnect,
                  onChanged: (bool? value) {
                    setState(() {
                      _reconnect = value ?? false;
                    });
                  },
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxHeight: 0.5 * MediaQuery.of(context).size.height),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(),
                  child: Column(
                    children: [
                      Column(
                          children: devices
                              .map(
                                (device) => ListTile(
                                  title: Text(
                                    '${device.deviceName}',
                                  ),
                                  subtitle: Platform.isAndroid &&
                                          defaultPrinterType == PrinterType.usb
                                      ? null
                                      : Visibility(
                                          visible: !Platform.isWindows,
                                          child: Text("${device.address}")),
                                  onTap: () {
                                    // do something
                                    selectDevice(device);
                                  },
                                  leading: selectedPrinter != null &&
                                          ((device.typePrinter ==
                                                          PrinterType.usb &&
                                                      Platform.isWindows
                                                  ? device.deviceName ==
                                                      selectedPrinter!
                                                          .deviceName
                                                  : device.vendorId != null &&
                                                      selectedPrinter!
                                                              .vendorId ==
                                                          device.vendorId) ||
                                              (device.address != null &&
                                                  selectedPrinter!.address ==
                                                      device.address))
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : null,
                                  trailing: OutlinedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        side: selectedPrinter == null ||
                                                device.deviceName !=
                                                    selectedPrinter?.deviceName
                                            ? MaterialStateBorderSide
                                                .resolveWith((states) {
                                                states.map((e) => print(e));
                                                return const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 111, 111, 111),
                                                );
                                              })
                                            : MaterialStateBorderSide
                                                .resolveWith((states) {
                                                states.map((e) => print(e));
                                                return const BorderSide(
                                                  color: ProjectColors.primary,
                                                );
                                              })),
                                    onPressed: selectedPrinter == null ||
                                            device.deviceName !=
                                                selectedPrinter?.deviceName
                                        ? null
                                        : () async {
                                            _printReceiveTest();
                                          },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 20),
                                      child: Text("Print test ticket",
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                      Visibility(
                        visible: defaultPrinterType == PrinterType.network &&
                            Platform.isWindows,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _ipController,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            decoration: const InputDecoration(
                              label: Text("Ip Address"),
                              prefixIcon: Icon(Icons.wifi, size: 24),
                            ),
                            onChanged: setIpAddress,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: defaultPrinterType == PrinterType.network &&
                            Platform.isWindows,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _portController,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            decoration: const InputDecoration(
                              label: Text("Port"),
                              prefixIcon:
                                  Icon(Icons.numbers_outlined, size: 24),
                            ),
                            onChanged: setPort,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: defaultPrinterType == PrinterType.network &&
                            Platform.isWindows,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: OutlinedButton(
                            onPressed: () async {
                              if (_ipController.text.isNotEmpty)
                                setIpAddress(_ipController.text);
                              _printReceiveTest();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 50),
                              child: Text("Print test ticket",
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: OutlinedButton(
                    //     style: ButtonStyle(
                    //       shape: MaterialStatePropertyAll(
                    //         RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //       ),
                    //       side: selectedPrinter == null || !_isConnected
                    //           ? MaterialStateBorderSide.resolveWith((states) =>
                    //               const BorderSide(
                    //                 color: Color.fromARGB(255, 111, 111, 111),
                    //               ))
                    //           : MaterialStateBorderSide.resolveWith(
                    //               (states) => const BorderSide(
                    //                     color: Color.fromARGB(255, 169, 0, 0),
                    //                   )),
                    //     ),
                    //     onPressed: selectedPrinter == null || !_isConnected
                    //         ? null
                    //         : () {
                    //             if (selectedPrinter != null) {
                    //               printerManager.disconnect(
                    //                   type: selectedPrinter!.typePrinter);
                    //             }
                    //             setState(() {
                    //               _isConnected = false;
                    //             });
                    //           },
                    //     child: const Text("Disconnect",
                    //         textAlign: TextAlign.center),
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     style: ButtonStyle(
                    //         shape: MaterialStatePropertyAll(
                    //             RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(5))),
                    //         backgroundColor: selectedPrinter == null || _isConnected
                    //             ? MaterialStateColor.resolveWith((states) =>
                    //                 Color.fromARGB(255, 200, 200, 200))
                    //             : MaterialStateColor.resolveWith((states) =>
                    //                 const Color.fromARGB(255, 169, 0, 0)),
                    //         foregroundColor: selectedPrinter == null || _isConnected
                    //             ? MaterialStateColor.resolveWith((states) =>
                    //                 Color.fromARGB(255, 111, 111, 111))
                    //             : MaterialStateColor.resolveWith((states) =>
                    //                 Color.fromARGB(255, 255, 255, 255)),
                    //         overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                    //     onPressed: selectedPrinter == null || _isConnected
                    //         ? null
                    //         : () {
                    //             _connectDevice();
                    //           },
                    //     child:
                    //         const Text("Connect", textAlign: TextAlign.center),
                    //   ),
                    // ),

                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 10)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            backgroundColor: selectedPrinter == null || _isConnected
                                ? MaterialStateColor.resolveWith((states) =>
                                    Color.fromARGB(255, 200, 200, 200))
                                : MaterialStateColor.resolveWith(
                                    (states) => ProjectColors.primary),
                            foregroundColor: selectedPrinter == null || _isConnected
                                ? MaterialStateColor.resolveWith((states) =>
                                    Color.fromARGB(255, 111, 111, 111))
                                : MaterialStateColor.resolveWith((states) =>
                                    Color.fromARGB(255, 255, 255, 255)),
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                        onPressed: selectedPrinter == null || _isConnected
                            ? null
                            : () {
                                _setDeviceAsDefault();
                                Navigator.pop(context);
                              },
                        child: const Text("Set as Default",
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
