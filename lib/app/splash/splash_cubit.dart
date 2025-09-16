import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';

import '../../core/di/service_locator.dart';

enum SplashState {
  none, // none
  unauthenticated, // => dashboard
  authenticated, // => logged-in-dashboard
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.none);

  void init() async {
    debugPrint('splash ..init');
    await Future.delayed(const Duration(milliseconds: 6000));

    AuthRepository _repo = sl<AuthRepository>();
    bool isAuthenticate = await _repo.isAuthenticated();

    if (isAuthenticate) {
      emit(SplashState.authenticated);
    } else {
      emit(SplashState.unauthenticated);
    }
  }
}
