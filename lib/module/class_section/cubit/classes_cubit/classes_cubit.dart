import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/class_section/repo/classes_sections_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../model/classes_model.dart';

part 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  ClassesCubit(this._repository) : super(ClassesState.initial());

  ClassesSectionsRepository _repository;

  Future fetchClasses(String schoolId) async {
    emit(state.copyWith(classesStatus: ClassesStatus.loading));

    try {
      ClassesModel classesModel =
      await _repository.getClasses(schoolId);

      if (classesModel.result == ApiResult.success) {
        emit(state.copyWith(
          classesStatus: ClassesStatus.success,
          classes: classesModel.data,
        ));
      } else {
        emit(state.copyWith(
            classesStatus: ClassesStatus.failure,
            failure: HighPriorityException(classesModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          classesStatus: ClassesStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
