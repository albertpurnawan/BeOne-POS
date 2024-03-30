import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_content_repository.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

class ReceiptContentRepositoryImpl implements ReceiptContentRepository {
  final AppDatabase appDatabase;

  ReceiptContentRepositoryImpl(this.appDatabase);

  @override
  Future<List<ReceiptContentEntity?>> getReceiptContents() async {
    // TODO: implement getReceiptContents
    return await appDatabase.receiptContentDao.readAll();
  }
}
