import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_result.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/failures/high_priority_failure.dart';
import '../../../utils/image_utils.dart';
import '../../base_resposne_model.dart';
import '../../home/repo/home_repo.dart';
import '../models/file_sharing_input.dart';
import 'file_sharing_state.dart';

class FileSharingCubit extends Cubit<FileSharingState> {
  FileSharingCubit(this._repository) : super(FileSharingState.initial());
  HomeRepository _repository;
  Future uploadTeacherFile(FileSharingInput input, File? file) async {
    MultipartFile? image;
    emit(state.copyWith(status: FileSharingStatus.loading));

    try {
      if (file != null) {
        image = await ImageUtils.compressImage(file.path);
        if (image != null) {
          input.file = image;
        } else {
          emit(
            state.copyWith(
              status: FileSharingStatus.failure,
              failure: const HighPriorityException(
                "Image should be less than 2MB",
              ),
            ),
          );
          return;
        }
      }
      BaseResponseModel baseResponseModel = await _repository.uploadTeacherFile(
        input,
      );

      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(status: FileSharingStatus.success));
      } else {
        emit(
          state.copyWith(
            status: FileSharingStatus.failure,
            failure: HighPriorityException(baseResponseModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          status: FileSharingStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
