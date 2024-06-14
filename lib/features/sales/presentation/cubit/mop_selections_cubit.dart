import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_mop_selections.dart';

part 'mop_selections_state.dart';

class MopSelectionsCubit extends Cubit<List<MopSelectionEntity>> {
  final GetMopSelectionsUseCase _getMopSelectionsUseCase;

  MopSelectionsCubit(this._getMopSelectionsUseCase) : super([]);

  void getMopSelections() async {
    try {
      final newState = await _getMopSelectionsUseCase.call();
      emit(newState);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
    }
  }
}
