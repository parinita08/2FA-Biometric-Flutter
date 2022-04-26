import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';

class FirebaseRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  Future<void> postDetailsToFirestore(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final user =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      return UserModel.fromMap(user.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (auth.currentUser != null) {
        await postDetailsToFirestore(UserModel(
          email: email,
          uid: auth.currentUser!.uid,
          firstName: firstName,
          secondName: lastName,
        ));
      }

      return 'Account created successfully';
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          return "Your email address appears to be malformed.";

        case "wrong-password":
          return "Your password is wrong.";

        case "user-not-found":
          return "User with this email doesn't exist.";

        case "user-disabled":
          return "User with this email has been disabled.";

        case "too-many-requests":
          return "Too many requests";

        case "operation-not-allowed":
          return "Signing in with Email and Password is not enabled.";

        default:
          return "An undefined Error happened.";
      }
    }
  }

  // login function
  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return 'Login Successful';
    } on FirebaseAuthException catch (error) {
      print(error.message);
      print(error.code);
      switch (error.code) {
        case "invalid-email":
          return "Your email address appears to be malformed.";

        case "wrong-password":
          return "Your password is wrong.";

        case "user-not-found":
          return "User with this email doesn't exist.";

        case "user-disabled":
          return "User with this email has been disabled.";

        case "too-many-requests":
          return "Too many requests";

        case "operation-not-allowed":
          return "Signing in with Email and Password is not enabled.";

        default:
          return "An undefined Error happened.";
      }
    }
  }

  // the logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
