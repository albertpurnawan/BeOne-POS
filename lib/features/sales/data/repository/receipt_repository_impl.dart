import 'dart:developer';

// import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/models/approval_invoice.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/down_payment_items_model.dart';
import 'package:pos_fe/features/sales/data/models/employee.dart';
import 'package:pos_fe/features/sales/data/models/invoice_applied_promo.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/data/models/item_barcode.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/promotions.dart';
import 'package:pos_fe/features/sales/data/models/receipt.dart';
import 'package:pos_fe/features/sales/data/models/receipt_item.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/approval_invoice.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_items_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_down_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final AppDatabase _appDatabase;
  final Uuid _uuid;

  ReceiptRepositoryImpl(this._appDatabase, this._uuid);

  @override
  Future<ReceiptModel?> createInvoiceHeaderAndDetail(ReceiptEntity receiptEntity) async {
    try {
      final String generatedInvoiceHeaderDocId = _uuid.v4();
      final Database db = await _appDatabase.getDB();

      final prefs = GetIt.instance<SharedPreferences>();
      final itemDP = await GetIt.instance<GetDownPaymentUseCase>().call();
      final tcsr1IdPref = prefs.getString('tcsr1Id');

      int countInv;
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 00, 00, 00, 000);
      final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      final invoices = await _appDatabase.invoiceHeaderDao.readBetweenDate(startDate, endDate);
      if (invoices != null) {
        countInv = invoices.length;
      } else {
        countInv = 0;
      }

      if (receiptEntity.employeeEntity == null) throw "Cashier information not provided";
      if (receiptEntity.customerEntity == null) throw "Customer information not provided";

      await db.transaction((txn) async {
        final POSParameterModel posParameterModel = (await _appDatabase.posParameterDao.readAll(txn: txn)).first;
        String? tohemId =
            receiptEntity.customerEntity?.tohemId ?? (await _appDatabase.employeeDao.readByEmpCode("99", txn))?.docId;
        if (tohemId == null) throw "Default employee not found";

        final InvoiceHeaderModel invoiceHeaderModel = InvoiceHeaderModel(
          docId: generatedInvoiceHeaderDocId, // dao
          createDate: null, // null kah? ini kan bosr punya
          updateDate: null, // null kah? ini kan bosr punya
          tostrId: posParameterModel.tostrId, // get di sini
          docnum: receiptEntity.docNum, // generate
          orderNo: countInv + 1, // generate
          tocusId: receiptEntity.customerEntity?.docId,
          tohemId: tohemId, // get di sini atau dari awal aja
          transDateTime: null, // dao
          timezone: Helpers.getTimezone(DateTime.now()),
          remarks: receiptEntity.remarks,
          subTotal: receiptEntity.subtotal,
          discPrctg: receiptEntity.discPrctg ?? 0,
          discAmount: receiptEntity.discAmount ?? 0,
          discountCard: 0,
          coupon: "",
          discountCoupun: receiptEntity.couponDiscount,
          taxPrctg: 0,
          taxAmount: receiptEntity.taxAmount,
          addCost: 0,
          rounding: receiptEntity.rounding,
          grandTotal: receiptEntity.grandTotal,
          changed: receiptEntity.changed ?? 0,
          totalPayment: receiptEntity.totalPayment!,
          tocsrId: posParameterModel.tocsrId, // get di sini
          docStatus: 0,
          sync: 0,
          syncCRM: 0,
          toinvTohemId: receiptEntity.employeeEntity!.docId, // get di sini
          refpos1: tcsr1IdPref, // get di sini
          refpos2: receiptEntity.refpos2 ?? "",
          tcsr1Id: tcsr1IdPref, // get di sini
          discHeaderManual: receiptEntity.discHeaderManual ?? 0, // get di sini
          discHeaderPromo: receiptEntity.discHeaderPromo ?? 0, // get di sini
          syncToBos: '', // get di sini
          paymentSuccess: '1', // get di sini
          salesTohemId: receiptEntity.salesTohemId ?? "",
        );
        log("INVOICE HEADER MODEL 1 - $invoiceHeaderModel");

        await _appDatabase.invoiceHeaderDao.create(data: invoiceHeaderModel, txn: txn);

        final List<InvoiceDetailModel> invoiceDetailModels = receiptEntity.receiptItems.asMap().entries.map((entry) {
          final int index = entry.key;
          final ReceiptItemEntity e = entry.value;
          return InvoiceDetailModel(
            docId: _uuid.v4(),
            createDate: null,
            updateDate: null,
            toinvId: generatedInvoiceHeaderDocId,
            lineNum: index + 1,
            docNum: receiptEntity.docNum,
            idNumber: (index + 1) * 10,
            toitmId: e.itemEntity.toitmId,
            quantity: e.quantity,
            sellingPrice: e.sellingPrice,
            discPrctg: e.discPrctg ?? 0,
            discAmount: e.discAmount ?? 0,
            totalAmount: e.totalAmount,
            taxPrctg: e.itemEntity.taxRate,
            promotionType: e.promos.isEmpty ? "" : e.promos.first.promoType.toString(),
            promotionId: e.promos.isEmpty ? "" : e.promos.first.promoId.toString(),
            remarks: e.remarks,
            editTime: DateTime.now(),
            cogs: 0,
            tovatId: e.itemEntity.tovatId,
            promotionTingkat: null,
            promoVoucherNo: null,
            baseDocId: null,
            baseLineDocId: null,
            includeTax: e.itemEntity.includeTax,
            tovenId: e.itemEntity.tovenId,
            tbitmId: e.itemEntity.tbitmId,
            discHeaderAmount: e.discHeaderAmount,
            subtotalAfterDiscHeader: e.subtotalAfterDiscHeader,
            tohemId: e.tohemId ?? "",
            refpos2: e.refpos2 ?? "",
            refpos3: e.refpos3 ?? "",
          );
        }).toList();

        log("invoiceDetailModels 1 - $invoiceDetailModels");

        final List<DownPaymentEntity> dps = receiptEntity.downPayments ?? [];

        if (dps.isNotEmpty && dps.any((dp) => dp.isReceive == false && dp.isSelected == true)) {
          if (itemDP != null) {
            final List<InvoiceDetailModel> dpModels =
                dps.where((dp) => dp.isReceive == false && dp.isSelected == true).toList().asMap().entries.map((entry) {
              final int index = entry.key;
              final DownPaymentEntity dp = entry.value;

              return InvoiceDetailModel(
                docId: _uuid.v4(),
                createDate: null,
                updateDate: null,
                toinvId: generatedInvoiceHeaderDocId,
                lineNum: invoiceDetailModels.length + index + 1,
                docNum: receiptEntity.docNum,
                idNumber: (invoiceDetailModels.length + index + 1) * 10,
                toitmId: itemDP.toitmId,
                quantity: -1,
                sellingPrice: dp.amount,
                discPrctg: 0,
                discAmount: 0,
                totalAmount: dp.amount,
                taxPrctg: 0,
                promotionType: "",
                promotionId: "",
                remarks: "",
                editTime: DateTime.now(),
                cogs: 0,
                tovatId: itemDP.tovatId,
                promotionTingkat: null,
                promoVoucherNo: null,
                baseDocId: null,
                baseLineDocId: null,
                includeTax: itemDP.includeTax,
                tovenId: itemDP.tovenId,
                tbitmId: itemDP.tbitmId,
                discHeaderAmount: 0,
                subtotalAfterDiscHeader: dp.amount,
                tohemId: "",
                refpos2: dp.refpos2,
                refpos3: dp.refpos3 ?? "",
              );
            }).toList();

            invoiceDetailModels.addAll(dpModels);
          } else {
            throw "No 'Item' DP found";
          }
        }

        log("INVOICE DETAIL MODEL 11 - $invoiceDetailModels");
        await _appDatabase.invoiceDetailDao.bulkCreate(data: invoiceDetailModels, txn: txn);

        // log("ReceiptEntityMOP - ${receiptEntity.mopSelections}");
        final List<PayMeansModel> payMeansModels = [];
        for (final MopSelectionEntity mopSelectionEntity in receiptEntity.mopSelections) {
          // log("mopSelectionEntityIMPL - $mopSelectionEntity");
          payMeansModels.add(PayMeansModel(
              docId: _uuid.v4(),
              createDate: null,
              updateDate: null,
              toinvId: generatedInvoiceHeaderDocId,
              lineNum: 1,
              tpmt3Id: mopSelectionEntity.tpmt3Id,
              amount: mopSelectionEntity.payTypeCode == "1"
                  ? (mopSelectionEntity.amount ?? 0) - (receiptEntity.changed ?? 0)
                  : mopSelectionEntity.amount ?? 0,
              tpmt2Id: mopSelectionEntity.tpmt2Id,
              cardNo: mopSelectionEntity.cardNo,
              cardHolder: mopSelectionEntity.cardHolder,
              sisaVoucher: null,
              rrn: mopSelectionEntity.rrn,
              tpmt6Id: mopSelectionEntity.tpmt6Id));
        }

        await _appDatabase.payMeansDao.bulkCreate(data: payMeansModels, txn: txn);
        // log("payMeansModels - $payMeansModels");

        List<VouchersSelectionEntity> vouchers = receiptEntity.vouchers;
        // log("vouchers - $vouchers");

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
              rrn: null,
              tpmt6Id: null);

          await _appDatabase.payMeansDao.create(data: paymeansModel, txn: txn);
          vouchers = vouchers.map((voucher) {
            voucher.tinv2Id = paymeansModel.docId;
            return voucher;
          }).toList();
        }

        final List<VouchersSelectionModel> vouchersModel = vouchers.asMap().entries.map((entry) {
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

        final Map<int, String> indexToDocIdMap = {
          for (var e in invoiceDetailModels.asMap().entries) e.key: e.value.docId
        };

        final List<InvoiceAppliedPromoModel> invoiceAppliedPromoModels =
            receiptEntity.receiptItems.asMap().entries.expand((entry) {
          final int index = entry.key;
          final ReceiptItemEntity receiptItem = entry.value;
          final String invoiceDetailDocId = indexToDocIdMap[index]!;
          return receiptItem.promos.map((promo) {
            return InvoiceAppliedPromoModel(
              docId: _uuid.v4(),
              createDate: DateTime.now(),
              updateDate: null,
              toinvDocId: generatedInvoiceHeaderDocId,
              tinv1DocId: invoiceDetailDocId,
              promotionType: promo.promoType.toString(),
              promotionDocId: promo.promoId,
              amount: promo.discAmount ?? 0.0,
            );
          });
        }).toList();

        log("invoiceAppliedPromoModels 1 - $invoiceAppliedPromoModels");
        await _appDatabase.invoiceAppliedPromoDao.bulkCreate(data: invoiceAppliedPromoModels, txn: txn);

        final List<InvoiceAppliedPromoModel> appliedCoupons = receiptEntity.promos
            .where((element) => element.promoType == 107)
            .toList()
            .map((promo) => InvoiceAppliedPromoModel(
                  docId: _uuid.v4(),
                  createDate: DateTime.now(),
                  updateDate: null,
                  toinvDocId: generatedInvoiceHeaderDocId,
                  tinv1DocId: null,
                  promotionType: promo.promoType.toString(),
                  promotionDocId: promo.promoId,
                  amount: promo.discAmount ?? 0.0,
                ))
            .toList();

        await _appDatabase.invoiceAppliedPromoDao.bulkCreate(data: appliedCoupons, txn: txn);

        if (invoiceHeaderModel.discHeaderManual != 0) {
          final invoiceAppHeader = InvoiceAppliedPromoModel(
            docId: _uuid.v4(),
            createDate: DateTime.now(),
            updateDate: null,
            toinvDocId: generatedInvoiceHeaderDocId,
            tinv1DocId: null,
            promotionType: "999",
            promotionDocId: null,
            amount: invoiceHeaderModel.discAmount - (invoiceHeaderModel.discHeaderPromo ?? 0),
          );
          // log("invoiceAppHeader - $invoiceAppHeader");
          await _appDatabase.invoiceAppliedPromoDao.create(data: invoiceAppHeader, txn: txn);
        }

        if (receiptEntity.approvals != null) {
          final List<ApprovalInvoiceModel> approvalsModel = [];
          for (final ApprovalInvoiceEntity approvalEntity in receiptEntity.approvals!) {
            approvalsModel.add(ApprovalInvoiceModel(
              docId: approvalEntity.docId,
              createDate: approvalEntity.createDate,
              updateDate: approvalEntity.updateDate,
              toinvId: generatedInvoiceHeaderDocId,
              tousrId: approvalEntity.tousrId,
              remarks: approvalEntity.remarks,
              category: approvalEntity.category,
            ));
          }
          await _appDatabase.approvalInvoiceDao.bulkCreate(data: approvalsModel, txn: txn);
          // log("approvalsModel - $approvalsModel");
        }

        // save DownPaymentItems Here
        if (receiptEntity.downPayments != null &&
            receiptEntity.downPayments!.isNotEmpty &&
            receiptEntity.downPayments!.any((dp) => dp.isReceive == true)) {
          final List<DownPaymentItemsModel> dpItems = [];

          for (final DownPaymentEntity dpEntity in receiptEntity.downPayments!) {
            if (dpEntity.tinv7 != null && dpEntity.tinv7!.isNotEmpty) {
              for (final DownPaymentItemsEntity item in dpEntity.tinv7!) {
                dpItems.add(DownPaymentItemsModel(
                  docId: item.docId,
                  createDate: item.createDate,
                  updateDate: item.updateDate,
                  toinvId: generatedInvoiceHeaderDocId,
                  docNum: item.docNum,
                  idNumber: item.idNumber,
                  toitmId: item.toitmId,
                  quantity: item.quantity,
                  sellingPrice: item.sellingPrice,
                  totalAmount: item.totalAmount,
                  // taxPrctg: item.taxPrctg,
                  remarks: item.remarks,
                  tovatId: item.tovatId,
                  includeTax: item.includeTax,
                  tovenId: item.tovenId,
                  tbitmId: item.tbitmId,
                  tohemId: item.tohemId,
                  refpos2: dpEntity.refpos2,
                  qtySelected: item.qtySelected,
                  isSelected: 0,
                ));
              }
            }
          }
          await _appDatabase.downPaymentItemsDao.bulkCreate(data: dpItems, txn: txn);
        }
      });

      return await getReceiptByInvoiceHeaderDocId(generatedInvoiceHeaderDocId, null);
    } catch (e) {
      log("e - $e");
      rethrow;
    }
  }

  @override
  Future<ReceiptModel?> getReceiptByInvoiceHeaderDocId(String docId, Transaction? txn) async {
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

    await db.transaction((finaltxn) async {
      // final Transaction finaltxn = txn ?? txn1;
      final InvoiceHeaderModel? invoiceHeaderModel = await _appDatabase.invoiceHeaderDao.readByDocId(docId, finaltxn);
      log("TOINV getReceipt - $invoiceHeaderModel");

      if (invoiceHeaderModel == null) {
        throw "Invoice header not found";
      }
      final CustomerModel? customerModel = invoiceHeaderModel.tocusId != null
          ? await _appDatabase.customerDao.readByDocId(invoiceHeaderModel.tocusId!, finaltxn)
          : null;

      final EmployeeModel? employeeModel = invoiceHeaderModel.tohemId != null
          ? await _appDatabase.employeeDao.readByDocId(invoiceHeaderModel.toinvTohemId!, finaltxn)
          : null;

      final List<MopSelectionModel> mopSelectionModels =
          await _appDatabase.payMeansDao.readMopSelectionsByToinvId(docId, finaltxn);
      final List<MopSelectionModel> mopSelectionModelsWithoutVoucher =
          mopSelectionModels.where((element) => element.payTypeCode != "6").toList();
      log("mopSelectionModelsWithoutVoucher - $mopSelectionModelsWithoutVoucher");

      final List<InvoiceDetailModel> invoiceDetailModels =
          await _appDatabase.invoiceDetailDao.readByToinvId(docId, finaltxn);

      List<ReceiptItemModel> receiptItemModels = [];
      for (final invoiceDetailModel in invoiceDetailModels) {
        final ItemMasterModel? itemMasterModel =
            await _appDatabase.itemMasterDao.readByDocId(invoiceDetailModel.toitmId!, finaltxn);
        if (itemMasterModel == null) throw "Item not found";

        final ItemBarcodeModel? itemBarcodeModel =
            await _appDatabase.itemBarcodeDao.readByDocId(invoiceDetailModel.tbitmId!, finaltxn);
        if (itemBarcodeModel == null) throw "Barcode not found";

        final List<InvoiceAppliedPromoModel> invoiceAppliedPromoModels = await _appDatabase.invoiceAppliedPromoDao
            .readByToinvIdAndTinv1Id(invoiceHeaderModel.docId ?? "", invoiceDetailModel.docId, finaltxn);

        receiptItemModels.add(ReceiptItemModel(
          quantity: invoiceDetailModel.quantity,
          totalGross: ((invoiceDetailModel.totalAmount * 100 / (100 + invoiceDetailModel.taxPrctg)) +
              invoiceDetailModel.discAmount +
              (invoiceDetailModel.discHeaderAmount ?? 0)),
          taxAmount: invoiceDetailModel.totalAmount * (invoiceDetailModel.taxPrctg / 100),
          itemEntity: ItemModel(
            id: null,
            itemName: itemMasterModel.itemName,
            itemCode: itemMasterModel.itemCode,
            barcode: itemBarcodeModel.barcode,
            price: invoiceDetailModel.sellingPrice,
            toitmId: itemMasterModel.docId,
            tbitmId: invoiceDetailModel.tbitmId!,
            tpln2Id: "N/A",
            openPrice: itemMasterModel.openPrice,
            tovenId: invoiceDetailModel.tovenId,
            tovatId: invoiceDetailModel.tovatId!,
            taxRate: invoiceDetailModel.taxPrctg,
            dpp: invoiceDetailModel.sellingPrice * 100 / (100 + invoiceDetailModel.taxPrctg),
            includeTax: itemMasterModel.includeTax,
            tocatId: itemMasterModel.tocatId,
            shortName: itemMasterModel.shortName,
            toplnId: "N/A",
          ),
          sellingPrice: invoiceDetailModel.sellingPrice,
          totalAmount: invoiceDetailModel.totalAmount,
          totalSellBarcode: invoiceDetailModel.sellingPrice * invoiceDetailModel.quantity,
          promos: invoiceAppliedPromoModels
              .map((e) => PromotionsEntity(
                  docId: "",
                  toitmId: invoiceDetailModel.toitmId,
                  promoType: int.parse(e.promotionType),
                  promoId: e.promotionDocId,
                  date: DateTime.now(),
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                  promoDescription: "Line Discount",
                  discAmount: e.amount))
              .toList(),
          tohemId: invoiceDetailModel.tohemId,
          discAmount: invoiceDetailModel.discAmount,
          refpos3: invoiceDetailModel.refpos3,
        ));
      }

      List<VouchersSelectionModel> voucherModels = [];
      List<PromotionsModel> promoModels = [];
      int totalVoucherAmount = 0;

      for (var mopSelectionModel in mopSelectionModels) {
        if (mopSelectionModel.payTypeCode == "6") {
          List<VouchersSelectionModel> vouchers = await GetIt.instance<AppDatabase>()
              .vouchersSelectionDao
              .readBytinv2Id(mopSelectionModel.tinv2Id ?? "", txn: finaltxn);
          voucherModels.addAll(vouchers);
        }
      }

      for (var voucherModel in voucherModels) {
        totalVoucherAmount += voucherModel.voucherAmount;
      }

      receiptModel = ReceiptModel(
        toinvId: invoiceHeaderModel.docId,
        receiptItems: receiptItemModels,
        subtotal: invoiceHeaderModel.subTotal,
        docNum: invoiceHeaderModel.docnum,
        totalTax: invoiceHeaderModel.taxAmount,
        mopSelections: mopSelectionModelsWithoutVoucher,
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
        totalNonVoucher: invoiceHeaderModel.totalPayment - totalVoucherAmount,
        promos: promoModels,
        discHeaderManual: invoiceHeaderModel.discHeaderManual,
        discHeaderPromo: invoiceHeaderModel.discHeaderPromo,
        discAmount: invoiceHeaderModel.discAmount,
        rounding: invoiceHeaderModel.rounding,
        toinvTohemId: invoiceHeaderModel.toinvTohemId,
        salesTohemId: invoiceHeaderModel.salesTohemId,
      );
    });
    log("Receipt getReceipt - $receiptModel");
    return receiptModel;
  }
}
