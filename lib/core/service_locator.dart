import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:parking_system/data/datasources/firebase_auth_data_source.dart';
import 'package:parking_system/data/repositories/auth_repository_impl.dart';
import 'package:parking_system/domain/repositories/auth_repository.dart';
import 'package:parking_system/domain/usecases/authentication/authentication_use_cases.dart';
import 'package:parking_system/presentation/blocs/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        registerUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));
}
