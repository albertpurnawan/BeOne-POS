import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  //TOKEN
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImludGVyZmFjaW5nQGRlbW8uY29tIiwiZ3RlbnRJZCI6ImI1NjNlZTc0LTAzZmQtNGVhMy1iNmE1LTBkYzA2MDdlZjhmYiIsInRvdXNySWQiOiJmYWIwNTZmYS1iMjA2LTQzNjAtOGMzNS01Njg0MDc2NTE4MjciLCJ0b3JvbElkIjoiM2I0ZDEyYzEtYjNmNi00ODQ0LThlMzEtMTk3YTM1ODc4MzdjIiwiaWF0IjoxNzEyOTEyOTk3LCJleHAiOjE3MTQxMjI1OTd9.DC34RnVNjdQm1mKJBJOW41GMS5b0346MYWmZ17M90z4';

  //CRON
  static String weekday = '*';
  static String month = '*';
  static String day = '*';
  static String hour = '23';
  static String minute = '0';
  static String second = '*';

  //TENANTID
  static String gtentId = 'b563ee74-03fd-4ea3-b6a5-0dc0607ef8fb';
  // b563ee74-03fd-4ea3-b6a5-0dc0607ef8fb

  //STOREID
  static String tostrId = 'e24bd658-bfb6-404f-b867-3e294b8d5b0b';
  // 878694e6-fdf4-49a7-82e3-d0facb685741
  // e24bd658-bfb6-404f-b867-3e294b8d5b0b

  //CASHIERID
  static String tocsrId = '018e3ba4-787b-7d59-bfcb-650396eaf0c3';
  // 4ca46d3e-30ff-4441-98f8-3fdcf81dc230
  // 018e3ba4-787b-7d59-bfcb-650396eaf0c3

  // BASEURL
  static String url = "http://110.239.68.248:8902";
  // http://110.239.68.248:8803
  // http://110.239.68.248:8902

  // EMAIL ADMIN
  static String emailAdmin = "interfacing@demo.com";

  // PASS ADMIN
  static String passwordAdmin = "BeOne\$\$123";
  // md5.convert(utf8.encode("BeOne\$\$123")).toString();

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
