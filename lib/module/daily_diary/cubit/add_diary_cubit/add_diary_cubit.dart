import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lges_teacher_app/module/daily_diary/models/add_diary_input.dart';
import 'package:lges_teacher_app/module/daily_diary/models/add_diary_response.dart';
import 'package:lges_teacher_app/module/daily_diary/models/update_diary_input.dart';
import 'package:lges_teacher_app/module/daily_diary/repo/diary_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import 'add_diary_state.dart';

class AddDiaryCubit extends Cubit<AddDiaryState> {
  AddDiaryCubit(this._repository) : super(AddDiaryState.initial());

  DiaryRepository _repository;

  Future addDiary(AddDiaryInput input, File? file) async {
    MultipartFile? image;
    emit(state.copyWith(addDiaryStatus: AddDiaryStatus.loading));
    try {
      if (file != null) {
        final fileName = file.path.split('/').last; // ✅ extract just the name
        final image = await MultipartFile.fromFile(
          file.path,
          filename: fileName, // ✅ correct way
        );
        input.file = image;
      }
      AddDiaryResponseModel response = await _repository.addDiary(input);
      if (response.result == ApiResult.success) {
        emit(state.copyWith(addDiaryStatus: AddDiaryStatus.success));
      } else {
        emit(
          state.copyWith(
            addDiaryStatus: AddDiaryStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          addDiaryStatus: AddDiaryStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }

  Future updateDiary(UpdateDiaryInput input, File? file) async {
    MultipartFile? image;
    emit(state.copyWith(addDiaryStatus: AddDiaryStatus.loading));
    try {
      if (file != null) {
        final fileName = file.path.split('/').last; // ✅ extract just the name
        final image = await MultipartFile.fromFile(
          file.path,
          filename: fileName, // ✅ correct way
        );
        input.file = image;
      }
      AddDiaryResponseModel response = await _repository.updateDiary(input);
      if (response.result == ApiResult.success) {
        emit(state.copyWith(addDiaryStatus: AddDiaryStatus.success));
      } else {
        emit(
          state.copyWith(
            addDiaryStatus: AddDiaryStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          addDiaryStatus: AddDiaryStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
