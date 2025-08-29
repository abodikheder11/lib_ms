import 'dart:io'; // For SocketException, HttpException
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        isAuthor: e.isAuthor
      );
      final msg = (res['message'] ?? res['msg'] ?? 'Registered. Verify email.') as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_author_${e.email}', e.isAuthor);

      emit(AuthUnverified(e.email, message: msg));
    } catch (err) {
      emit(AuthError(_prettyError(err)));
    }
  }
  Future<void> _onSignIn(SignInRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final (user, token) = await _repo.signIn(
        email: e.email,
        password: e.password,
        isAuthor: e.isAuthor,
      );
      if (token == null) {
        emit(AuthUnverified(e.email,
            message: 'Please verify your email or check credentials.'));
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
      // Even if sign-out fails, clear local auth state.
      emit(AuthUnauthenticated());
    }
  }

  String _prettyError(Object err) {
    if (err is http.ClientException) {
      final uriInfo = err.uri != null ? ' (${err.uri})' : '';
      return 'Request error: ${err.message}$uriInfo';
    }
    if (err is SocketException) {
      return 'Network error: ${err.message.isNotEmpty ? err.message : 'Please check your internet connection.'}';
    }
    if (err is HttpException) {
      return 'HTTP error: ${err.message}';
    }
    if (err is FormatException) {
      return 'Bad response format.';
    }
    return err.toString();
  }
}
