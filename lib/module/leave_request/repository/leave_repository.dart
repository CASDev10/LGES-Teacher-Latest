// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import '../../../constants/api_endpoints.dart';
// import '../../../core/exceptions/api_error.dart';
// import '../../../utils/logger/logger.dart';
// import '../model/apply_leave_model.dart';
// import '../model/leave_balance_response.dart';
// import '../model/leave_data_response.dart';
//
// class LeaveRepository {
//   final DioClient _dioClient;
//   final _log = logger(LeaveRepository);
//
//   LeaveRepository({required DioClient dioClient}) : _dioClient = dioClient;
//
//   Future<LeaveBalanceResponse> getLeaveBalance(
//     int employeeId,
//   ) async {
//     try {
//       Map<String, dynamic> queryParams = {
//         "UC_LoginUserId": employeeId,
//       };
//       var response = await _dioClient.post(Endpoints.getEmployeeLeaveBalance,
//           data: queryParams);
//       LeaveBalanceResponse leaveBalanceResponse =
//           LeaveBalanceResponse.fromJson(response.data);
//       return leaveBalanceResponse;
//     } on DioException catch (e, stackTrace) {
//       _log.e(e, stackTrace: stackTrace);
//       throw ApiError.fromDioException(e);
//     } catch (e) {
//       _log.e(e);
//       throw ApiError(message: '$e', code: 0);
//     }
//   }
//
//   Future<LeaveDataResponse> getLeaveData(
//     int employeeId,
//   ) async {
//     try {
//       Map<String, dynamic> queryParams = {
//         "UC_LoginUserId": employeeId,
//       };
//       var response =
//           await _dioClient.post(Endpoints.getEmpLeaveData, data: queryParams);
//       LeaveDataResponse leaveDataResponse =
//           LeaveDataResponse.fromJson(response.data);
//       return leaveDataResponse;
//     } on DioException catch (e, stackTrace) {
//       _log.e(e, stackTrace: stackTrace);
//       throw ApiError.fromDioException(e);
//     } catch (e) {
//       _log.e(e);
//       throw ApiError(message: '$e', code: 0);
//     }
//   }
//
//   Future<LeaveDataResponse> getLeaveTypes() async {
//     try {
//       var response = await _dioClient.post(
//         Endpoints.getLeaveTypeList,
//       );
//       LeaveDataResponse leaveDataResponse =
//           LeaveDataResponse.fromJson(response.data);
//       return leaveDataResponse;
//     } on DioException catch (e, stackTrace) {
//       _log.e(e, stackTrace: stackTrace);
//       throw ApiError.fromDioException(e);
//     } catch (e) {
//       _log.e(e);
//       throw ApiError(message: '$e', code: 0);
//     }
//   }
//
//   Future<LeaveDataResponse> getRelieverList(dynamic data) async {
//     try {
//       var response =
//           await _dioClient.post(Endpoints.getSchoolRelieverList, data: data);
//       LeaveDataResponse leaveDataResponse =
//           LeaveDataResponse.fromJson(response.data);
//       return leaveDataResponse;
//     } on DioException catch (e, stackTrace) {
//       _log.e(e, stackTrace: stackTrace);
//       throw ApiError.fromDioException(e);
//     } catch (e) {
//       _log.e(e);
//       throw ApiError(message: '$e', code: 0);
//     }
//   }
//
//   Future<ApplyLeaveModel> insertStudentLeave(
//       MultipartFile leaveAttachment, dynamic data) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "Model": jsonEncode(data),
//         "EmpLeaveAttachment": leaveAttachment,
//       });
//       var response = await _dioClient.post(
//         Endpoints.insertEmployeeLeave,
//         data: formData,
//         options: Options(
//           contentType: "multipart/form-data",
//         ),
//       );
//       ApplyLeaveModel quizzesResponse = ApplyLeaveModel.fromJson(response.data);
//       return quizzesResponse;
//     } on DioException catch (e, stackTrace) {
//       _log.e(e, stackTrace: stackTrace);
//       throw ApiError.fromDioException(e);
//     } catch (e) {
//       _log.e(e);
//       throw ApiError(message: '$e', code: 0);
//     }
//   }
// }
