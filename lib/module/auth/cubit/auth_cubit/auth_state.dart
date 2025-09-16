part of 'auth_cubit.dart';

enum AuthStatus {
  none,
  authenticated,
  unauthenticated,
  loggingOut,
}

class AuthState {
  final AuthStatus authStatus;

  AuthState({
    required this.authStatus,
  });

  factory AuthState.unknown() {
    return AuthState(authStatus: AuthStatus.none);
  }

  @override
  String toString() => 'AuthState(authStatus: $authStatus)';

  AuthState copyWith({
    AuthStatus? authStatus,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
