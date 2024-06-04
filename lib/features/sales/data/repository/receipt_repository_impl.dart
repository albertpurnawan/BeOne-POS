import 'dart:developer';

// import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
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
import 'package:pos_fe/features/sales/data/models/promotions.dart';
import 'package:pos_fe/features/sales/data/models/receipt.dart';
import 'package:pos_fe/features/sales/data/models/receipt_item.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
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

      final EmployeeModel employee =
          (await _appDatabase.employeeDao.readByEmpCode("99", txn))!;

      final prefs = GetIt.instance<SharedPreferences>();
      final tcsr1IdPref = prefs.getString('tcsr1Id');

      final InvoiceHeaderModel invoiceHeaderModel = InvoiceHeaderModel(
        docId: generatedInvoiceHeaderDocId, // dao
        createDate: null, // null kah? ini kan bosr punya
        updateDate: null, // null kah? ini kan bosr punya
        tostrId: posParameterModel.tostrId, // get di sini
        docnum: receiptEntity.docNum, // generate
        orderNo: 1, // generate
        tocusId: receiptEntity.customerEntity?.docId,
        tohemId: employee.docId, // get di sini atau dari awal aja
        transDateTime: null, // dao
        timezone: "GMT+07",
        remarks: null, // sementara hardcode
        subTotal: receiptEntity.subtotal,
        discPrctg: receiptEntity.discPrctg ?? 0,
        discAmount: (receiptEntity.discHeaderManual ?? 0) +
            (receiptEntity.discHeaderPromo ?? 0),
        discountCard: 0,
        coupon: "",
        discountCoupun: 0,
        taxPrctg: 0,
        taxAmount: receiptEntity.taxAmount,
        addCost: 0,
        rounding: receiptEntity.rounding,
        grandTotal: receiptEntity.grandTotal,
        changed: (receiptEntity.totalPayment ?? 0) - receiptEntity.grandTotal,
        totalPayment: receiptEntity.totalPayment!,
        tocsrId: posParameterModel.tocsrId, // get di sini
        docStatus: 0,
        sync: 0,
        syncCRM: 0,
        toinvTohemId: receiptEntity.employeeEntity?.docId, // get di sini
        refpos1: tcsr1IdPref, // get di sini
        refpos2: '', //
        tcsr1Id: tcsr1IdPref, // get di sini
        discHeaderManual: receiptEntity.discHeaderManual ?? 0, // get di sini
        discHeaderPromo: receiptEntity.discHeaderPromo ?? 0, // get di sini
        syncToBos: '', // get di sini
        paymentSuccess: '0', // get di sini
      );
      log("INVOICE HEADER MODEL 1 - $invoiceHeaderModel");

      await _appDatabase.invoiceHeaderDao
          .create(data: invoiceHeaderModel, txn: txn);

      final List<InvoiceDetailModel> invoiceDetailModels =
          receiptEntity.receiptItems.asMap().entries.map((entry) {
        final int index = entry.key;
        final ReceiptItemEntity e = entry.value;
        log("receiptEntity E - $e");
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
          sellingPrice: e.sellingPrice,
          discPrctg: e.discPrctg ?? 0,
          discAmount: e.discAmount ?? 0,
          totalAmount: e.totalAmount,
          taxPrctg: e.itemEntity.taxRate,
          promotionType: e.promos.isEmpty
              ? ""
              : e.promos.first.promoType.toString(), // kalau promo > 1?
          promotionId: e.promos.isEmpty
              ? ""
              : e.promos.first.promoId.toString(), // kalau promo > 1?
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
          discHeaderAmount: e.discHeaderAmount, //get disini
          subtotalAfterDiscHeader: e.subtotalAfterDiscHeader, //get disini
        );
      }).toList();

      log("INVOICE DETAIL MODEL 1 - $invoiceDetailModels");

      await _appDatabase.invoiceDetailDao
          .bulkCreate(data: invoiceDetailModels, txn: txn);

      final PayMeansModel paymeansModel = PayMeansModel(
        docId: _uuid.v4(),
        createDate: null,
        updateDate: null,
        toinvId: generatedInvoiceHeaderDocId,
        lineNum: 1,
        tpmt3Id: receiptEntity.mopSelection!.tpmt3Id,
        amount: receiptEntity.mopSelection!.amount ?? 0,
        tpmt2Id: null,
        cardNo: null,
        cardHolder: null,
        sisaVoucher: null,
      );

      await _appDatabase.payMeansDao.create(data: paymeansModel, txn: txn);

      List<VouchersSelectionEntity> vouchers = receiptEntity.vouchers;

      for (final voucherSelection in vouchers) {
        final PayMeansModel paymeansModel = PayMeansModel(
          docId: _uuid.v4(),
          createDate: null,
          updateDate: null,
          toinvId: generatedInvoiceHeaderDocId,
          lineNum: 1,
          tpmt3Id: voucherSelection.tpmt3Id,
          amount: double.parse(voucherSelection.voucherAmount.toString()),
          tpmt2Id: null,
          cardNo: null,
          cardHolder: null,
          sisaVoucher: 0,
        );

        await _appDatabase.payMeansDao.create(data: paymeansModel, txn: txn);
      }

      vouchers = vouchers.map((voucher) {
        voucher.tinv2Id = generatedInvoiceHeaderDocId;
        return voucher;
      }).toList();

      final List<VouchersSelectionModel> vouchersModel =
          vouchers.asMap().entries.map((entry) {
        final VouchersSelectionEntity e = entry.value;
        return VouchersSelectionModel(
          docId: e.docId,
          tpmt3Id: e.tpmt3Id,
          tovcrId: e.tovcrId,
          voucherAlias: e.voucherAlias,
          voucherAmount: e.voucherAmount,
          validFrom: e.validFrom,
          validTo: e.validTo,
          serialNo: e.serialNo,
          voucherStatus: e.voucherStatus,
          statusActive: e.statusActive,
          minPurchase: e.minPurchase,
          redeemDate: e.redeemDate,
          tinv2Id: e.tinv2Id,
          type: e.type,
        );
      }).toList();

      await Future.forEach(vouchersModel, (voucher) async {
        await _appDatabase.vouchersSelectionDao.update(
          docId: voucher.docId,
          data: voucher,
          txn: txn,
        );
      });
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
     * 4. Vouchers
     */

    final Database db = await _appDatabase.getDB();
    ReceiptModel? receiptModel;

    await db.transaction((txn) async {
      final InvoiceHeaderModel? invoiceHeaderModel =
          await _appDatabase.invoiceHeaderDao.readByDocId(docId, txn);
      log("INVOICE HEADER MODEL 2 - $invoiceHeaderModel");

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
          taxAmount: invoiceDetailModel.totalAmount *
              (invoiceDetailModel.taxPrctg / 100),
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
            tocatId: itemMasterModel.tocatId,
          ),
          sellingPrice: invoiceDetailModel.sellingPrice,
          totalAmount: invoiceDetailModel.totalAmount,
          totalSellBarcode:
              invoiceDetailModel.sellingPrice * invoiceDetailModel.quantity,
          promos: [],
        ));
      }

      List<VouchersSelectionModel> voucherModels = [];
      List<PromotionsModel> promoModels = [];
      int totalVoucherAmount = 0;

      for (var payMeansModel in payMeansModels) {
        if (payMeansModel.tpmt3Id == "532da15b-1e97-4616-9ea3-ee9072bbc6b1") {
          List<VouchersSelectionModel> vouchers =
              await GetIt.instance<AppDatabase>()
                  .vouchersSelectionDao
                  .readBytinv2Id(docId.toString(), txn: txn);
          voucherModels.addAll(vouchers);
        }
      }

      for (var voucherModel in voucherModels) {
        totalVoucherAmount += voucherModel.voucherAmount;
      }

      print(invoiceHeaderModel.transDateTime);
      print(invoiceHeaderModel.transDateTime?.toLocal());

      receiptModel = ReceiptModel(
        toinvId: invoiceHeaderModel.docId,
        receiptItems: receiptItemModels,
        subtotal: invoiceHeaderModel.subTotal,
        docNum: invoiceHeaderModel.docnum,
        totalTax: invoiceHeaderModel.taxAmount,
        mopSelection: mopSelectionModel,
        customerEntity: customerModel,
        employeeEntity: employeeModel,
        transStart: DateTime.now(),
        transDateTime: invoiceHeaderModel.transDateTime?.toLocal(),
        taxAmount: invoiceHeaderModel.taxAmount,
        grandTotal: invoiceHeaderModel.grandTotal,
        totalPayment: invoiceHeaderModel.totalPayment,
        changed: invoiceHeaderModel.changed,
        vouchers: voucherModels,
        totalVoucher: totalVoucherAmount,
        totalNonVoucher: invoiceHeaderModel.grandTotal - totalVoucherAmount,
        promos: promoModels,
        discHeaderManual: invoiceHeaderModel.discHeaderManual,
        discHeaderPromo: invoiceHeaderModel.discHeaderPromo,
      );
    });

    return receiptModel;
  }

  @override
  Future<List<ReceiptEntity>> getReceipts() {
    throw UnimplementedError();
  }

  @override
  Future<ReceiptEntity> recalculateTax(ReceiptEntity receiptEntity) async {
    log("Recalculate Tax Promo_Impl");
    double? discHeaderManual = receiptEntity.discHeaderManual ?? 0.0;
    double? discHeaderPromo = receiptEntity.discHeaderPromo ?? 0.0;
    double subtotal = receiptEntity.subtotal;
    double discHprctg = (discHeaderManual) / (subtotal - discHeaderPromo);
    double subtotalAfterDiscount = 0;
    double taxAfterDiscount = 0;

    log("RE - $receiptEntity");
    log("RE - Subtotal - ${receiptEntity.subtotal}");
    log("discHprctg - $discHprctg");

    for (final item in receiptEntity.receiptItems) {
      item.discHeaderAmount =
          discHprctg * (item.totalGross - (item.discAmount ?? 0));
      item.subtotalAfterDiscHeader = item.totalGross -
          (item.discAmount ?? 0) -
          (item.discHeaderAmount ?? 0);
      item.taxAmount =
          item.subtotalAfterDiscHeader! * (item.itemEntity.taxRate / 100);
      subtotalAfterDiscount += item.subtotalAfterDiscHeader!;
      taxAfterDiscount += item.taxAmount;
      log("Item - $item");
    }
    // receiptEntity.subtotal = subtotalAfterDiscount;
    receiptEntity.taxAmount = taxAfterDiscount;
    receiptEntity.grandTotal = subtotalAfterDiscount + taxAfterDiscount;
    log("REDM - ${receiptEntity.subtotal}");

    // receiptEntity = receiptEntity.copyWith(totalTax: totalTax);
    return receiptEntity;
  }
}
