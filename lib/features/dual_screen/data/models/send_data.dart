import 'package:pos_fe/features/dual_screen/data/models/dual_screen.dart';

class SendBaseData {
  final String cashierName;
  final String? cashRegisterId;
  final String storeName;
  final int windowId;
  final List<DualScreenModel>? dualScreenModel;

  SendBaseData({
    required this.cashierName,
    required this.cashRegisterId,
    required this.storeName,
    required this.windowId,
    required this.dualScreenModel,
  });

  // Convert a SendBaseData object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'cashierName': cashierName,
      'cashRegisterId': cashRegisterId,
      'storeName': storeName,
      'windowId': windowId,
      'dualScreenModel': dualScreenModel?.map((e) => e.toMap()).toList(),
    };
  }

  // Create a SendBaseData object from a Map object
  factory SendBaseData.fromMap(Map<String, dynamic> map) {
    return SendBaseData(
      cashierName: map['cashierName'],
      cashRegisterId: map['cashRegisterId'],
      storeName: map['storeName'],
      windowId: map['windowId'],
      dualScreenModel: map['dualScreenModel'] != null
          ? List<DualScreenModel>.from(
              map['dualScreenModel']?.map((e) => DualScreenModel.fromMap(e)))
          : null,
    );
  }
}
