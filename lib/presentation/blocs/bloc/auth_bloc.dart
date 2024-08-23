import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:parking_system/domain/entities/user_entity.dart';
import 'package:parking_system/domain/usecases/authentication/authentication_use_cases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final Register registerUseCase;
  final GetCurrentUser getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthCheckUserEvent>(_onCheckUser);
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onRegister(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckUser(
      AuthCheckUserEvent event, Emitter<AuthState> emit) async {
    final user = await getCurrentUserUseCase();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
