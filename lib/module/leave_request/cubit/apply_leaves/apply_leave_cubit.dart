// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// // import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
//
// import '../../../../core/api_result.dart';
// import '../../../../core/exceptions/api_error.dart';
// import '../../model/apply_leave_model.dart';
// import '../../repository/leave_repository.dart';
// import 'apply_leave_state.dart';
//
// class ApplyLeaveCubit extends Cubit<ApplyLeaveState> {
//   final LeaveRepository _repository;
//   File? selectedFile;
//   ApplyLeaveCubit({required LeaveRepository applyLeaveRepo})
//     : _repository = applyLeaveRepo,
//       super(ApplyLeaveState.initial());
//
//   Future<void> pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'png', 'docx'],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         selectedFile = File(result.files.single.path!);
//         emit(
//           state.copyWith(
//             status: ApplyLeaveStatus.fileSelected,
//             message: "File selected: ${result.files.single.name}",
//           ),
//         );
//         print('###$selectedFile');
//       } else {
//         emit(
//           state.copyWith(
//             status: ApplyLeaveStatus.error,
//             message: "No file selected",
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: ApplyLeaveStatus.error,
//           message: "Error selecting file: $e",
//         ),
//       );
//     }
//   }
//
//   Future applyLeave(dynamic data) async {
//     emit(state.copyWith(status: ApplyLeaveStatus.loading));
//     try {
//       MultipartFile image = await MultipartFile.fromFile(
//         selectedFile!.path,
//         filename: selectedFile?.path.split('/').last,
//       );
//       ApplyLeaveModel response = await _repository.insertStudentLeave(
//         image,
//         data,
//       );
//       if (response.result == ApiResult.success) {
//         emit(
//           state.copyWith(
//             status: ApplyLeaveStatus.success,
//             applyLeaveResponse: response.applyLeaveResponse,
//             message: response.message,
//           ),
//         );
//       } else {
//         emit(
//           state.copyWith(
//             status: ApplyLeaveStatus.error,
//             message: response.message,
//           ),
//         );
//       }
//     } on ApiError catch (e) {
//       emit(
//         state.copyWith(status: ApplyLeaveStatus.error, message: "${e.message}"),
//       );
//     }
//   }
// }
