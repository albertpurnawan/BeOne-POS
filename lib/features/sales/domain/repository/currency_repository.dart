import 'package:pos_fe/features/sales/data/models/currency.dart';

abstract class CurrencyRepository {
  Future<void> deleteCreate(List<CurrencyModel> currencies);
}
