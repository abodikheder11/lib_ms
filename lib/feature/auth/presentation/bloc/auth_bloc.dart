import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_user.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUp);
    on<SignInRequested>(_onSignIn);
    on<VerifyEmailRequested>(_onVerifyEmail);
    on<ForgotPasswordRequested>(_onForgotPassword);
    on<ResetPasswordRequested>(_onResetPassword);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final token = await _repo.getToken();
    if (token == null) {
      emit(AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(const AuthUser()));
    }
  }

  Future<void> _onSignUp(SignUpRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await _repo.signUp(
        firstname: e.firstname,
        lastname: e.lastname,
        email: e.email,
        location: e.location,
        password: e.password,
        passwordConfirmation: e.passwordConfirmation,
      );
      final msg = (res['message'] ?? res['msg'] ?? 'Registered. Verify email.') as String;
      emit(AuthUnverified(e.email, message: msg));
    } catch (err) {
      emit(AuthError(_prettyError(err)));
    }
  }

  Future<void> _onSignIn(SignInRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final (user, token) = await _repo.signIn(email: e.email, password: e.password);
      if (token == null) {
        emit(AuthUnverified(e.email, message: 'Please verify your email or check credentials.'));
        return;
      }
      emit(AuthAuthenticated(user ?? const AuthUser()));
    } catch (err) {
      emit(AuthError(_prettyError(err)));
    }
  }

  Future<void> _onVerifyEmail(VerifyEmailRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.verifyEmail(email: e.email, code: e.code);
      emit(AuthUnauthenticated());
    } catch (err) {
      emit(AuthError(_prettyError(err)));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.forgotPassword(email: e.email);
      emit(PasswordResetEmailSent(e.email));
    } catch (err) {
      emit(AuthError(_prettyError(err)));
    }
  }

  Future<void> _onResetPassword(ResetPasswordRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.resetPassword(
        email: e.email,
        token: e.token,
        password: e.password,
        passwordConfirmation: e.passwordConfirmation,
      );
      emit(PasswordResetSuccess());
    } catch (err) {
      emit(AuthError(_prettyError(err)));
    }
  }

  Future<void> _onSignOut(SignOutRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.signOut();
      emit(AuthUnauthenticated());
    } catch (err) {
      emit(AuthUnauthenticated());
    }
  }

  String _prettyError(Object err) {
    if (err is DioException) {
      final status = err.response?.statusCode;
      final data = err.response?.data;
      final msg = data is Map && data['message'] != null
          ? data['message'].toString()
          : err.message ?? 'Network error';
      return status != null ? '[$status] $msg' : msg;
    }
    return err.toString();
  }
}