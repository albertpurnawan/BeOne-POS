import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  //TOKEN
  static const String token = '';

  //CRON
  static String weekday = '*';
  static String month = '*';
  static String day = '*';
  static String hour = '23';
  static String minute = '0';
  static String second = '*';

  //TENANTID
  static String gtentId = '';
  // b563ee74-03fd-4ea3-b6a5-0dc0607ef8fb

  //STOREID
  static String tostrId = '';
  // 878694e6-fdf4-49a7-82e3-d0facb685741
  // e24bd658-bfb6-404f-b867-3e294b8d5b0b

  //CASHIERID
  static String tocsrId = '';
  // 4ca46d3e-30ff-4441-98f8-3fdcf81dc230
  // 529c9b55-67c6-47b3-9f9a-74a2b3e485a0

  // BASEURL
  static String url = "";
  // http://110.239.68.248:8803
  // http://110.239.68.248:8902

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
      String passwordAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('gtentId', tenantId);
    prefs.setString('tostrId', storeId);
    prefs.setString('tocsrId', tenantId);
    prefs.setString('baseUrl', baseUrl);
    prefs.setString('emailAdmin', emailAdmin);
    prefs.setString('passwordAdmin', passwordAdmin);

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
