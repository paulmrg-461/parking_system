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
  }) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthLoginEvent) {
      yield AuthLoading();
      final user = await loginUseCase(event.email, event.password);
      if (user != null) {
        yield AuthAuthenticated(user);
      } else {
        yield AuthError('Login failed');
      }
    } else if (event is AuthLogoutEvent) {
      yield AuthLoading();
      await logoutUseCase();
      yield AuthUnauthenticated();
    } else if (event is AuthRegisterEvent) {
      yield AuthLoading();
      final user = await registerUseCase(event.email, event.password);
      if (user != null) {
        yield AuthAuthenticated(user);
      } else {
        yield AuthError('Registration failed');
      }
    } else if (event is AuthCheckUserEvent) {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        yield AuthAuthenticated(user);
      } else {
        yield AuthUnauthenticated();
      }
    }
  }
}
