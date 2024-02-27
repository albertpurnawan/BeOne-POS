// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:sqflite/sqflite.dart';

// class StoreApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   StoreApi(this._dio);

//   Future<List<StoreModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<StoreModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-store-master?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         final List<StoreModel> data =
//             (response.data as List).map((e) => StoreModel.fromMap(e)).toList();
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

//   Future<StoreModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-store-master/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       StoreModel datum = StoreModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
