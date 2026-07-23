import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lges_teacher_app/module/auth/repo/user_schools_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/user_schools_model.dart';

part 'user_schools_state.dart';

class UserSchoolsCubit extends Cubit<UserSchoolsState> {
  UserSchoolsCubit(this._repository) : super(UserSchoolsState.initial());

  UserSchoolsRepository _repository;
  List<UserSchool> schools = [];
  List<UserSchool> filteredSchools = [];

  Future fetchUserSchools(UserSchoolsInput input) async {
    emit(state.copyWith(userSchoolsStatus: UserSchoolsStatus.loading));

    try {
      UserSchoolsModel userSchoolsModel = await _repository.getUserSchools(
        input,
      );

      if (userSchoolsModel.result == ApiResult.success) {
        filteredSchools = userSchoolsModel.data;
        schools = userSchoolsModel.data;
        emit(
          state.copyWith(
            userSchoolsStatus: UserSchoolsStatus.success,
            userSchools: userSchoolsModel.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            userSchoolsStatus: UserSchoolsStatus.failure,
            failure: HighPriorityException(userSchoolsModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          userSchoolsStatus: UserSchoolsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }

  void filterSearchResults(String query) {
    filteredSchools = schools
        .where(
          (item) => item.schoolName.toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    emit(
      state.copyWith(
        userSchoolsStatus: UserSchoolsStatus.success,
        userSchools: filteredSchools,
      ),
    );
  }
}

class UserSchoolsInput {
  final String entityId;
  final String userId;

  UserSchoolsInput({required this.entityId, required this.userId});

  Map<String, dynamic> toJson() => {
    "UC_EntityId": entityId,
    "UC_LoginUserId": userId,
  };

  FormData toFormData() =>
      FormData.fromMap({"UC_EntityId": entityId, "UC_LoginUserId": userId});
}
