// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';

// class CustomerApi {
//   final Dio _dio;
//   String token = Constant.token;
//   String url = Constant.url;

//   CustomerApi(this._dio);

//   Future<List<CustomerModel>> fetchData() async {
//     try {
//       int page = 1;
//       bool hasMoreData = true;
//       List<CustomerModel> allData = [];

//       while (hasMoreData) {
//         final response = await _dio.get(
//           "$url/tenant-customer?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         List<CustomerModel> data = (response.data as List)
//             .map((e) => CustomerModel.fromMap(e))
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

//   Future<CustomerModel> fetchSingleData(String docid) async {
//     try {
//       final response = await _dio.get(
//         "$url/tenant-customer/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       // log([response.data].toString());

//       CustomerModel datum = CustomerModel.fromMap(response.data);

//       return datum;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
