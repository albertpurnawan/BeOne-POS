import 'package:get_it/get_it.dart';
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
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class QueuedReceiptRepositoryImpl implements QueuedReceiptRepository {
  final AppDatabase _appDatabase;
  final Uuid _uuid;
  QueuedReceiptRepositoryImpl(this._appDatabase, this._uuid);

  @override
  Future<ReceiptEntity?> createQueuedReceipt(ReceiptEntity receiptEntity) async {
    final String generatedInvoiceHeaderDocId = _uuid.v4();
    final Database db = await _appDatabase.getDB();

    final prefs = GetIt.instance<SharedPreferences>();
    final tcsr1IdPref = prefs.getString('tcsr1Id');

    await db.transaction((txn) async {
      final QueuedInvoiceHeaderModel queuedInvoiceHeaderModel = QueuedInvoiceHeaderModel(
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
        remarks: receiptEntity.remarks,
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
        refpos1: tcsr1IdPref, // get di sini
        refpos2: (receiptEntity.downPayments != null) ? (receiptEntity.downPayments.toString()) : "",
        tcsr1Id: tcsr1IdPref, // get di sini
        discHeaderManual: receiptEntity.discHeaderManual ?? 0, // get di sini
        discHeaderPromo: receiptEntity.discHeaderPromo ?? 0, // get di sini
        syncToBos: '', // get di sini
        paymentSuccess: '0', // get di sini
        salesTohemId: receiptEntity.salesTohemId,
      );

      await _appDatabase.queuedInvoiceHeaderDao.create(data: queuedInvoiceHeaderModel, txn: txn);

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
          remarks: e.remarks,
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
          discHeaderAmount: e.discHeaderAmount ?? 0, // need to check
          tohemId: e.tohemId ?? receiptEntity.salesTohemId,
          refpos2: e.refpos2 ?? "",
          // subtotalAfterDiscHeader: 0, // need to check
        );
      }).toList();

      await _appDatabase.queuedInvoiceDetailDao.bulkCreate(data: invoiceDetailModels, txn: txn);
    });

    return await getQueuedReceiptByDocId(generatedInvoiceHeaderDocId);
  }

  @override // UNIMPLEMENTED FOR NOW
  Future<ReceiptEntity?> getQueuedReceiptByDocId(String docId) async {
    final Database db = await _appDatabase.getDB();
    ReceiptModel? receiptModel;

    await db.transaction((txn) async {
      final QueuedInvoiceHeaderModel? invoiceHeaderModel =
          await _appDatabase.queuedInvoiceHeaderDao.readByDocId(docId, txn);
      if (invoiceHeaderModel == null) {
        throw "Invoice header not found";
      }
      final CustomerModel? customerModel = invoiceHeaderModel.tocusId != null
          ? await _appDatabase.customerDao.readByDocId(invoiceHeaderModel.tocusId!, txn)
          : null;
      final EmployeeModel? employeeModel = invoiceHeaderModel.tohemId != null
          ? await _appDatabase.employeeDao.readByDocId(invoiceHeaderModel.tohemId!, txn)
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
        final ItemMasterModel? itemMasterModel =
            await _appDatabase.itemMasterDao.readByDocId(queuedInvoiceDetailModel.toitmId!, txn);
        if (itemMasterModel == null) throw "Item not found";
        receiptItemModels.add(ReceiptItemModel(
          quantity: queuedInvoiceDetailModel.quantity,
          totalGross: queuedInvoiceDetailModel.totalAmount * 100 / (100 + queuedInvoiceDetailModel.taxPrctg),
          taxAmount: queuedInvoiceDetailModel.totalAmount * queuedInvoiceDetailModel.taxPrctg,
          itemEntity: ItemModel(
            id: null,
            itemName: itemMasterModel.itemName,
            itemCode: itemMasterModel.itemCode,
            barcode: "N/A", // <UNIMPLEMENTED>
            price: 0,
            toitmId: queuedInvoiceDetailModel.toitmId!,
            tbitmId: queuedInvoiceDetailModel.tbitmId!,
            tpln2Id: "N/A",
            openPrice: itemMasterModel.openPrice,
            tovenId: queuedInvoiceDetailModel.tovenId,
            tovatId: queuedInvoiceDetailModel.tovatId!,
            taxRate: queuedInvoiceDetailModel.taxPrctg,
            dpp: queuedInvoiceDetailModel.sellingPrice * 100 / (100 + queuedInvoiceDetailModel.taxPrctg),
            includeTax: itemMasterModel.includeTax,
            tocatId: itemMasterModel.tocatId,
            shortName: itemMasterModel.shortName,
            toplnId: "N/A",
          ),
          sellingPrice: queuedInvoiceDetailModel.sellingPrice,
          totalAmount: queuedInvoiceDetailModel.totalAmount,
          totalSellBarcode: queuedInvoiceDetailModel.sellingPrice * queuedInvoiceDetailModel.quantity,
          promos: [],
        ));
      }

      receiptModel = ReceiptModel(
        toinvId: invoiceHeaderModel.docId,
        receiptItems: receiptItemModels,
        subtotal: invoiceHeaderModel.subTotal,
        docNum: invoiceHeaderModel.docnum,
        totalTax: invoiceHeaderModel.taxAmount,
        mopSelections: [],
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
        queuedInvoiceHeaderDocId: invoiceHeaderModel.docId,
      );
    });

    return receiptModel;
  }

  @override
  Future<List<ReceiptEntity>> getQueuedReceipts() async {
    final Database db = await _appDatabase.getDB();
    List<ReceiptEntity> queuedReceiptModels = [];

    await db.transaction((txn) async {
      final List<QueuedInvoiceHeaderModel> queuedInvoiceHeaderModels =
          await _appDatabase.queuedInvoiceHeaderDao.readAll(txn: txn);

      for (final queuedInvoiceHeaderModel in queuedInvoiceHeaderModels) {
        final CustomerModel? customerModel = queuedInvoiceHeaderModel.tocusId != null
            ? await _appDatabase.customerDao.readByDocId(queuedInvoiceHeaderModel.tocusId!, txn)
            : null;
        final EmployeeModel? employeeModel = queuedInvoiceHeaderModel.tohemId != null
            ? await _appDatabase.employeeDao.readByDocId(queuedInvoiceHeaderModel.tohemId!, txn)
            : null;
        // final List<PayMeansModel> payMeansModels =
        //     await _appDatabase.payMeansDao.readByToinvId(docId, txn);
        // final MopSelectionModel? mopSelectionModel = payMeansModels.isNotEmpty
        //     ? await _appDatabase.mopByStoreDao
        //         .readByDocIdIncludeRelations(payMeansModels[0].tpmt3Id!, txn)
        //     : null;
        final List<QueuedInvoiceDetailModel> queuedInvoiceDetailModels =
            await _appDatabase.queuedInvoiceDetailDao.readByToinvId(queuedInvoiceHeaderModel.docId!, txn);

        List<ReceiptItemModel> receiptItemModels = [];
        for (final queuedInvoiceDetailModel in queuedInvoiceDetailModels) {
          final ItemMasterModel? itemMasterModel =
              await _appDatabase.itemMasterDao.readByDocId(queuedInvoiceDetailModel.toitmId!, txn);
          if (itemMasterModel == null) throw "Item not found";
          final ItemBarcodeModel? itemBarcodeModel =
              await _appDatabase.itemBarcodeDao.readByDocId(queuedInvoiceDetailModel.tbitmId!, txn);
          if (itemBarcodeModel == null) throw "Barcode not found";

          receiptItemModels.add(ReceiptItemModel(
            quantity: queuedInvoiceDetailModel.quantity,
            totalGross: queuedInvoiceDetailModel.totalAmount * 100 / (100 + queuedInvoiceDetailModel.taxPrctg),
            taxAmount: queuedInvoiceDetailModel.totalAmount * (queuedInvoiceDetailModel.taxPrctg / 100),
            itemEntity: ItemModel(
              id: null,
              itemName: itemMasterModel.itemName,
              itemCode: itemMasterModel.itemCode,
              barcode: itemBarcodeModel.barcode,
              price: 0,
              toitmId: itemMasterModel.docId,
              tbitmId: queuedInvoiceDetailModel.tbitmId!,
              tpln2Id: "N/A",
              openPrice: itemMasterModel.openPrice,
              tovenId: queuedInvoiceDetailModel.tovenId,
              tovatId: queuedInvoiceDetailModel.tovatId!,
              taxRate: queuedInvoiceDetailModel.taxPrctg,
              dpp: queuedInvoiceDetailModel.sellingPrice * 100 / (100 + queuedInvoiceDetailModel.taxPrctg),
              includeTax: itemMasterModel.includeTax,
              tocatId: itemMasterModel.tocatId,
              shortName: itemMasterModel.shortName,
              toplnId: "N/A",
            ),
            sellingPrice: queuedInvoiceDetailModel.sellingPrice,
            totalAmount: queuedInvoiceDetailModel.totalAmount,
            totalSellBarcode: queuedInvoiceDetailModel.sellingPrice * queuedInvoiceDetailModel.quantity,
            promos: [],
            tohemId: queuedInvoiceDetailModel.tohemId,
            remarks: queuedInvoiceDetailModel.remarks,
          ));
        }

        List<DownPaymentEntity> downPayments = [];

        RegExp exp = RegExp(r'DownPaymentEntity\(refpos2: (.*?), toinvDocId: (.*?), amount: (.*?)\)');
        Iterable<Match> matches = exp.allMatches(queuedInvoiceHeaderModel.refpos2 ?? "");

        for (var match in matches) {
          String? refpos2 = match.group(1) == 'null' ? null : match.group(1);
          String toinvDocId = match.group(2)!;
          double amount = double.parse(match.group(3)!);

          downPayments.add(DownPaymentEntity(refpos2: refpos2, toinvDocId: toinvDocId, amount: amount));
        }

        queuedReceiptModels.add(ReceiptModel(
            toinvId: queuedInvoiceHeaderModel.docId,
            receiptItems: receiptItemModels,
            subtotal: queuedInvoiceHeaderModel.subTotal,
            docNum: queuedInvoiceHeaderModel.docnum,
            totalTax: queuedInvoiceHeaderModel.taxAmount,
            mopSelections: [],
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
            queuedInvoiceHeaderDocId: queuedInvoiceHeaderModel.docId,
            salesTohemId: queuedInvoiceHeaderModel.salesTohemId,
            remarks: queuedInvoiceHeaderModel.remarks,
            downPayments: (queuedInvoiceHeaderModel.refpos2 != null && queuedInvoiceHeaderModel.refpos2 != "")
                ? downPayments
                : null));
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
