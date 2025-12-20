import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthServer> authServer = ValueNotifier(AuthServer());

class AuthServer {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User ? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(fullName);
    await credential.user?.reload();
  }
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
  Future<void> updateUsername({required String username}) async {
    await currentUser?.updateDisplayName(username);
    await currentUser?.reload();
  }
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    // Re-authenticate the user
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser?.reauthenticateWithCredential(credential);
    // Delete the user account and sign out
    await currentUser?.delete();
    await firebaseAuth.signOut();

  }
  // Future<void> updateEmail({
  //   required String newEmail,
  //   required String password,
  //   // required String confirmPassword,
  // }) async {
  //   // Re-authenticate the user
  //   AuthCredential credential = EmailAuthProvider.credential(
  //     email: currentUser!.email!,
  //     password: password,
  //     // password: confirmPassword,
  //   );
  //   await currentUser?.reauthenticateWithCredential(credential);
  //   // Update email
  //   await currentUser?.updateEmail(newEmail);
  //   await currentUser?.reload();
  // }

  Future<void> updatePassword({
    required String newPassword,
    required String currentPassword,
    required String email,
  }) async {
    // Re-authenticate the user
    AuthCredential credential = EmailAuthProvider.credential(
      email: currentUser!.email!,
      password: currentPassword,
    );
    await currentUser?.reauthenticateWithCredential(credential);
    // Update password
    await currentUser?.updatePassword(newPassword);
    await currentUser?.reload();
  }

  
}