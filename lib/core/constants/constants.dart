import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  //TOKEN
  static const String token = '';

  //CRON
  static String weekday = '*';
  static String month = '*';
  static String day = '*';
  static String hour = '*';
  static String minute = '*/5';
  static String second = '*';

  //TENANTID
  static String gtentId = '';
  // TenantId : b563ee74-03fd-4ea3-b6a5-0dc0607ef8fb

  //STOREID
  static String tostrId = '';
  // StoreId : e24bd658-bfb6-404f-b867-3e294b8d5b0b

  //CASHIERID
  static String tocsrId = '';
  // 4ca46d3e-30ff-4441-98f8-3fdcf81dc230
  // CashierId : c9d19f0c-8350-4494-8b97-a7262b14d74a

  // BASEURL
  static String url = "";
  // http://110.239.68.248:8803
  // BaseUrl: http://110.239.68.248:8902

  // EMAIL ADMIN
  static String emailAdmin = "";

  // PASS ADMIN
  static String passwordAdmin = "";

  static void updateTopos(
    String tenantId,
    String storeId,
    String cashRegisterId,
    String baseUrl,
    String emailAdmin,
    String passwordAdmin,
    String defaultDate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('gtentId', tenantId);
    prefs.setString('tostrId', storeId);
    prefs.setString('tocsrId', tenantId);
    prefs.setString('baseUrl', baseUrl);
    prefs.setString('emailAdmin', emailAdmin);
    prefs.setString('passwordAdmin', passwordAdmin);
    prefs.setString('defaultDate', defaultDate);

    gtentId = tenantId;
    tostrId = storeId;
    tocsrId = cashRegisterId;
  }

  static Future<void> loadTopos() async {
    final prefs = await SharedPreferences.getInstance();
    gtentId = prefs.getString('gtentId') ?? '';
    tostrId = prefs.getString('tostrId') ?? '';
    tocsrId = prefs.getString('tocsrId') ?? '';
  }
}
