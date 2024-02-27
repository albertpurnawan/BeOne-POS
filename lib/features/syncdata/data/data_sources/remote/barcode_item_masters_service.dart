// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:sqflite/sqflite.dart';

// class BarcodeItemApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;
//   String toitm_id = '338d765e-38fc-4f9b-b24f-039d407fd66c';

//   BarcodeItemApi(this._dio);

//   Future<List<BarcodeItemModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<BarcodeItemModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-barcode-item?toitm_id=$toitm_id&page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         List<BarcodeItemModel> data = (response.data as List)
//             .map((e) => BarcodeItemModel.fromMap(e))
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

//   Future<List<BarcodeItemModel>> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-barcode-item/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       BarcodeItemModel datum = BarcodeItemModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
