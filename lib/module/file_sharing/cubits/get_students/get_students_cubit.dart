import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../home/repo/home_repo.dart';
import '../../models/get_students_response.dart';
import 'get_students_state.dart';

class GetStudentsCubit extends Cubit<GetStudentsState> {
  GetStudentsCubit(this._repository) : super(GetStudentsState.initial());
  HomeRepository _repository;

  Future getGetStudents() async {
    emit(state.copyWith(status: GetStudentsStatus.loading));
    try {
      GetStudentsResponse response = await _repository.getStudents();
      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            status: GetStudentsStatus.success,
            message: response.message,
            students: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: GetStudentsStatus.failure,
            message: response.message,
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(status: GetStudentsStatus.failure, message: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GetStudentsStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
