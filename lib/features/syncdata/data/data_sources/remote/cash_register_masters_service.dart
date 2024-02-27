// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:sqflite/sqflite.dart';

// class CashRegisterApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   CashRegisterApi(this._dio);

//   Future<List<CashRegisterModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<CashRegisterModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-cash-register?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         List<CashRegisterModel> data = (response.data as List)
//             .map((e) => CashRegisterModel.fromMap(e))
//             .toList();
//         // log(check.toString());
//         allData.addAll(data);

//         if (data.isEmpty) {
//           hasMoreData = false;
//         } else {
//           page++;
//         }
//       }

//       return allData;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }

//   Future<CashRegisterModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-cash-register/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       CashRegisterModel datum = CashRegisterModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
