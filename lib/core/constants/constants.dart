import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  //TOKEN
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImludGVyZmFjaW5nQGRlbW8uY29tIiwiZ3RlbnRJZCI6ImI1NjNlZTc0LTAzZmQtNGVhMy1iNmE1LTBkYzA2MDdlZjhmYiIsInRvdXNySWQiOiJmYWIwNTZmYS1iMjA2LTQzNjAtOGMzNS01Njg0MDc2NTE4MjciLCJ0b3JvbElkIjoiM2I0ZDEyYzEtYjNmNi00ODQ0LThlMzEtMTk3YTM1ODc4MzdjIiwiaWF0IjoxNzExMzU0MTI5LCJleHAiOjE3MTI1NjM3Mjl9.4EFtonsZ0-zpY3O7p2Wdj_Es-j8_ANlNAw8O9IqkGfA';

  //CRON
  static String weekday = '*';
  static String month = '*';
  static String day = '*';
  static String hour = '*';
  static String minute = '*/60';
  static String second = '*';

  //TENANTID
  static String gtentId = '';

  //STOREID
  static String tostrId = '';

  //CASHIERID
  static String tocsrId = '';

  // BASEURL
  static String url = "http://110.239.68.248:8803";

  static void updateTopos(String tenantId, String storeId,
      String cashRegisterId, String baseUrl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('gtentId', tenantId);
    prefs.setString('tostrId', storeId);
    prefs.setString('tocsrId', tenantId);
    prefs.setString('baseUrl', baseUrl);

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
