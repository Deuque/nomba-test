import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomba/data/routine_repository.dart';
import 'package:nomba/domain/routine_model.dart';

part 'routine_bloc_state.dart';

class RoutineBlocCubit extends Cubit<RoutineBlocState> {
  final RoutineRepository routineRepo;

  RoutineBlocCubit(this.routineRepo) : super(const RoutineBlocState([]));

  Future<void> loadRoutines() async {
    try {
      final response = await routineRepo.getRoutines();
      emit(RoutineBlocState(response.toList()));
    } catch (e, st) {
      log('$e');
      log('$st');
    }
  }

  Future<String?> createNewRoutine(RoutineModel routineModel) async {
    try {
      final routineList = [routineModel, ...state.routines];
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }

  Future<String?> editRoutine(RoutineModel routineModel) async {
    try {
      final routineList = state.routines
          .map((r) => r.createdAt == routineModel.createdAt ? routineModel : r)
          .toList();
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }

  Future<String?> deleteRoutine(RoutineModel routineModel) async {
    try {
      final routineList = state.routines
          .where((r) => r.createdAt != routineModel.createdAt)
          .toList();
      final response = await routineRepo.saveRoutines(routineList.toSet());
      if (response == false) return 'An error occurred';
      emit(RoutineBlocState(routineList));
      return null;
    } catch (e) {
      log('$e');
      return 'An error occurred';
    }
  }
}
