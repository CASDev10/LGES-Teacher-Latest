import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/core/api_result.dart';
import 'package:lges_teacher_app/core/failures/base_failures/base_failure.dart';
import 'package:lges_teacher_app/core/failures/high_priority_failure.dart';
import 'package:lges_teacher_app/module/students_attendance/cubit/student_attendance_cubit/student_attendance_state.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_input.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_reponse.dart';
import 'package:lges_teacher_app/module/students_attendance/repo/attendance_repo.dart';

class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  StudentAttendanceCubit(this._repository)
    : super(StudentAttendanceState.initial());
  AttendanceRepository _repository;
  List<AttendanceModel> filterStudentAttendanceList = [];
  List<AttendanceModel> studentAttendanceList = [];

  Future fetchStudentAttendanceList(AttendanceInput input) async {
    emit(
      state.copyWith(studentAttendanceStatus: StudentAttendanceStatus.loading),
    );
    try {
      AttendanceResponseModel attendanceResponseModel = await _repository
          .getGetSectionStudentList(input);
      if (attendanceResponseModel.result == ApiResult.success) {
        filterStudentAttendanceList = attendanceResponseModel.data;
        studentAttendanceList = attendanceResponseModel.data;
        emit(
          state.copyWith(
            studentAttendanceStatus: StudentAttendanceStatus.success,
            attendanceList: attendanceResponseModel.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            studentAttendanceStatus: StudentAttendanceStatus.failure,
            failure: HighPriorityException(attendanceResponseModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          studentAttendanceStatus: StudentAttendanceStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }

  void filterSearchResults(String query) {
    filterStudentAttendanceList = studentAttendanceList
        .where(
          (item) => item.studentName.toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    emit(
      state.copyWith(
        studentAttendanceStatus: StudentAttendanceStatus.success,
        attendanceList: filterStudentAttendanceList,
      ),
    );
  }
}
