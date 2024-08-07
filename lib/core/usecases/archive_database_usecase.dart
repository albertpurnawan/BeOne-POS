import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/settings/domain/usecases/decrypt.dart';

class ArchiveDatabaseParams {
  final BuildContext context;

  ArchiveDatabaseParams({required this.context});
}

class ArchiveDatabaseUseCase implements UseCase<void, ArchiveDatabaseParams> {
  final _databaseName = "pos_fe.db";
  final decryptPasswordUseCase = GetIt.instance<DecryptPasswordUseCase>();

  @override
  Future<void> call({ArchiveDatabaseParams? params}) async {
    final context = params!.context;
    try {} catch (e) {
      log("Error archiving database: $e");
    }
  }
}
