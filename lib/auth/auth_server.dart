import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<AuthServer> authServer = ValueNotifier(AuthServer());

class AuthServer {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  

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
  
  Future<void> resetPassword({required String email}) async {
    try {
      var acs = ActionCodeSettings(
      url: 'https://gallery-hub-448c2.firebaseapp.com', // This URL is the ID for the link
      handleCodeInApp: true, // <--- This is the magic switch
      androidPackageName: 'com.example.gallery_hub', // MUST match your app exactly
      androidInstallApp: true, // Install app if not found?
      androidMinimumVersion: '12', // Minimum version of your app
    );

    // 2. Send the email with these settings
    await firebaseAuth.sendPasswordResetEmail(
      email: email, 
      actionCodeSettings: acs
    );
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
  Future<void> confirmPasswordReset({
  required String code,        // The code we get from the link
  required String newPassword, // The password the user typed
}) async {
  try {
    await firebaseAuth.confirmPasswordReset(
      code: code, 
      newPassword: newPassword
    );
  } catch (e) {
    debugPrint("Error confirming reset: $e");
    rethrow;
  }
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
Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; 
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
      
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      rethrow;
    }
  }
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}