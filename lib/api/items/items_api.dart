// import 'package:dio/dio.dart';
// import 'package:pos_fe/core/constants/constants.dart';
// import 'package:pos_fe/core/database/app_database.dart';
// import 'dart:developer';

// class ItemsApi {
//   final AppDatabase _appdatabase = AppDatabase();
//   final dio = Dio();
//   String token = Constant.token;

//   Future<List<dynamic>> fetchItemsData() async {
//     try {
//       String token = Constant.token;
//       int page = 1;
//       bool hasMoreData = true;
//       List<dynamic> allItems = [];

//       while (hasMoreData) {
//         final response = await dio.get(
//           "http://192.168.1.34:3001/tenant-item-master?page=$page",
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//             },
//           ),
//         );

//         final List<dynamic> itemsData = response.data as List<dynamic>;
//         allItems.addAll(itemsData);

//         if (itemsData.isEmpty) {
//           hasMoreData = false;
//         } else {
//           page++;
//         }
//       }

//       final List<Items> items =
//           allItems.map((json) => Items.fromJson(json).toList());

//       // log(items[0].toString());

//       // for (final item in items) {
//       //   await _appdatabase.insertItems(item);
//       // }

//       return allItems;
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }

//   Future<List<dynamic>> fetchItemData(String docid) async {
//     try {
//       final response = await dio.get(
//         "http://192.168.1.34:3001/tenant-item-master/$docid",
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       final Items item = Items.fromJson(response.data);

//       // print('Item: $item');

//       return [response.data];
//     } catch (err) {
//       print('Error: $err');
//       rethrow;
//     }
//   }
// }
