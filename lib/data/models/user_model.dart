import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_system/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.uid, required super.email});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(uid: user.uid, email: user.email!);
  }
}
