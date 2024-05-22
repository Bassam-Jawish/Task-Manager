part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  error,
  changePassword,
}

class AuthState extends Equatable {
  final UserInfoEntity? userInfoEntity;
  final Failure? error;
  final bool? isLoading;
  final bool? isPasswordVis;
  final AuthStatus? authStatus;

  const AuthState({
    this.userInfoEntity,
    this.error,
    this.isLoading,
    this.isPasswordVis,
    this.authStatus,
  });

  AuthState copyWith({
    String? accessToken,
    String? refreshToken,
    UserInfoEntity? userInfoEntity,
    Failure? error,
    bool? isLoading,
    bool? isPasswordVis,
    AuthStatus? authStatus,
    bool? isForgotPasswordLoading,
    bool? isValidateResetPasswordLoading,
    bool? isResetPasswordLoading,
    bool? isResend,
  }) =>
      AuthState(
        userInfoEntity: userInfoEntity ?? this.userInfoEntity,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        isPasswordVis: isPasswordVis ?? this.isPasswordVis,
        authStatus: authStatus ?? this.authStatus,
      );

  @override
  List<Object?> get props => [
        userInfoEntity,
        error,
        isLoading,
        isPasswordVis,
        authStatus,
      ];
}
