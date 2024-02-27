// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:sqflite/sqflite.dart';

// class PriceByItemBarcodeApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   PriceByItemBarcodeApi(this._dio);

//   Future<List<PriceByItemBarcodeModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<PriceByItemBarcodeModel> allData = [];
//       String tpln2Id = '2bf74706-780f-448f-a351-1b87cc69069d';

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-price-by-item-barcode/?page=$page&tpln2_id=$tpln2Id",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         List<PriceByItemBarcodeModel> data = (response.data as List)
//             .map((e) => PriceByItemBarcodeModel.fromMap(e))
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

//   Future<PriceByItemBarcodeModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-price-by-item-barcode/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       PriceByItemBarcodeModel datum =
//           PriceByItemBarcodeModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
