// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';

// class ClosingStoreApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   ClosingStoreApi(this._dio);

//   Future<List<ClosingStoreModel> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<ClosingStoreModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-cashier-balance-transaction?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         List<ClosingStoreModel> data =
//                 (response.data as List).map((e) => ClosingStoreModel.fromMap(e)).toList();
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

//   Future<ClosingStoreModel> fetchSingleData(String docid) async {
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

//       ClosingStoreModel datum = ClosingStoreModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
