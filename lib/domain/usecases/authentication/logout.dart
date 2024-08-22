import 'package:parking_system/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;
  Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
