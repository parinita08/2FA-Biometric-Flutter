import 'package:email_password_login/api/firebase_api.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/biometric_screen.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'notifier/auth_notifier.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    context
        .read<FirebaseRepository>()
        .auth
        .authStateChanges()
        .listen((user) async {
      if (user != null) {
        print('>>> user');
        context.read<AuthNotifier>().setAuthState(AuthState.loading);

        context.read<AuthNotifier>().setAuthState(AuthState.biometricAuth);

        context.read<FirebaseRepository>().getUser(user.uid).then((u) {
          context.read<AuthNotifier>().setUser(u);
          context.read<AuthNotifier>().setAuthState(AuthState.authenticated);
        });
      } else {
        context.read<AuthNotifier>().setAuthState(AuthState.unAuthenticated);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();

    if (auth.viewState == AuthState.unAuthenticated) {
      return LoginScreen();
    } else if (auth.viewState == AuthState.authenticated) {
      return HomeScreen();
    } else if (auth.viewState == AuthState.biometricAuth) {
      return BiometricScreen();
    } else if (auth.viewState == AuthState.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container();
    }
  }
}
