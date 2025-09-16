part of 'employee_detail_cubit.dart';


enum EmployeeDetailStatus{
  none,
  loading,
  success,
  failure,
}

class EmployeeDetailState {
  final EmployeeDetailStatus employeeDetailStatus;
  final BaseFailure failure;
  final EmployeeModel? employeeModel;

  EmployeeDetailState({required this.employeeDetailStatus, required this.failure, required this.employeeModel});



  factory EmployeeDetailState.initial() {
    return EmployeeDetailState(
      employeeDetailStatus: EmployeeDetailStatus.none,
      failure: const BaseFailure(),
      employeeModel: null,
    );
  }




  EmployeeDetailState copyWith({
    EmployeeDetailStatus? employeeDetailStatus,
    BaseFailure? failure,
    EmployeeModel? employeeModel,
  }) {
    return EmployeeDetailState(
      employeeDetailStatus: employeeDetailStatus ?? this.employeeDetailStatus,
      failure: failure ?? this.failure,
      employeeModel: employeeModel ?? this.employeeModel,
    );
  }
}
