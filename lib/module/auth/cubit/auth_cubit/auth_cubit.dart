import 'package:bloc/bloc.dart';

import '../../repo/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthState.unknown());
  final AuthRepository _authRepository;

  void init() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isAuthenticated = await _authRepository.isAuthenticated();

    if (isAuthenticated) {
      // init session
      await _authRepository.getUser();

      emit(state.copyWith(authStatus: AuthStatus.authenticated));
    } else {
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }
  }

  void logout() async {
    emit(state.copyWith(authStatus: AuthStatus.loggingOut));
    await Future.delayed(const Duration(seconds: 2));
    await _authRepository.logout();
    emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
  }
}
