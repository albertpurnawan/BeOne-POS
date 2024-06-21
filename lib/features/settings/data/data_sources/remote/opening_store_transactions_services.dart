// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:pos_fe/core/usecases/error_handler.dart';
// import 'package:sqflite/sqflite.dart';

// class OpeningStoreApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   OpeningStoreApi(this._dio);

//   Future<List<OpeningStoreModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<OpeningStoreModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-cashier-balance-transaction?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         final List<OpeningStoreModel> data = (response.data as List)
//             .map((e) => OpeningStoreModel.fromMap(e))
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
//       handleError(err);
//       rethrow;
//     }
//   }

//   Future<OpeningStoreModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-cashier-balance-transaction/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       OpeningStoreModel datum = OpeningStoreModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       handleError(err);
//       rethrow;
//     }
//   }
// }
