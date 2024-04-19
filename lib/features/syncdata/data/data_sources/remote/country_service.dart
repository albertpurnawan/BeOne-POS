import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/constants/constants.dart';
import 'package:pos_fe/core/usecases/error_handler.dart';
import 'package:pos_fe/features/sales/data/models/country.dart';

class CountryApi {
  final Dio _dio;
  String token = Constant.token;
  String tenantId = Constant.gtentId;
  String url = Constant.url;

  CountryApi(this._dio);

  Future<List<CountryModel>> fetchData() async {
    try {
      String apiName = "API-COUNTRY";
      Map<String, dynamic> exeData = {};
      List<CountryModel> allData = [];

      final response = await _dio.get(
        "$url/tenant-custom-query/list",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      for (var api in response.data) {
        if (api["name"] == apiName) {
          exeData = {
            "docid": api["docid"],
            "parameter": [tenantId]
          };
        }
      }

      final resp = await _dio.post("$url/tenant-custom-query/execute",
          data: exeData,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (resp.data['data'].isNotEmpty) {
        log("--- Country ---");
        log(resp.data['data'][0].toString());

        List<CountryModel> data = (resp.data['data'] as List)
            .map((e) => CountryModel.fromMapRemote(e))
            .toList();
        allData.addAll(data);
      }

      return allData;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }

  Future<CountryModel> fetchSingleData(String docid) async {
    try {
      final response = await _dio.get(
        "$url/tenant-master-currency/$docid",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      // log(response.data.toString());
      if (response.data == null) throw Exception('Null Data');

      CountryModel datum = CountryModel.fromMap(response.data);

      // log(datum.toString());
      return datum;
    } catch (err) {
      handleError(err);
      rethrow;
    }
  }
}



// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/usecases/error_handler.dart';
// import 'package:pos_fe/features/sales/data/models/country.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CountryApi {
//   final Dio _dio;

//   late String token;
//   late String tenantId;
//   late String url;

//   CountryApi(this._dio) {
//     _initializePreferences();
//   }

//   Future<void> _initializePreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('adminToken') ?? '';
//     tenantId = prefs.getString('gtentId') ?? '';
//     url = prefs.getString('baseUrl') ?? '';
//     log("--------------");
//     log(url);
//     log(token);
//     log(tenantId);
//     log("--------------");
//   }

//   Future<List<CountryModel>> fetchData() async {
//     try {
//       log("--------------");
//       log(url);
//       log(token);
//       log(tenantId);
//       log("--------------");
//       String apiName = "API-COUNTRY";
//       Map<String, dynamic> exeData = {};
//       List<CountryModel> allData = [];

//       final response = await _dio.get(
//         "$url/tenant-custom-query/list",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       for (var api in response.data) {
//         if (api["name"] == apiName) {
//           exeData = {
//             "docid": api["docid"],
//             "parameter": [tenantId]
//           };
//         }
//       }

//       final resp = await _dio.post("$url/tenant-custom-query/execute",
//           data: exeData,
//           options: Options(headers: {
//             'Authorization': 'Bearer $token',
//           }));

//       if (resp.data['data'].isNotEmpty) {
//         log("--- Country ---");
//         log(resp.data['data'][0].toString());

//         List<CountryModel> data = (resp.data['data'] as List)
//             .map((e) => CountryModel.fromMapRemote(e))
//             .toList();
//         allData.addAll(data);
//       }

//       return allData;
//     } catch (err) {
//       handleError(err);
//       rethrow;
//     }
//   }

//   Future<CountryModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-master-currency/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log(response.data.toString());
//       if (response.data == null) throw Exception('Null Data');

//       CountryModel datum = CountryModel.fromMap(response.data);

//       // log(datum.toString());
//       return datum;
//     } catch (err) {
//       handleError(err);
//       rethrow;
//     }
//   }
// }
