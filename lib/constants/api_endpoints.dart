class Endpoints {
  static const String login = '/AuthenticateEmployee';
  static const String getUserSchools = '/GetUserSchools';
  static const String getClassesForAttendance =
      '/GetClassesOfSchoolForAttendance';
  static const String getSectionsForAttendance =
      '/GetSectionsOfClassForAttendance';
  static const String getGetSectionStudentList = '/GetSectionStudentList';
  static const String getSubjectOfClass = '/GetSubjectOfClass';
  static const String getDiaryList = '/GetDiaryList';
  static const String getEvaluationRemarksList = '/GetEvaluationRemarksList';
  static const String addEvaluationRemarks = '/AddEvaluationRemarks';
  static const String getEvaluationAreas = '/GetEvaluationAreas';
  static const String getStudentEvaluationAreas = '/GetStudentEvaluationAreas';
  static const String addEvaluationLogBook = '/AddEvaluationLogBook';
  static const String addDiary = '/AddDiary';
  static const String addSchoolAttendance = '/AddSchoolAttendance';
  static const String getMobileAppConfig = '/GetMobileAppConfig';
  static const String forgetPassword = '/UpdateForgetMobilePassword';
  static const String getClassesForExam = '/GetClassesOfSchoolForExam';
  static const String getSectionsForExam = '/GetClassSectionsForExam';
  static const String importExamResultData = '/ImportExamResultData';
  static const String addObservationLevel = '/AddObservationLevel';
  static const String updateObservationLevel = '/UpdateObservationLevel';
  static const String deleteObservationLevel = '/DeleteObservationLevel';
  static const String getObservationLevelList = '/GetObservationLevelList';
  static const String getObservationAreas = '/GetObservationAreas';
  static const String getObservationAreaRemarksList =
      '/GetObservationAreaRemarksList';
  static const String addObservationAreaRemarks = '/AddObservationAreaRemarks';
  static const String deleteObservationAreaRemarks =
      '/DeleteObservationAreaRemarks';
  static const String updateObservationAreaRemarks =
      '/UpdateObservationAreaRemarks';
  static const String getEmployeeById = '/GetEmployeeById';
  static const String saveTeacherObservation = '/SaveTeacherObservation';
  static const String getObservationReport = '/GetObservationReport';
  static const String uploadTeacherFile = '/UploadTeacherFile';
  static const String getEmployeeLeaveBalance = '/GetEmployeeLeaveBalance';
  static const String getEmployeeLeavesByEmpId = '/GetEmployeeLeavesByEmpId';
  static const String uploadLeave = '/UploadLeave';
  static const String deleteLeave = '/Delete';
}
