// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/signin/auth_event.dart';
import 'package:schoolui/bloc/signin/auth_state.dart';

import '../../repository/auth_repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final authResponse =
            await authRepository.login(event.email, event.password);
        emit(AuthAuthenticated(authResponse: authResponse));
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final authResponse = await authRepository.signup(
            event.email, event.name, event.address, event.phone);
        emit(Authenticated(signupResponse: authResponse));
      } catch (e) {
        emit(SignupError(error: e.toString()));
      }
    });

    on<TokenRefreshed>((event, emit) async {
      try {
        final newAccessToken =
            await authRepository.refreshToken(event.refreshToken);
        // Handle new access token here
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });
  }
}
