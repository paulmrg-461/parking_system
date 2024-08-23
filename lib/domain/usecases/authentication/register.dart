// domain/usecases/register.dart
import 'package:parking_system/domain/entities/user_entity.dart';
import 'package:parking_system/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.register(email, password);
  }
}
