import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class ReturnReceiptRemoteModel extends ReceiptEntity implements BaseModel {
  final String custCode;
  final String storeCode;
  final String timezone;

  ReturnReceiptRemoteModel({
    required super.docNum,
    required super.receiptItems,
    super.totalTax = 0,
    required super.transDateTime,
    required super.transStart,
    super.subtotal = 0,
    super.taxAmount = 0,
    required super.grandTotal,
    super.vouchers = const [],
    super.promos = const [],
    required this.custCode,
    required this.storeCode,
    required this.timezone,
  });

  factory ReturnReceiptRemoteModel.fromMapRemote(Map<String, dynamic> map) {
    final DateTime transDate = DateTime.parse(map['data'][0]['transdate'] as String);
    final DateTime transTime = DateTime.parse(map['data'][0]['transtime'] as String);
    final DateTime transDateTime =
        DateTime(transDate.year, transDate.month, transDate.day, transTime.hour, transTime.minute, transTime.second);

    return ReturnReceiptRemoteModel(
      docNum: map['data'][0]['docnum'] as String,
      receiptItems: (map['data'] as List).map((e) {
        final double refundableAmount =
            e["refundableAmount"] is String ? double.parse(e["refundableAmount"]) : e['refundableAmount'].toDouble();

        return ReceiptItemEntity(
          quantity: e['quantity'].toDouble() as double,
          totalGross: (refundableAmount * (100 / (e["taxprctg"].toDouble() + 100))),
          itemEntity: ItemEntity(
            id: null,
            itemName: e["itemname"] as String,
            itemCode: e["itemcode"] as String,
            barcode: e["barcode"] as String,
            price: (refundableAmount) / (e["quantity"].toDouble()),
            toitmId: e["toitm_id"] as String,
            tbitmId: e["tbitm_id"] as String,
            tpln2Id: "",
            openPrice: 0,
            tovenId: e["toven_id"],
            includeTax: e["includetax"] as int,
            tovatId: e["tovat_id"] as String,
            taxRate: e["taxprctg"].toDouble() as double,
            dpp: (refundableAmount * (100 / (e["taxprctg"] + 100)) / e["quantity"]).toDouble(),
            tocatId: null,
            shortName: null,
            toplnId: "",
            scaleActive: 0,
          ),
          tohemId: e["tohem_id"] != null ? e["tohem_id"] as String : null,
          taxAmount: (refundableAmount * (e["taxprctg"] / (e["taxprctg"] + 100))).toDouble(),
          sellingPrice: (refundableAmount / e["quantity"]).toDouble(),
          totalAmount: refundableAmount,
          totalSellBarcode: refundableAmount,
          promos: [],
          qtyBarcode: e['qtybarcode'].toDouble() as double,
          qtyConv: e['qtyconv'].toDouble() as double,
        );
      }).toList(),
      transStart: DateTime.now(),
      transDateTime: transDateTime,
      grandTotal: map['data'][0]['grandtotal'].toDouble(),
      vouchers: const [],
      promos: const [],
      subtotal: 0,
      taxAmount: 0,
      totalTax: 0,
      custCode: map['data'][0]['custcode'] as String,
      storeCode: map['data'][0]['storecode'] as String,
      timezone: map['data'][0]['timezone'] as String,
    );
  }
}
