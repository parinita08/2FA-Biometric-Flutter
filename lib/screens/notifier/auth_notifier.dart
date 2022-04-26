import 'package:email_password_login/model/user_model.dart';
import 'package:flutter/cupertino.dart';

enum AuthState { authenticated, biometricAuth, unAuthenticated, loading }

class AuthNotifier extends ChangeNotifier {
  UserModel? loggedInUser;

  late AuthState _authState = AuthState.unAuthenticated;

  AuthState get viewState => _authState;

  void setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  void setUser(UserModel? user) {
    loggedInUser = user;
    notifyListeners();
  }
}
