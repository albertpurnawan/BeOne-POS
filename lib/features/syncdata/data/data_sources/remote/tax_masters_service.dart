// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:sqflite/sqflite.dart';

// class TaxApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   TaxApi(this._dio);

//   Future<List<TaxModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<TaxModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-tax-master?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         final List<TaxModel> data =
//             (response.data as List).map((e) => TaxModel.fromMap(e)).toList();
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

//   Future<TaxModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-tax-master/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       TaxModel datum = TaxModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
