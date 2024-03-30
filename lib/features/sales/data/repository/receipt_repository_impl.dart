// import 'package:flutter/material.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final AppDatabase _appDatabase;
  final Uuid _uuid;
  ReceiptRepositoryImpl(this._appDatabase, this._uuid);

  @override
  Future<void> createInvoiceHeaderAndDetail(ReceiptEntity receiptEntity) async {
    final String generatedInvoiceHeaderDocId = _uuid.v4();
    final Database db = await _appDatabase.getDB();

    await db.transaction((txn) async {
      final POSParameterModel posParameterModel =
          (await _appDatabase.posParameterDao.readAll(txn: txn)).first;

      final InvoiceHeaderModel invoiceHeaderModel = InvoiceHeaderModel(
        docId: generatedInvoiceHeaderDocId, // dao
        createDate: null, // null kah? ini kan bosr punya
        updateDate: null, // null kah? ini kan bosr punya
        tostrId: posParameterModel.tostrId, // get di sini
        docnum: receiptEntity.docNum, // generate
        orderNo: 1, // generate
        tocusId: receiptEntity.customerEntity?.docId,
        tohemId: null, // get di sini atau dari awal aja
        transDate: null, // dao
        transTime: null, // dao
        timezone: "GMT+07",
        remarks: null, // sementara hardcode
        subTotal: receiptEntity.totalPrice.toDouble(),
        discPrctg: 0,
        discAmount: 0,
        discountCard: 0,
        coupon: "",
        discountCoupun: 0,
        taxPrctg: 0,
        taxAmount: 0,
        addCost: 0,
        rounding: 0,
        grandTotal: receiptEntity.totalPrice.toDouble(),
        changed: (receiptEntity.amountReceived! - receiptEntity.totalPrice)
            .toDouble(),
        totalPayment: receiptEntity.amountReceived!.toDouble(),
        tocsrId: posParameterModel.tocsrId, // get di sini
        docStatus: 0,
        sync: 0,
        syncCRM: 0,
        toinvTohemId: null, // get di sini
      );

      await _appDatabase.invoiceHeaderDao
          .create(data: invoiceHeaderModel, txn: txn);

      final List<InvoiceDetailModel> invoiceDetailModels =
          receiptEntity.receiptItems.asMap().entries.map((entry) {
        final int index = entry.key;
        final ReceiptItemEntity e = entry.value;
        return InvoiceDetailModel(
          docId: _uuid.v4(), // dao
          createDate: null, // null
          updateDate: null, // null
          toinvId: generatedInvoiceHeaderDocId, // get lagi yg created?
          lineNum: index, // pakai index
          docNum: receiptEntity.docNum, // generate
          idNumber: 10, // ? harcode dulu
          toitmId: e.itemEntity.toitmId,
          quantity: e.quantity,
          sellingPrice: e.itemEntity.price,
          discPrctg: 0,
          discAmount: 0,
          totalAmount: e.subtotal.toDouble(),
          taxPrctg: 0,
          promotionType: "",
          promotionId: "",
          remarks: null,
          editTime: DateTime.now(), // ?
          cogs: 0,
          tovatId: posParameterModel.tovatId, // get disini/dari sales page
          promotionTingkat: null,
          promoVoucherNo: null,
          baseDocId: null,
          baseLineDocId: null,
          includeTax: 1, // ??
          tovenId: null, // belum ada
          tbitmId: e.itemEntity.tbitmId,
        );
      }).toList();

      await _appDatabase.invoiceDetailDao
          .bulkCreate(data: invoiceDetailModels, txn: txn);

      final PayMeansModel paymeansModel = PayMeansModel(
        docId: _uuid.v4(),
        createDate: null,
        updateDate: null,
        toinvId: generatedInvoiceHeaderDocId,
        lineNum: 1,
        tpmt3Id: receiptEntity.mopSelection!.tpmt3Id,
        amount: receiptEntity.totalPrice.toDouble(),
        tpmt2Id: null,
        cardNo: null,
        cardHolder: null,
        sisaVoucher: null,
      );

      await _appDatabase.payMeansDao.create(data: paymeansModel, txn: txn);
    });
  }

  @override
  Future<ItemEntity?> getInvoiceByDocId(String docId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ItemEntity>> getInvoices() {
    throw UnimplementedError();
  }
}
