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
  
  // Key for saving to storage
  static const String _kLastUsedCodeKey = 'last_used_oob_code';

  void initDeepLinks() {
    _checkInitialLink();

    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        // Stream links are "manual" clicks, so we always want to handle them
        _handleLink(uri);
      }
    });
  }

  Future<void> _checkInitialLink() async {
    try {
      final Uri? uri = await _appLinks.getInitialLink();
      if (uri != null) {
        // For initial links, we pass a flag to check storage first
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
      
      // 1. THE STORAGE CHECK
      // If this is an app start (checkStorage=true), we see if we used this code before.
      if (checkStorage) {
        final prefs = await SharedPreferences.getInstance();
        final lastCode = prefs.getString(_kLastUsedCodeKey);
        
        // If the code from the link matches the one on disk, it's the "Restart Bug".
        // We stop here and show NO error.
        if (lastCode == oobCode) {
          debugPrint("DEBUG: Code already used (found in storage). Ignoring.");
          return;
        }
      }

      try {
        // 2. Verify with Firebase
        await authServer.value.firebaseAuth.verifyPasswordResetCode(oobCode);
        
        // 3. SUCCESS: Save this code to storage so we don't trigger it again on restart
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kLastUsedCodeKey, oobCode);

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ConfirmPasswordScreen(oobCode: oobCode),
          ),
        );
      } catch (e) {
        debugPrint("DEBUG: Verification failed: $e");

        // 4. FAILURE: Show the error.
        // Since we filtered out the "Restart Bug" in Step 1, any error that reaches 
        // here is a REAL invalid link (expired or broken), so we MUST show it.
        final currentContext = navigatorKey.currentContext;
        if (currentContext != null) {
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