// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:sqflite/sqflite.dart';

// class CustomerGroupApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   CustomerGroupApi(this._dio);

//   Future<List<CustomerGroupModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<CustomerGroupModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-customer-group?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         List<CustomerGroupModel> data = (response.data as List)
//             .map((e) => CustomerGroupModel.fromMap(e))
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

//   Future<CustomerGroupModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-customer-group/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       CustomerGroupModel datum = CustomerGroupModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
