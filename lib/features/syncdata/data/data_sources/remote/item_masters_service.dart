import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class ItemsApi {
  final Database db;
  final dio = Dio();
  String token = Constant.token;
  String storeId = Constant.storeId;
  String url = Constant.url;

  ItemsApi(this.db);

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      int page = 1;
      bool hasMoreData = true;
      List<Map<String, dynamic>> allData = [];

      while (hasMoreData) {
        final response = await dio.get(
          "$url/tenant-item-master/hierarchy?page=$page",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        final List<Map<String, dynamic>> data =
            response.data.cast<Map<String, dynamic>>();
        allData.addAll(data);

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          page++;
        }
      }
      // log(allData[0].toString());
      // for (var element in [allData[0]]) {
      //   element.forEach((key, value) {
      //     print('$key: ${value.runtimeType} $value');
      //   });
      // }

      return allData;
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchSingleData(String docid) async {
    try {
      final response = await dio.get(
        "$url/tenant-item-master/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log([response.data].toString());
      // for (var element in [response.data]) {
      //   element.forEach((key, value) {
      //     print('$key: ${value.runtimeType} $value');
      //   });
      // }

      return [response.data];
    } catch (err) {
      print('Error: $err');
      rethrow;
    }
  }
}


// [{id: 4, docid: ce7dc5da-b432-4bed-8123-8b1c4ca0fb97, createdate: 2023-10-03T08:23:18.000Z, createby: 2, updatedate: 2023-11-14T09:55:02.000Z, updateby: 2, gtent_id: {docid: b563ee74-03fd-4ea3-b6a5-0dc0607ef8fb}, itemcode: 9466012790007, itemname: Bellamys Organic Veggie Pasta Alphabets 200 Gr, invitem: 1, serialno: 0, tocat_id: {docid: ae0becb4-a0a8-404a-8f2b-304b52896924, catcode: 01001000100020002, catname: Bellamys Baby Pasta}, touom_id: {docid: 0a5fcead-61e6-449b-a81a-db7e4a716335, uomcode: Pc, uomdesc: Pc, statusactive: 1, activated: 0}, minstock: 1, maxstock: 100, includetax: 1, remarks: Brand, statusactive: 1, activated: 1, isbatch: 0, internalcode_1: , internalcode_2: , openprice: 1, popitem: 0, bpom: , expdate: , multiplyorder: 1, margin: 0, memberdiscount: 0, mergequantity: 1, property_1: null, property_2: null, property_3: null, property_4: null, property_5: null, property_6: null, property_7: null, property_8: null, property_9: null, property_10: null, tbitm: [{docid: f2cf27c2-1d01-4b5d-a458-8c17260a6274, createdate: 2023-10-03T08:24:09.000Z, createby: 2, updatedate: 2023-11-07T00:00:00.000Z, updateby: 2, barcode: 9332045000860, statusactive: 1, activated: 1, quantity: 1, touom_id: {docid: 0a5fcead-61e6-449b-a81a-db7e4a716335, uomcode: Pc, uomdesc: Pc}}], tsitm: [{docid: 99b44ace-2784-4c7c-9f9d-d3f8ed2be349, createdate: 2023-10-03T08:24:53.000Z, createby: 2, updatedate: 2023-12-17T09:57:06.000Z, updateby: 2, tostr_id: {docid: 878694e6-fdf4-49a7-82e3-d0facb685741, storecode: S0001, storename: SESA Store 01}, statusactive: 1, activated: 1}], tpitm: [], tritm: [{docid: a2263cbd-e95e-46e9-b211-1cea63fd936d, createdate: 2023-10-03T08:25:54.000Z, createby: 2, updatedate: 2023-10-03T08:25:54.000Z, updateby: 2, remarks: Bellamys Organic}], itemHierarchy: [{code: 01, description: Mom & Baby, tphir_id: {level: 1, description: Division}}, {code: 001, description: Baby Foods, tphir_id: {level: 2, description: Category}}, {code: 0001, description: Package Baby Foods, tphir_id: {level: 3, description: Sub Category}}, {code: 0002, description: Bellamys Baby Pasta, tphir_id: {level: 4, description: Class}}, {code: 0002, description: Bellamys Baby Pasta, tphir_id: {level: 5, description: Sub Class}}]}]