import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/sales/data/models/queued_invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/queued_invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/receipt.dart';
import 'package:pos_fe/features/sales/data/models/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class QueuedReceiptRepositoryImpl implements QueuedReceiptRepository {
  final AppDatabase _appDatabase;
  final Uuid _uuid;
  QueuedReceiptRepositoryImpl(this._appDatabase, this._uuid);

  @override
  Future<ReceiptEntity?> createQueuedReceipt(
      ReceiptEntity receiptEntity) async {
    // TODO: implement createQueuedReceipt
    final String generatedInvoiceHeaderDocId = _uuid.v4();
    final Database db = await _appDatabase.getDB();

    await db.transaction((txn) async {
      final QueuedInvoiceHeaderModel queuedInvoiceHeaderModel =
          QueuedInvoiceHeaderModel(
        docId: generatedInvoiceHeaderDocId, // dao
        createDate: null, // null kah? ini kan bosr punya
        updateDate: null, // null kah? ini kan bosr punya
        tostrId: null, // get di sini
        docnum: "N/A", // generate
        orderNo: 1, // generate
        tocusId: receiptEntity.customerEntity?.docId,
        tohemId: null, // get di sini atau dari awal aja
        transDateTime: null, // dao
        timezone: "GMT+07",
        remarks: null, // sementara hardcode
        subTotal: receiptEntity.subtotal,
        discPrctg: 0,
        discAmount: 0,
        discountCard: 0,
        coupon: "",
        discountCoupun: 0,
        taxPrctg: 0,
        taxAmount: receiptEntity.taxAmount,
        addCost: 0,
        rounding: 0,
        grandTotal: receiptEntity.grandTotal,
        changed: 0,
        totalPayment: 0,
        tocsrId: null, // get di sini
        docStatus: 0,
        sync: 0,
        syncCRM: 0,
        toinvTohemId: receiptEntity.employeeEntity?.docId, // get di sini
        tcsr1Id: null, // get di sini
        discHeaderManual: null, // get di sini
        discHeaderPromo: null, // get di sini
        syncToBos: 0, // get di sini
      );

      await _appDatabase.queuedInvoiceHeaderDao
          .create(data: queuedInvoiceHeaderModel, txn: txn);

      final List<QueuedInvoiceDetailModel> invoiceDetailModels =
          receiptEntity.receiptItems.asMap().entries.map((entry) {
        final int index = entry.key;
        final ReceiptItemEntity e = entry.value;
        return QueuedInvoiceDetailModel(
          docId: _uuid.v4(), // dao
          createDate: null, // null
          updateDate: null, // null
          toinvId: generatedInvoiceHeaderDocId, // get lagi yg created?
          lineNum: index, // pakai index
          docNum: receiptEntity.docNum, // generate
          idNumber: 10, // ? harcode dulu
          toitmId: e.itemEntity.toitmId,
          quantity: e.quantity,
          sellingPrice: e.sellingPrice,
          discPrctg: 0,
          discAmount: 0,
          totalAmount: e.totalAmount,
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
          discHeaderAmount: 0, // need to check
          subtotalAfterDiscHeader: 0, // need to check
        );
      }).toList();

      await _appDatabase.queuedInvoiceDetailDao
          .bulkCreate(data: invoiceDetailModels, txn: txn);
    });

    return await getQueuedReceiptByDocId(generatedInvoiceHeaderDocId);
  }

  @override
  Future<ReceiptEntity?> getQueuedReceiptByDocId(String docId) async {
    // TODO: implement getQueuedReceiptById
    final Database db = await _appDatabase.getDB();
    ReceiptModel? receiptModel;

    await db.transaction((txn) async {
      final QueuedInvoiceHeaderModel? invoiceHeaderModel =
          await _appDatabase.queuedInvoiceHeaderDao.readByDocId(docId, txn);
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
      // final List<PayMeansModel> payMeansModels =
      //     await _appDatabase.payMeansDao.readByToinvId(docId, txn);
      // final MopSelectionModel? mopSelectionModel = payMeansModels.isNotEmpty
      //     ? await _appDatabase.mopByStoreDao
      //         .readByDocIdIncludeRelations(payMeansModels[0].tpmt3Id!, txn)
      //     : null;
      final List<QueuedInvoiceDetailModel> queuedInvoiceDetailModels =
          await _appDatabase.queuedInvoiceDetailDao.readByToinvId(docId, txn);

      List<ReceiptItemModel> receiptItemModels = [];
      for (final queuedInvoiceDetailModel in queuedInvoiceDetailModels) {
        final ItemMasterModel? itemMasterModel = await _appDatabase
            .itemMasterDao
            .readByDocId(queuedInvoiceDetailModel.toitmId!, txn);
        if (itemMasterModel == null) throw "Item not found";
        receiptItemModels.add(ReceiptItemModel(
          quantity: queuedInvoiceDetailModel.quantity,
          totalGross: queuedInvoiceDetailModel.totalAmount *
              100 /
              (100 + queuedInvoiceDetailModel.taxPrctg),
          taxAmount: queuedInvoiceDetailModel.totalAmount *
              queuedInvoiceDetailModel.taxPrctg,
          itemEntity: ItemModel(
            id: null,
            itemName: itemMasterModel.itemName,
            itemCode: itemMasterModel.itemCode,
            barcode: "", // nanti dibutuhkan melanjutkan transaksi
            price: 0,
            toitmId: itemMasterModel.docId,
            tbitmId: queuedInvoiceDetailModel.tbitmId!,
            tpln2Id: "",
            openPrice: itemMasterModel.openPrice,
            tovenId: queuedInvoiceDetailModel.tovenId!,
            tovatId: queuedInvoiceDetailModel.tovatId!,
            taxRate: queuedInvoiceDetailModel.taxPrctg,
            dpp: queuedInvoiceDetailModel.sellingPrice *
                100 /
                (100 + queuedInvoiceDetailModel.taxPrctg),
            includeTax: itemMasterModel.includeTax,
            tocatId: itemMasterModel.tocatId,
          ),
          sellingPrice: queuedInvoiceDetailModel.sellingPrice,
          totalAmount: queuedInvoiceDetailModel.totalAmount,
          totalSellBarcode: queuedInvoiceDetailModel.sellingPrice *
              queuedInvoiceDetailModel.quantity,
          promos: [],
        ));
      }

      print(invoiceHeaderModel.transDateTime);
      print(invoiceHeaderModel.transDateTime?.toLocal());

      receiptModel = ReceiptModel(
        toinvId: invoiceHeaderModel.docId,
        receiptItems: receiptItemModels,
        subtotal: invoiceHeaderModel.subTotal,
        docNum: invoiceHeaderModel.docnum,
        totalTax: invoiceHeaderModel.taxAmount,
        mopSelection: null,
        customerEntity: customerModel,
        employeeEntity: employeeModel,
        transStart: DateTime.now(),
        transDateTime: invoiceHeaderModel.transDateTime?.toLocal(),
        taxAmount: invoiceHeaderModel.taxAmount,
        grandTotal: invoiceHeaderModel.grandTotal,
        totalPayment: invoiceHeaderModel.totalPayment,
        changed: invoiceHeaderModel.changed,
        vouchers: [], // diambil service vouchers
        totalVoucher: 0, // diambil service vouchers
        totalNonVoucher: 0, // diambil service vouchers
        promos: [], // diambil service promos
      );
    });

    return receiptModel;
  }

  @override
  Future<List<ReceiptEntity>> getQueuedReceipts() async {
    // TODO: implement getQueuedReceipts
    final Database db = await _appDatabase.getDB();
    List<ReceiptEntity> queuedReceiptModels = [];

    await db.transaction((txn) async {
      final List<QueuedInvoiceHeaderModel> queuedInvoiceHeaderModels =
          await _appDatabase.queuedInvoiceHeaderDao.readAll(txn: txn);
      for (final queuedInvoiceHeaderModel in queuedInvoiceHeaderModels) {
        final CustomerModel? customerModel =
            queuedInvoiceHeaderModel.tocusId != null
                ? await _appDatabase.customerDao
                    .readByDocId(queuedInvoiceHeaderModel.tocusId!, txn)
                : null;
        final EmployeeModel? employeeModel =
            queuedInvoiceHeaderModel.tohemId != null
                ? await _appDatabase.employeeDao
                    .readByDocId(queuedInvoiceHeaderModel.tohemId!, txn)
                : null;
        // final List<PayMeansModel> payMeansModels =
        //     await _appDatabase.payMeansDao.readByToinvId(docId, txn);
        // final MopSelectionModel? mopSelectionModel = payMeansModels.isNotEmpty
        //     ? await _appDatabase.mopByStoreDao
        //         .readByDocIdIncludeRelations(payMeansModels[0].tpmt3Id!, txn)
        //     : null;
        final List<QueuedInvoiceDetailModel> queuedInvoiceDetailModels =
            await _appDatabase.queuedInvoiceDetailDao
                .readByToinvId(queuedInvoiceHeaderModel.docId!, txn);

        List<ReceiptItemModel> receiptItemModels = [];
        for (final queuedInvoiceDetailModel in queuedInvoiceDetailModels) {
          final ItemMasterModel? itemMasterModel = await _appDatabase
              .itemMasterDao
              .readByDocId(queuedInvoiceDetailModel.toitmId!, txn);
          if (itemMasterModel == null) throw "Item not found";
          final ItemBarcodeModel? itemBarcodeModel = await _appDatabase
              .itemBarcodeDao
              .readByDocId(queuedInvoiceDetailModel.tbitmId!, txn);
          if (itemBarcodeModel == null) throw "Barcode not found";

          receiptItemModels.add(ReceiptItemModel(
            quantity: queuedInvoiceDetailModel.quantity,
            totalGross: queuedInvoiceDetailModel.totalAmount *
                100 /
                (100 + queuedInvoiceDetailModel.taxPrctg),
            taxAmount: queuedInvoiceDetailModel.totalAmount *
                (queuedInvoiceDetailModel.taxPrctg / 100),
            itemEntity: ItemModel(
              id: null,
              itemName: itemMasterModel.itemName,
              itemCode: itemMasterModel.itemCode,
              barcode: itemBarcodeModel
                  .barcode, // nanti dibutuhkan melanjutkan transaksi
              price: 0,
              toitmId: itemMasterModel.docId,
              tbitmId: queuedInvoiceDetailModel.tbitmId!,
              tpln2Id: "",
              openPrice: itemMasterModel.openPrice,
              tovenId: queuedInvoiceDetailModel.tovenId!,
              tovatId: queuedInvoiceDetailModel.tovatId!,
              taxRate: queuedInvoiceDetailModel.taxPrctg,
              dpp: queuedInvoiceDetailModel.sellingPrice *
                  100 /
                  (100 + queuedInvoiceDetailModel.taxPrctg),
              includeTax: itemMasterModel.includeTax,
              tocatId: itemMasterModel.tocatId,
            ),
            sellingPrice: queuedInvoiceDetailModel.sellingPrice,
            totalAmount: queuedInvoiceDetailModel.totalAmount,
            totalSellBarcode: queuedInvoiceDetailModel.sellingPrice *
                queuedInvoiceDetailModel.quantity,
            promos: [],
          ));
        }
        queuedReceiptModels.add(ReceiptModel(
          toinvId: queuedInvoiceHeaderModel.docId,
          receiptItems: receiptItemModels,
          subtotal: queuedInvoiceHeaderModel.subTotal,
          docNum: queuedInvoiceHeaderModel.docnum,
          totalTax: queuedInvoiceHeaderModel.taxAmount,
          mopSelection: null,
          customerEntity: customerModel,
          employeeEntity: employeeModel,
          transStart: DateTime.now(),
          transDateTime: queuedInvoiceHeaderModel.transDateTime?.toLocal(),
          taxAmount: queuedInvoiceHeaderModel.taxAmount,
          grandTotal: queuedInvoiceHeaderModel.grandTotal,
          totalPayment: queuedInvoiceHeaderModel.totalPayment,
          changed: queuedInvoiceHeaderModel.changed,
          vouchers: [], // diambil service vouchers
          totalVoucher: 0, // diambil service vouchers
          totalNonVoucher: 0, // diambil service vouchers
          promos: [], // diambil service promos
        ));
      }
    });

    return queuedReceiptModels;
  }

  @override
  Future<void> deleteByDocId(String docId) async {
    await _appDatabase.queuedInvoiceHeaderDao.deleteByDocId(docId, null);
  }

  @override
  Future<void> deleteAll() async {
    await _appDatabase.queuedInvoiceHeaderDao.deleteAllData();
  }
}
