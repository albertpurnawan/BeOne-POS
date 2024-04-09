// import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/receipt.dart';
import 'package:pos_fe/features/sales/data/models/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final AppDatabase _appDatabase;
  final Uuid _uuid;
  ReceiptRepositoryImpl(this._appDatabase, this._uuid);

  @override
  Future<ReceiptModel?> createInvoiceHeaderAndDetail(
      ReceiptEntity receiptEntity) async {
    final String generatedInvoiceHeaderDocId = _uuid.v4();
    final Database db = await _appDatabase.getDB();

    await db.transaction((txn) async {
      final POSParameterModel posParameterModel =
          (await _appDatabase.posParameterDao.readAll(txn: txn)).first;

      final prefs = GetIt.instance<SharedPreferences>();
      final tcsr1Id = prefs.getString('tcsr1Id');

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
        subTotal: receiptEntity.subtotal,
        discPrctg: 0,
        discAmount: 0,
        discountCard: 0,
        coupon: "",
        discountCoupun: 0,
        taxPrctg: 0,
        taxAmount: receiptEntity.totalTax,
        addCost: 0,
        rounding: 0,
        grandTotal: receiptEntity.grandTotal + receiptEntity.totalTax,
        changed: receiptEntity.changed!,
        totalPayment: receiptEntity.totalPayment!,
        tocsrId: posParameterModel.tocsrId, // get di sini
        docStatus: 0,
        sync: 0,
        syncCRM: 0,
        toinvTohemId: receiptEntity.employeeEntity?.docId, // get di sini
        tcsr1Id: tcsr1Id, // get di sini
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
          sellingPrice: e.itemEntity.includeTax == 1
              ? e.itemEntity.price
              : e.itemEntity.price * ((100 + e.itemEntity.taxRate) / 100),
          discPrctg: 0,
          discAmount: 0,
          totalAmount: e.itemEntity.includeTax == 1
              ? e.itemEntity.price * e.quantity
              : e.itemEntity.price *
                  e.quantity *
                  ((100 + e.itemEntity.taxRate) / 100),
          taxPrctg: e.itemEntity.taxRate,
          promotionType: "",
          promotionId: "",
          remarks: null,
          editTime: DateTime.now(), // ?
          cogs: 0,
          tovatId: e.itemEntity.tovatId, // get disini/dari sales page
          promotionTingkat: null,
          promoVoucherNo: null,
          baseDocId: null,
          baseLineDocId: null,
          includeTax: e.itemEntity.includeTax, // ??
          tovenId: e.itemEntity.tovenId, // belum ada
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
        amount: receiptEntity.grandTotal.toDouble(),
        tpmt2Id: null,
        cardNo: null,
        cardHolder: null,
        sisaVoucher: null,
      );

      await _appDatabase.payMeansDao.create(data: paymeansModel, txn: txn);
    });

    return await getReceiptByInvoiceHeaderDocId(generatedInvoiceHeaderDocId);
  }

  @override
  Future<ReceiptModel?> getReceiptByInvoiceHeaderDocId(String docId) async {
    /**
     * 1. Ambil invoice header 
     *  - docnum
     *  - totalPrice
     *  - ambil customer => customerEntity
     *  - ambil employee => employeeEntity
     *  - totalTax
     * 2. Ambil invoice detail
     *  - quantity
     *  - subtotal
     *  - taxAmount
     *  - price
     *  - taxRate
     *  - dpp
     *  - toitmId
     *  - tbitmId
     *  - tovenId
     *  - tovatId
     *  - ambil toitm => itemname, itemcode, openPrice?, toven, includeTax?
     *  !!! yg ga (perlu) keambil: barcode
     *  !!! tpln2Id ga ada datanya
     * 3. Ambil pay means
     *  - ambil semua relations => mopSelection
     *  - amountReceived
     */

    final Database db = await _appDatabase.getDB();
    ReceiptModel? receiptModel;

    await db.transaction((txn) async {
      final InvoiceHeaderModel? invoiceHeaderModel =
          await _appDatabase.invoiceHeaderDao.readByDocId(docId, txn);
      if (invoiceHeaderModel == null) {
        throw "Invoice header not found";
      }
      final CustomerModel? customerModel = invoiceHeaderModel.tocusId != null
          ? await _appDatabase.customerDao
              .readByDocId(invoiceHeaderModel.tocusId!, txn)
          : null;
      final EmployeeModel? employeeModel = invoiceHeaderModel.tohemId != null
          ? await _appDatabase.employeeDao
              .readByDocId(invoiceHeaderModel.tohemId!, txn)
          : null;
      final List<PayMeansModel> payMeansModels =
          await _appDatabase.payMeansDao.readByToinvId(docId, txn);
      final MopSelectionModel? mopSelectionModel = payMeansModels.isNotEmpty
          ? await _appDatabase.mopByStoreDao
              .readByDocIdIncludeRelations(payMeansModels[0].tpmt3Id!, txn)
          : null;
      final List<InvoiceDetailModel> invoiceDetailModels =
          await _appDatabase.invoiceDetailDao.readByToinvId(docId, txn);

      List<ReceiptItemModel> receiptItemModels = [];
      for (final invoiceDetailModel in invoiceDetailModels) {
        final ItemMasterModel? itemMasterModel = await _appDatabase
            .itemMasterDao
            .readByDocId(invoiceDetailModel.toitmId!, txn);
        if (itemMasterModel == null) throw "Item not found";
        receiptItemModels.add(ReceiptItemModel(
            quantity: invoiceDetailModel.quantity,
            totalGross: invoiceDetailModel.totalAmount *
                100 /
                (100 + invoiceDetailModel.taxPrctg),
            taxAmount:
                invoiceDetailModel.totalAmount * invoiceDetailModel.taxPrctg,
            itemEntity: ItemModel(
              id: null,
              itemName: itemMasterModel.itemName,
              itemCode: itemMasterModel.itemCode,
              barcode: "",
              price: 0,
              toitmId: itemMasterModel.docId,
              tbitmId: invoiceDetailModel.tbitmId!,
              tpln2Id: "",
              openPrice: itemMasterModel.openPrice,
              tovenId: invoiceDetailModel.tovenId!,
              tovatId: invoiceDetailModel.tovatId!,
              taxRate: invoiceDetailModel.taxPrctg,
              dpp: invoiceDetailModel.sellingPrice *
                  100 /
                  (100 + invoiceDetailModel.taxPrctg),
              includeTax: itemMasterModel.includeTax,
            ),
            sellingPrice: invoiceDetailModel.sellingPrice,
            totalAmount: invoiceDetailModel.totalAmount,
            totalSellBarcode:
                invoiceDetailModel.sellingPrice * invoiceDetailModel.quantity));
      }

      receiptModel = ReceiptModel(
        receiptItems: receiptItemModels,
        subtotal: invoiceHeaderModel.subTotal,
        docNum: invoiceHeaderModel.docnum,
        totalTax: invoiceHeaderModel.taxAmount,
        mopSelection: mopSelectionModel,
        customerEntity: customerModel,
        employeeEntity: employeeModel,
        transStart: DateTime.now(),
        taxAmount: invoiceHeaderModel.taxAmount,
        grandTotal: invoiceHeaderModel.grandTotal,
      );
    });

    return receiptModel;
  }

  @override
  Future<List<ReceiptEntity>> getReceipts() {
    throw UnimplementedError();
  }
}
