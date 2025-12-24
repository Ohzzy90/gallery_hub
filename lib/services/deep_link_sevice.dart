import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:gallery_hub/auth/screens/confirm_password_screen.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void initDeepLinks(BuildContext context) {
    // Check if app was opened from a "Cold Start"
    _checkInitialLink(context);

    // Listen for links while app is running in background
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        // ignore: use_build_context_synchronously
        _handleLink(context, uri);
      }
    });
  }

  Future<void> _checkInitialLink(BuildContext context) async {
    try {
      final Uri? uri = await _appLinks.getInitialLink();
      if (uri != null) {
        // ignore: use_build_context_synchronously
        _handleLink(context, uri);
      }
    } catch (e) {
      debugPrint("Error getting initial link: $e");
    }
  }

void _handleLink(BuildContext context, Uri uri) {
  debugPrint("DEBUG: Received Deep Link: $uri");

  final mode = uri.queryParameters['mode'];
  final oobCode = uri.queryParameters['oobCode'];

  if (mode == 'resetPassword' && oobCode != null) {
    debugPrint("DEBUG: Reset mode found. Code: $oobCode");
    
    Future.microtask(() {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConfirmPasswordScreen(oobCode: oobCode),
        ),
      );
    });
  }
}

  void dispose() {
    _linkSubscription?.cancel();
  }
}