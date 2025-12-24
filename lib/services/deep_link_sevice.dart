import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:gallery_hub/auth/auth_server.dart';
import 'package:gallery_hub/auth/screens/confirm_password_screen.dart';
import 'package:gallery_hub/navigator/global_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  
  static const String _kLastUsedCodeKey = 'last_used_oob_code';

  void initDeepLinks() {
    _checkInitialLink();

    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleLink(uri);
      }
    });
  }

  Future<void> _checkInitialLink() async {
    try {
      final Uri? uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleLink(uri, checkStorage: true);
      }
    } catch (e) {
      debugPrint("Error getting initial link: $e");
    }
  }

  void _handleLink(Uri uri, {bool checkStorage = false}) async {
    final mode = uri.queryParameters['mode'];
    final oobCode = uri.queryParameters['oobCode'];
    debugPrint("DEBUG: Processing Link: mode=$mode, oobCode=$oobCode");

    if (mode == 'resetPassword' && oobCode != null) {

      if (checkStorage) {
        final prefs = await SharedPreferences.getInstance();
        final lastCode = prefs.getString(_kLastUsedCodeKey);

        if (lastCode == oobCode) {
          debugPrint("DEBUG: Code already used (found in storage). Ignoring.");
          return;
        }
      }

      try {
        await authServer.value.firebaseAuth.verifyPasswordResetCode(oobCode);
        
        //Save this code to prevent reuse and navigate to reset screen.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kLastUsedCodeKey, oobCode);

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ConfirmPasswordScreen(oobCode: oobCode),
          ),
        );
      } catch (e) {
        debugPrint("DEBUG: Verification failed: $e");
        final currentContext = navigatorKey.currentContext;
        if (currentContext != null) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text("This reset link has expired or is invalid."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}