// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// import 'package:pos_fe/features/sales/domain/entities/customer.dart';
// import 'package:pos_fe/features/sales/domain/entities/employee.dart';
// import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
// import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
// import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
// import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
// import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';

// class PreviousReceiptEntity extends ReceiptEntity {
//   String docNum;
//   List<ReceiptItemEntity> receiptItems;
//   MopSelectionEntity? mopSelection;
//   CustomerEntity? customerEntity;
//   EmployeeEntity? employeeEntity;
//   double totalTax;
//   DateTime? transDateTime;
//   DateTime transStart;
//   DateTime? transEnd;
//   double subtotal;
//   double taxAmount;
//   double grandTotal;
//   double? totalPayment;
//   double? changed;
//   String? toinvId;
//   List<VouchersSelectionEntity> vouchers;
//   int? totalVoucher;
//   double? totalNonVoucher;
//   List<PromotionsEntity> promos;
//   double? discAmount;
//   double? discPrctg;
//   double? discHeaderManual;
//   double? discHeaderPromo;

//   PreviousReceiptEntity({
//     required this.docNum,
//     required this.receiptItems,
//     this.mopSelection,
//     this.customerEntity,
//     this.employeeEntity,
//     required this.totalTax,
//     this.transDateTime,
//     required this.transStart,
//     this.transEnd,
//     required this.subtotal,
//     required this.taxAmount,
//     required this.grandTotal,
//     this.totalPayment,
//     this.changed,
//     this.toinvId,
//     required this.vouchers,
//     this.totalVoucher,
//     this.totalNonVoucher,
//     required this.promos,
//     this.discAmount,
//     this.discPrctg,
//     this.discHeaderManual,
//     this.discHeaderPromo,
//   }) : super(docNum: '', receiptItems: null);
// }
