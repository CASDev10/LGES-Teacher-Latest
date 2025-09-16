part of 'user_schools_cubit.dart';

enum UserSchoolsStatus {
  none,
  loading,
  success,
  failure,
}

class UserSchoolsState {
  final UserSchoolsStatus userSchoolsStatus;
  final BaseFailure failure;
  final List<UserSchool> userSchools;

  UserSchoolsState({
    required this.userSchoolsStatus,
    required this.failure,
    required this.userSchools,
  });

  factory UserSchoolsState.initial() {
    return UserSchoolsState(
      userSchoolsStatus: UserSchoolsStatus.none,
      failure: const BaseFailure(),
      userSchools: [],
    );
  }

  UserSchoolsState copyWith({
    UserSchoolsStatus? userSchoolsStatus,
    BaseFailure? failure,
    List<UserSchool>? userSchools,
  }) {
    return UserSchoolsState(
      userSchoolsStatus: userSchoolsStatus ?? this.userSchoolsStatus,
      failure: failure ?? this.failure,
      userSchools: userSchools ?? this.userSchools,
    );
  }
}
