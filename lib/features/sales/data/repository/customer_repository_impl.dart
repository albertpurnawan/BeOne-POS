import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/data_state.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/repository/customer_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final AppDatabase _appDatabase;
  CustomerRepositoryImpl(this._appDatabase);

  @override
  Future<List<CustomerEntity>> getCustomers({String? searchKeyword}) {
    // TODO: implement getCustomers
    return _appDatabase.customerDao.readAll(searchKeyword: searchKeyword);
  }
}
