import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  //TOKEN
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImludGVyZmFjaW5nQHRvcGdvbGYuY29tIiwiZ3RlbnRJZCI6ImI1NjNlZTc0LTAzZmQtNGVhMy1iNmE1LTBkYzA2MDdlZjhmYiIsInRvdXNySWQiOiJmYWIwNTZmYS1iMjA2LTQzNjAtOGMzNS01Njg0MDc2NTE4MjciLCJ0b3JvbElkIjoiM2I0ZDEyYzEtYjNmNi00ODQ0LThlMzEtMTk3YTM1ODc4MzdjIiwiaWF0IjoxNzEzNDM3MDIxLCJleHAiOjE3MTQ2NDY2MjF9.8udRdq8te1OfGD-ZmNYWIUKuC56_zvuyvomJ9OF5UDE';

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
  static String tostrId = '878694e6-fdf4-49a7-82e3-d0facb685741';
  //878694e6-fdf4-49a7-82e3-d0facb685741

  //CASHIERID
  static String tocsrId = '';
  //4ca46d3e-30ff-4441-98f8-3fdcf81dc230

  // BASEURL
  static String url = "http://110.239.68.248:8803";

  // EMAIL ADMIN
  static String emailAdmin = "interfacing@topgolf.com";

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
