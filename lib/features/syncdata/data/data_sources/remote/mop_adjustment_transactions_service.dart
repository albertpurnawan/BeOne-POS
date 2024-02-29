// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:pos_fe/core/usecases/error_handler.dart';
// import 'package:sqflite/sqflite.dart';

// class MOPAdjustmentApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   MOPAdjustmentApi(this._dio);

//   Future<List<MOPAdjustmentModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<MOPAdjustmentModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-mop-adjustment/?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         final List<MOPAdjustmentModel> data = (response.data as List)
//             .map((e) => MOPAdjustmentModel.fromMap(e))
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

//   Future<MOPAdjustmentModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-mop-adjustment/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       MOPAdjustmentModel datum = MOPAdjustmentModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       handleError(err);
//       rethrow;
//     }
//   }
// }
