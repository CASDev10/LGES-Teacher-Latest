import 'package:bloc/bloc.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../model/sections_model.dart';
import '../../repo/classes_sections_repo.dart';

part 'sections_state.dart';

class SectionsCubit extends Cubit<SectionsState> {
  SectionsCubit(this._repository) : super(SectionsState.initial());

  ClassesSectionsRepository _repository;

  Future fetchSections(String classId) async {
    emit(state.copyWith(sectionsStatus: SectionsStatus.loading));

    try {
      SectionsModel sectionsModel = await _repository.getSections(classId);
      if (sectionsModel.result == ApiResult.success) {
        final uniqueSections = sectionsModel.data.toSet().toList();
        emit(
          state.copyWith(
            sectionsStatus: SectionsStatus.success,
            sections: uniqueSections,
          ),
        );
      } else {
        emit(
          state.copyWith(
            sectionsStatus: SectionsStatus.failure,
            failure: HighPriorityException(sectionsModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          sectionsStatus: SectionsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
