import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/routes/router.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/features/home/domain/usecases/get_app_version.dart';
import 'package:pos_fe/core/usecases/generate_device_number_usecase.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/login/data/repository/user_auth_repository_impl.dart';
import 'package:pos_fe/features/login/domain/repository/user_auth_repository.dart';
import 'package:pos_fe/features/login/domain/usecase/login.dart';
import 'package:pos_fe/features/reports/data/data_source/remote/check_stock_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/netzme_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/otp_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/vouchers_selection_service.dart';
import 'package:pos_fe/features/sales/data/repository/campaign_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/cash_register_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/credit_card_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/customer_group_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/customer_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/employee_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/item_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/mop_selection_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/pos_parameter_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/promos_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/queued_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/receipt_content_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/receipt_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/store_master_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/user_repository_impl.dart';
import 'package:pos_fe/features/sales/data/repository/vouchers_selection_repository_impl.dart';
import 'package:pos_fe/features/sales/domain/repository/campaign_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/cash_register_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/credit_card_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_group_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/pos_paramater_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/promos_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_content_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/user_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/vouchers_selection_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_topdg.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_topdi.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_topdg_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promo_topdi_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_voucher.dart';
import 'package:pos_fe/features/sales/domain/usecases/create_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_all_queued_receipts.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_campaigns_usecase.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_credit_cards.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employees.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_with_and_condition.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items_by_pricelist.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_mop_selections.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart' as sales_get_pos_parameter_use_case;
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdg_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_promo_topdi_header_and_detail.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_queued_receipts.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_user.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_open_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_buy_x_get_y.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_special_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdg.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdi.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_close_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_open_shift.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_qris_payment.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_tax.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/settings/data/data_sources/local/user_masters_dao.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/assign_price_member_per_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/auth_store_services.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/authorization_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/bank_issuer_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/bill_of_material_line_item_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/bill_of_material_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/campaign_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/cash_register_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/cashier_balance_transactions_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/country_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/credit_card_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/currency_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/customer_group_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/customer_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/edc_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/employee_services.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/invoice_detail_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/invoice_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_barcode_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_by_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_category_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_picture_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/item_remarks_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/mop_adjustment_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/mop_by_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/mop_masters_servive.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/pay_means_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/payment_type_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/preferred_vendor_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/price_by_item_barcode_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/price_by_item_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/pricelist_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/pricelist_period_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/product_hierarchy_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/product_hierarchy_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_bonus_multi_item_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_buy_x_get_y_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_coupon_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_coupon_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_coupon_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_group_item_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_assign_store_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_buy_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_get_condition_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_diskon_item_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_assign_store.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_buy_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_customer_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/promo_harga_spesial_header_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/province_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/store_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/tax_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/token_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/uom_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/user_masters_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/user_role_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/vendor_group_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/vendor_service.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/zipcode_service.dart';
import 'package:pos_fe/features/settings/domain/usecases/check_credential_active_status.dart';
import 'package:pos_fe/features/settings/domain/usecases/decrypt.dart';
import 'package:pos_fe/features/settings/domain/usecases/encrypt.dart';
import 'package:pos_fe/features/settings/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/settings/domain/usecases/refresh_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  /**
   * =================================
   * PACKAGE AND RESOURCES
   * =================================
   */

  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<GoRouter>(AppRouter().router);
  sl.registerSingletonAsync<AppDatabase>(() => AppDatabase.init());
  sl.registerSingleton<Uuid>(const Uuid());
  sl.registerSingleton<DeviceInfoPlugin>(DeviceInfoPlugin());
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerSingletonAsync<ReceiptPrinter>(() => ReceiptPrinter.init(), dependsOn: [SharedPreferences]);
  /**
   * =================================
   * END OF PACKAGE AND RESOURCES
   * =================================
   */

  /**
   * =================================
   * APIs
   * =================================
   */
  sl.registerSingleton<TokenApi>(TokenApi(sl()));
  sl.registerSingleton<UoMApi>(UoMApi(sl()));
  sl.registerSingleton<AuthorizationApi>(AuthorizationApi(sl()));
  sl.registerSingleton<APMPSApi>(APMPSApi(sl()));
  sl.registerSingleton<ItemBarcodeApi>(ItemBarcodeApi(sl()));
  sl.registerSingleton<ItemRemarksApi>(ItemRemarksApi(sl()));
  sl.registerSingleton<ItemByStoreApi>(ItemByStoreApi(sl()));
  sl.registerSingleton<CashRegisterApi>(CashRegisterApi(sl()));
  sl.registerSingleton<CurrencyApi>(CurrencyApi(sl()));
  sl.registerSingleton<CountryApi>(CountryApi(sl()));
  sl.registerSingleton<ProvinceApi>(ProvinceApi(sl()));
  sl.registerSingleton<ZipcodeApi>(ZipcodeApi(sl()));
  sl.registerSingleton<EmployeeApi>(EmployeeApi(sl()));
  sl.registerSingleton<TaxMasterApi>(TaxMasterApi(sl()));
  sl.registerSingleton<PaymentTypeApi>(PaymentTypeApi(sl()));
  sl.registerSingleton<MOPApi>(MOPApi(sl()));
  sl.registerSingleton<MOPByStoreApi>(MOPByStoreApi(sl()));
  sl.registerSingleton<CustomerGroupApi>(CustomerGroupApi(sl()));
  sl.registerSingleton<CustomerApi>(CustomerApi(sl()));
  sl.registerSingleton<CreditCardApi>(CreditCardApi(sl()));
  sl.registerSingleton<StoreMasterApi>(StoreMasterApi(sl()));
  sl.registerSingleton<PriceByItemBarcodeApi>(PriceByItemBarcodeApi(sl()));
  sl.registerSingleton<PriceByItemApi>(PriceByItemApi(sl()));
  sl.registerSingleton<UserApi>(UserApi(sl()));
  sl.registerSingleton<UserRoleApi>(UserRoleApi(sl()));
  sl.registerSingletonWithDependencies<UsersDao>(() => UsersDao(sl()), dependsOn: [AppDatabase]);
  sl.registerSingleton<ItemCategoryApi>(ItemCategoryApi(sl()));
  sl.registerSingleton<ItemMasterApi>(ItemMasterApi(sl()));
  sl.registerSingleton<ItemPictureApi>(ItemPictureApi(sl()));
  sl.registerSingleton<PricelistApi>(PricelistApi(sl()));
  sl.registerSingleton<PricelistPeriodApi>(PricelistPeriodApi(sl()));
  sl.registerSingleton<ProductHierarchyMasterApi>(ProductHierarchyMasterApi(sl()));
  sl.registerSingleton<ProductHierarchyApi>(ProductHierarchyApi(sl()));
  sl.registerSingleton<VendorGroupApi>(VendorGroupApi(sl()));
  sl.registerSingleton<VendorApi>(VendorApi(sl()));
  sl.registerSingleton<PreferredVendorApi>(PreferredVendorApi(sl()));
  sl.registerSingleton<InvoiceHeaderApi>(InvoiceHeaderApi(sl()));
  sl.registerSingleton<InvoiceDetailApi>(InvoiceDetailApi(sl()));
  sl.registerSingletonWithDependencies<InvoiceApi>(() => InvoiceApi(sl(), sl()), dependsOn: [SharedPreferences]);
  sl.registerSingleton<PayMeansApi>(PayMeansApi(sl()));
  sl.registerSingleton<VouchersSelectionApi>(VouchersSelectionApi(sl()));
  sl.registerSingleton<PromoHargaSpesialApi>(PromoHargaSpesialApi(sl()));
  sl.registerSingleton<PromoHargaSpesialBuyApi>(PromoHargaSpesialBuyApi(sl()));
  sl.registerSingleton<PromoHargaSpesialAssignStoreApi>(PromoHargaSpesialAssignStoreApi(sl()));
  sl.registerSingleton<PromoHargaSpesialCustomerGroupApi>(PromoHargaSpesialCustomerGroupApi(sl()));
  sl.registerSingleton<PromoBonusMultiItemHeaderApi>(PromoBonusMultiItemHeaderApi(sl()));
  sl.registerSingleton<PromoBonusMultiItemBuyConditionApi>(PromoBonusMultiItemBuyConditionApi(sl()));
  sl.registerSingleton<PromoBonusMultiItemAssignStoreApi>(PromoBonusMultiItemAssignStoreApi(sl()));
  sl.registerSingleton<PromoBonusMultiItemGetConditionApi>(PromoBonusMultiItemGetConditionApi(sl()));
  sl.registerSingleton<PromoBonusMultiItemCustomerGroupApi>(PromoBonusMultiItemCustomerGroupApi(sl()));
  sl.registerSingleton<PromoDiskonItemHeaderApi>(PromoDiskonItemHeaderApi(sl()));
  sl.registerSingleton<PromoDiskonItemBuyConditionApi>(PromoDiskonItemBuyConditionApi(sl()));
  sl.registerSingleton<PromoDiskonItemAssignStoreApi>(PromoDiskonItemAssignStoreApi(sl()));
  sl.registerSingleton<PromoDiskonItemGetConditionApi>(PromoDiskonItemGetConditionApi(sl()));
  sl.registerSingleton<PromoDiskonItemCustomerGroupApi>(PromoDiskonItemCustomerGroupApi(sl()));
  sl.registerSingleton<PromoDiskonGroupItemHeaderApi>(PromoDiskonGroupItemHeaderApi(sl()));
  sl.registerSingleton<PromoDiskonGroupItemBuyConditionApi>(PromoDiskonGroupItemBuyConditionApi(sl()));
  sl.registerSingleton<PromoDiskonGroupItemAssignStoreApi>(PromoDiskonGroupItemAssignStoreApi(sl()));
  sl.registerSingleton<PromoDiskonGroupItemGetConditionApi>(PromoDiskonGroupItemGetConditionApi(sl()));
  sl.registerSingleton<PromoDiskonGroupItemCustomerGroupApi>(PromoDiskonGroupItemCustomerGroupApi(sl()));
  sl.registerSingleton<PromoBuyXGetYHeaderApi>(PromoBuyXGetYHeaderApi(sl()));
  sl.registerSingleton<PromoBuyXGetYBuyConditionApi>(PromoBuyXGetYBuyConditionApi(sl()));
  sl.registerSingleton<PromoBuyXGetYAssignStoreApi>(PromoBuyXGetYAssignStoreApi(sl()));
  sl.registerSingleton<PromoBuyXGetYGetConditionApi>(PromoBuyXGetYGetConditionApi(sl()));
  sl.registerSingleton<PromoBuyXGetYCustomerGroupApi>(PromoBuyXGetYCustomerGroupApi(sl()));
  sl.registerSingleton<PromoCouponHeaderApi>(PromoCouponHeaderApi(sl()));
  sl.registerSingleton<PromoCouponAssignStoreApi>(PromoCouponAssignStoreApi(sl()));
  sl.registerSingleton<PromoCouponCustomerGroupApi>(PromoCouponCustomerGroupApi(sl()));
  sl.registerSingleton<AuthStoreApi>(AuthStoreApi(sl()));
  sl.registerSingleton<NetzmeApi>(NetzmeApi(sl()));
  sl.registerSingleton<BillOfMaterialApi>(BillOfMaterialApi(sl()));
  sl.registerSingleton<BillOfMaterialLineItemApi>(BillOfMaterialLineItemApi(sl()));
  sl.registerSingleton<EDCApi>(EDCApi(sl()));
  sl.registerSingleton<BankIssuerApi>(BankIssuerApi(sl()));
  sl.registerSingleton<CampaignApi>(CampaignApi(sl()));
  sl.registerSingletonWithDependencies<MOPAdjustmentService>(() => MOPAdjustmentService(sl(), sl()),
      dependsOn: [SharedPreferences]);
  sl.registerSingletonWithDependencies<OTPServiceAPi>(() => OTPServiceAPi(sl()), dependsOn: [SharedPreferences]);
  sl.registerSingleton<CheckStockApi>(CheckStockApi(sl()));
  /**
   * =================================
   * END OF APIs
   * =================================
   */

  /**
   * =================================
   * REPOSITORIES
   * =================================
   */
  sl.registerSingletonWithDependencies<ItemRepository>(() => ItemRepositoryImpl(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CustomerRepository>(() => CustomerRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<MopSelectionRepository>(() => MopSelectionRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<ReceiptRepository>(() => ReceiptRepositoryImpl(sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<POSParameterRepository>(() => POSParameterRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<StoreMasterRepository>(() => StoreMasterRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<ReceiptContentRepository>(() => ReceiptContentRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<UserAuthRepository>(() => UserAuthRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<EmployeeRepository>(() => EmployeeRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CreditCardRepository>(() => CreditCardRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CampaignRepository>(() => CampaignRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<QueuedReceiptRepository>(() => QueuedReceiptRepositoryImpl(sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<VouchersSelectionRepository>(() => VouchersSelectionRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<PromotionsRepository>(() => PromotionsRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CashRegisterRepository>(() => CashRegisterRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<UserRepository>(() => UserRepositoryImpl(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CustomerGroupRepository>(() => CustomerGroupRepositoryImpl(sl()),
      dependsOn: [AppDatabase]);
  /**
   * =================================
   * END OF REPOSITORIES
   * =================================
   */

  /**
   * =================================
   * USECASES
   * =================================
   */
  sl.registerSingletonWithDependencies<GetItemsUseCase>(() => GetItemsUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetItemsByPricelistUseCase>(() => GetItemsByPricelistUseCase(sl(), sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetItemUseCase>(() => GetItemUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetItemByBarcodeUseCase>(() => GetItemByBarcodeUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetItemWithAndConditionUseCase>(() => GetItemWithAndConditionUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetCustomersUseCase>(() => GetCustomersUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetMopSelectionsUseCase>(() => GetMopSelectionsUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<SaveReceiptUseCase>(() => SaveReceiptUseCase(sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<QueueReceiptUseCase>(() => QueueReceiptUseCase(sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<GetQueuedReceiptsUseCase>(() => GetQueuedReceiptsUseCase(sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<DeleteQueuedReceiptUseCase>(() => DeleteQueuedReceiptUseCase(sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<DeleteAllQueuedReceiptsUseCase>(() => DeleteAllQueuedReceiptsUseCase(sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<PrintReceiptUseCase>(() => PrintReceiptUseCase(sl(), sl(), sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<OpenCashDrawerUseCase>(() => OpenCashDrawerUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<PrintOpenShiftUsecase>(() => PrintOpenShiftUsecase(sl(), sl(), sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<PrintCloseShiftUsecase>(() => PrintCloseShiftUsecase(sl(), sl(), sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<PrintQrisUseCase>(() => PrintQrisUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetPosParameterUseCase>(() => GetPosParameterUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<sales_get_pos_parameter_use_case.GetPosParameterUseCase>(
      () => sales_get_pos_parameter_use_case.GetPosParameterUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<LoginUseCase>(() => LoginUseCase(sl(), sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<LogoutUseCase>(() => LogoutUseCase(sl()), dependsOn: [SharedPreferences]);
  sl.registerSingletonWithDependencies<GetEmployeeUseCase>(() => GetEmployeeUseCase(sl(), sl()),
      dependsOn: [AppDatabase, SharedPreferences]);
  sl.registerSingletonWithDependencies<GetStoreMasterUseCase>(() => GetStoreMasterUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CheckVoucherUseCase>(() => CheckVoucherUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CreatePromotionsUseCase>(() => CreatePromotionsUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CheckPromoUseCase>(() => CheckPromoUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetCashRegisterUseCase>(() => GetCashRegisterUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetUserUseCase>(() => GetUserUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<RecalculateTaxUseCase>(() => RecalculateTaxUseCase(), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetEmployeesUseCase>(() => GetEmployeesUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetCreditCardUseCase>(() => GetCreditCardUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<GetCampaignUseCase>(() => GetCampaignUseCase(sl()), dependsOn: [AppDatabase]);
  sl.registerSingleton<HandleOpenPriceUseCase>(HandleOpenPriceUseCase());
  sl.registerSingleton<HandleWithoutPromosUseCase>(HandleWithoutPromosUseCase());
  sl.registerSingleton<HandlePromosUseCase>(HandlePromosUseCase(sl()));
  sl.registerSingleton<RecalculateReceiptUseCase>(RecalculateReceiptUseCase());
  // toprb usecases
  sl.registerSingleton<CheckBuyXGetYApplicabilityUseCase>(CheckBuyXGetYApplicabilityUseCase());
  sl.registerSingleton<HandlePromoBuyXGetYUseCase>(HandlePromoBuyXGetYUseCase());
  // topsb usecases
  sl.registerSingleton<HandlePromoSpecialPriceUseCase>(HandlePromoSpecialPriceUseCase());
  // topdg usecases
  sl.registerSingleton<GetPromoTopdgHeaderAndDetailUseCase>(GetPromoTopdgHeaderAndDetailUseCase());
  sl.registerSingletonWithDependencies<CheckPromoTopdgApplicabilityUseCase>(
      () => CheckPromoTopdgApplicabilityUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingleton<ApplyPromoTopdgUseCase>(ApplyPromoTopdgUseCase());
  sl.registerSingletonWithDependencies<HandlePromoTopdgUseCase>(() => HandlePromoTopdgUseCase(sl(), sl(), sl(), sl()),
      dependsOn: [CheckPromoTopdgApplicabilityUseCase]);
  // topdi usecases
  sl.registerSingleton<GetPromoTopdiHeaderAndDetailUseCase>(GetPromoTopdiHeaderAndDetailUseCase());
  sl.registerSingletonWithDependencies<CheckPromoTopdiApplicabilityUseCase>(
      () => CheckPromoTopdiApplicabilityUseCase(sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingleton<ApplyPromoTopdiUseCase>(ApplyPromoTopdiUseCase());
  sl.registerSingletonWithDependencies<HandlePromoTopdiUseCase>(() => HandlePromoTopdiUseCase(sl(), sl(), sl(), sl()),
      dependsOn: [CheckPromoTopdiApplicabilityUseCase]);
  // toprn usecases
  // sl.registerSingleton<GetPromoToprnHeaderUseCase>(GetPromoToprnHeaderUseCase());
  // sl.registerSingleton<ApplyPromoToprnUseCase>(ApplyPromoToprnUseCase());
  // sl.registerSingletonWithDependencies<CheckPromoToprnApplicabilityUseCase>(
  //   () => CheckPromoToprnApplicabilityUseCase(),
  // );
  // sl.registerSingleton<RecalculateReceiptByToprnUseCase>(RecalculateReceiptByToprnUseCase());
  // sl.registerSingletonWithDependencies<HandlePromoToprnUseCase>(
  //   () => HandlePromoToprnUseCase(sl(), sl(), sl()),
  // );

  sl.registerSingletonWithDependencies<CashierBalanceTransactionApi>(() => CashierBalanceTransactionApi(sl(), sl()),
      dependsOn: [SharedPreferences]);
  sl.registerSingletonWithDependencies<ApplyRoundingUseCase>(() => ApplyRoundingUseCase(sl(), sl()),
      dependsOn: [AppDatabase]);
  sl.registerSingletonWithDependencies<CheckCredentialActiveStatusUseCase>(
      () => CheckCredentialActiveStatusUseCase(sl()),
      dependsOn: [SharedPreferences]);
  sl.registerSingleton<EncryptPasswordUseCase>(EncryptPasswordUseCase());
  sl.registerSingleton<DecryptPasswordUseCase>(DecryptPasswordUseCase());
  sl.registerSingleton<RefreshTokenUseCase>(RefreshTokenUseCase());
  sl.registerSingleton<GenerateDeviceNumberUseCase>(GenerateDeviceNumberUseCase(sl(), sl()));
  sl.registerSingleton<GetAppVersionUseCase>(GetAppVersionUseCase());
  /**
   * =================================
   * END OF USECASES
   * =================================
   */

  return;
}
