import 'package:pos_fe/features/sales/domain/entities/employee.dart';

const String tableEmployee = "tohem";

class EmployeeFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    empCode,
    empName,
    email,
    phone,
    addr1,
    addr2,
    addr3,
    city,
    remarks,
    toprvId,
    tocryId,
    tozcdId,
    idCard,
    gender,
    birthday,
    photo,
    joinDate,
    resignDate,
    statusActive,
    activated,
    empDept,
    empTitle,
    empWorkplace,
    empdDebt,
  ];
  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String empCode = 'empcode';
  static const String empName = 'empname';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String addr1 = 'addr1';
  static const String addr2 = 'addr2';
  static const String addr3 = 'addr3';
  static const String city = 'city';
  static const String remarks = 'remarks';
  static const String toprvId = 'toprvid';
  static const String tocryId = 'tocryid';
  static const String tozcdId = 'tozcdid';
  static const String idCard = 'idcard';
  static const String gender = 'gender';
  static const String birthday = 'birthday';
  static const String photo = 'photo';
  static const String joinDate = 'joindate';
  static const String resignDate = 'resigndate';
  static const String statusActive = 'statusactive';
  static const String activated = 'activated';
  static const String empDept = 'empdept';
  static const String empTitle = 'emptitle';
  static const String empWorkplace = 'empworkplace';
  static const String empdDebt = 'empdebt';
}

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.empCode,
    required super.empName,
    required super.email,
    required super.phone,
    required super.addr1,
    required super.addr2,
    required super.addr3,
    required super.city,
    required super.remarks,
    required super.toprvId,
    required super.tocryId,
    required super.tozcdId,
    required super.idCard,
    required super.gender,
    required super.birthday,
    required super.photo,
    required super.joinDate,
    required super.resignDate,
    required super.statusActive,
    required super.activated,
    required super.empDept,
    required super.empTitle,
    required super.empWorkplace,
    required super.empdDebt,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'empcode': empCode,
      'empname': empName,
      'email': email,
      'phone': phone,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'city': city,
      'remarks': remarks,
      'toprvid': toprvId,
      'tocryid': tocryId,
      'tozcdid': tozcdId,
      'idcard': idCard,
      'gender': gender,
      'birthday': birthday..toLocal().toIso8601String(),
      'photo': photo,
      'joindate': joinDate..toLocal().toIso8601String(),
      'resigndate': resignDate..toLocal().toIso8601String(),
      'statuscctive': statusActive,
      'activated': activated,
      'empdept': empDept,
      'emptitle': empTitle,
      'empworkplace': empWorkplace,
      'empddebt': empdDebt,
    };
  }

  factory EmployeeModel.fromMapRemote(Map<String, dynamic> map) {
    return EmployeeModel.fromMap({
      ...map,
      'toprvid': map['toprv_id'] != null ? map['toprv_id'] as String : null,
      'tocryid': map['tocry_id'] != null ? map['tocry_id'] as String : null,
      'tozcdid': map['tozcd_id'] != null ? map['tozcd_id'] as String : null,
      'empdDebt': map['empddebt'].toDouble() as double,
    });
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['createdate']).toLocal()
          : null,
      empCode: map['empcode'] as String,
      empName: map['empname'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      toprvId: map['toprvid'] != null ? map['toprvid'] as String : null,
      tocryId: map['tocryid'] != null ? map['tocryid'] as String : null,
      tozcdId: map['tozcdid'] != null ? map['tozcdid'] as String : null,
      idCard: map['idcard'] as String,
      gender: map['gender'] as String,
      birthday: DateTime.parse(map['createdate']).toLocal(),
      photo: map['photo'] as dynamic,
      joinDate: DateTime.parse(map['createdate']).toLocal(),
      resignDate: DateTime.parse(map['createdate']).toLocal(),
      statusActive: map['statuscctive'] as int,
      activated: map['activated'] as int,
      empDept: map['empdept'] as String,
      empTitle: map['emptitle'] as String,
      empWorkplace: map['empworkplace'] as String,
      empdDebt: map['empddebt'] as double,
    );
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      empCode: entity.empCode,
      empName: entity.empName,
      email: entity.email,
      phone: entity.phone,
      addr1: entity.addr1,
      addr2: entity.addr2,
      addr3: entity.addr3,
      city: entity.city,
      remarks: entity.remarks,
      toprvId: entity.toprvId,
      tocryId: entity.tocryId,
      tozcdId: entity.tozcdId,
      idCard: entity.idCard,
      gender: entity.gender,
      birthday: entity.birthday,
      photo: entity.photo,
      joinDate: entity.joinDate,
      resignDate: entity.resignDate,
      statusActive: entity.statusActive,
      activated: entity.activated,
      empDept: entity.empDept,
      empTitle: entity.empTitle,
      empWorkplace: entity.empWorkplace,
      empdDebt: entity.empdDebt,
    );
  }
}
