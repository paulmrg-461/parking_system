
# Guía para Implementar Clean Architecture con Flutter

## Introducción

Esta guía te llevará a través de los pasos necesarios para crear un proyecto en Flutter aplicando Clean Architecture, conectándote a una API HTTP y utilizando Bloc como gestor de estado. Al final de esta guía, tendrás un proyecto bien estructurado que sigue los principios de Clean Architecture y es fácilmente mantenible y escalable.

## 1. Estructura del Proyecto

Clean Architecture se basa en separar el código en capas para lograr una mayor mantenibilidad y escalabilidad. En un proyecto Flutter, puedes estructurarlo en las siguientes capas:

- **Domain (Dominio)**: Esta capa contiene la lógica de negocio pura, incluyendo entidades, casos de uso y repositorios abstractos.
- **Data (Datos)**: Maneja la implementación de los repositorios, fuentes de datos (remotas y locales), y modelos de datos.
- **Presentation (Presentación)**: Contiene la UI, los widgets, estados (Bloc), eventos y el mapeo de estados a UI.

### Estructura del Proyecto

```text
lib/
├── core/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── blocs/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## 2. Implementar la Capa de Dominio

### Entidades

Las entidades son clases que representan objetos de la lógica de negocio.

```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
}
```

### Casos de Uso (UseCases)

Los casos de uso contienen la lógica de negocio y utilizan los repositorios.

```dart
// domain/usecases/get_user.dart
class GetUser {
  final UserRepository repository;
  GetUser(this.repository);

  Future<User> call(String id) async {
    return await repository.getUser(id);
  }
}
```

### Repositorios (Interfaces)

Los repositorios definen los métodos que necesitas para interactuar con las fuentes de datos.

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
}
```

## 3. Implementar la Capa de Datos

### Modelos

Los modelos representan la estructura de datos recibida o enviada a la API.

```dart
// data/models/user_model.dart
class UserModel extends User {
  UserModel({required String id, required String name}) : super(id: id, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name']);
  }
}
```

### Fuentes de Datos (Datasources)

Las fuentes de datos implementan la conexión con la API (remota) o la base de datos (local).

```dart
// data/datasources/user_remote_data_source.dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final HttpClient client;
  UserRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> getUser(String id) async {
    final response = await client.get('https://api.example.com/user/$id');
    return UserModel.fromJson(response.data);
  }
}
```

### Repositorios

Los repositorios implementan los métodos definidos en la capa de dominio y usan las fuentes de datos.

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUser(String id) async {
    return await remoteDataSource.getUser(id);
  }
}
```

## 4. Implementar la Capa de Presentación

### Bloc

El Bloc maneja la lógica de presentación. Recibe eventos y emite estados.

```dart
// presentation/blocs/user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUser;

  UserBloc(this.getUser) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetUserEvent) {
      yield UserLoading();
      final user = await getUser(event.id);
      yield UserLoaded(user);
    }
  }
}
```

### UI

La UI representa la interfaz de usuario basada en los estados gestionados por Bloc.

```dart
// presentation/pages/user_page.dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(context.read<GetUser>()),
      child: Scaffold(
        appBar: AppBar(title: Text('User')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return CircularProgressIndicator();
            } else if (state is UserLoaded) {
              return Text('User: ${state.user.name}');
            }
            return Text('Unknown state');
          },
        ),
      ),
    );
  }
}
```

## 5. Integración y Dependencias

### Paquetes necesarios

Agrega los siguientes paquetes en tu archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.0.0
  dio: ^5.0.0
  get_it: ^7.2.0
```

### Inyección de Dependencias

La inyección de dependencias permite conectar las capas de manera flexible y desacoplada. `get_it` es un contenedor de dependencias que facilita esta tarea.

#### Configuración de `get_it`

Crea un archivo `service_locator.dart` para gestionar la inyección de dependencias:

```dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/get_user.dart';
import 'presentation/blocs/user_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Register external dependencies
  sl.registerLazySingleton(() => Dio());

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUser(sl()));

  // Blocs
  sl.registerFactory(() => UserBloc(sl()));
}
```

#### Uso de Dependencias Registradas

Para utilizar las dependencias registradas:

```dart
BlocProvider(
  create: (_) => sl<UserBloc>(),
  child: UserPage(),
);
```

## 6. Ejecución del Proyecto

Una vez configurado todo, puedes ejecutar tu aplicación con:

```bash
flutter run
```

Siguiendo estos pasos, habrás implementado un proyecto en Flutter con Clean Architecture, gestionando estado con Bloc y conectándote a una API HTTP. Este enfoque asegura un código bien estructurado, mantenible y escalable.
