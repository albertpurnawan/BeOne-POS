import 'package:get_it/get_it.dart';
import 'package:pos_fe/features/sales/data/models/item_master.dart';
import 'package:pos_fe/features/syncdata/data/data_sources/remote/item_masters_service.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDaoTest {
  final Database db;

  ItemsDaoTest(this.db);

  Future<List<dynamic>> upsertDataFromAPI() async {
    try {
      final List<dynamic> data =
          await GetIt.instance<ItemMasterApi>().fetchData();

      for (final datum in data) {
        final ItemMasterModel item = ItemMasterModel.fromMap(datum);

        print('here');

        final List<String> excludedFields = [
          'createby',
          'updateby',
          'gtent_id',
          'tocat_id',
          'touom_id',
          'margin',
          'property_1',
          'property_2',
          'property_3',
          'property_4',
          'property_5',
          'property_6',
          'property_7',
          'property_8',
          'property_9',
          'property_10',
          'tbitm',
          'tsitm',
          'tpitm',
          'tritm',
          'item',
          'itemHierarchy'
        ];

        final Map<String, dynamic> map = item.toMap();

        for (var field in excludedFields) {
          if (map.containsKey(field)) {
            map.remove(field);
          }
        }

        await db.transaction((txn) async {
          await txn.rawInsert(
            '''
            INSERT OR REPLACE INTO toitm (
              docid, createdate, updatedate, itemcode, itemname, invitem, serialno, 
              minstock, maxstock, includetax, remarks, statusactive, activated, isbatch, 
              internalcode_1, internalcode_2, openprice, popitem, bpom, expdate, 
              memberdiscount, multiplyorder, mergequantity
            ) VALUES (
              ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            )
            ON CONFLICT(docid) DO UPDATE SET
              createdate = excluded.createdate,
              updatedate = excluded.updatedate,
              itemcode = excluded.itemcode,
              itemname = excluded.itemname,
              invitem = excluded.invitem,
              serialno = excluded.serialno,
              minstock = excluded.minstock,
              maxstock = excluded.maxstock,
              includetax = excluded.includetax,
              remarks = excluded.remarks,
              statusactive = excluded.statusactive,
              activated = excluded.activated,
              isbatch = excluded.isbatch,
              internalcode_1 = excluded.internalcode_1,
              internalcode_2 = excluded.internalcode_2,
              openprice = excluded.openprice,
              popitem = excluded.popitem,
              bpom = excluded.bpom,
              expdate = excluded.expdate,
              memberdiscount = excluded.memberdiscount,
              multiplyorder = excluded.multiplyorder,
              mergequantity = excluded.mergequantity,
          ''',
            [
              map['docid'],
              map['createdate'],
              map['updatedate'],
              map['itemcode'],
              map['itemname'],
              map['invitem'],
              map['serialno'],
              map['minstock'],
              map['maxstock'],
              map['includetax'],
              map['remarks'],
              map['statusactive'],
              map['activated'],
              map['isbatch'],
              map['internalcode_1'],
              map['internalcode_2'],
              map['openprice'],
              map['popitem'],
              map['bpom'],
              map['expdate'],
              map['memberdiscount'],
              map['multiplyorder'],
              map['mergequantity'],
            ],
          );
        });
      }
      return data;
    } catch (err) {
      print('Error $err');
      rethrow;
    }
  }
}
