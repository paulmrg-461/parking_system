import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking_system/data/models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> register(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth auth;

  FirebaseAuthDataSourceImpl(this.auth);

  @override
  Future<UserModel?> login(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<UserModel?> register(String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    User? user = auth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    } else {
      return null;
    }
  }
}
