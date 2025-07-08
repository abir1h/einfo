import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../common/routes/app_route.dart';
import '../common/routes/app_route_args.dart';

Uri? globalDeepLinkUri;

class AppLinkService {
  static final AppLinkService _instance = AppLinkService._internal();
  factory AppLinkService() => _instance;

  AppLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      _subscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _handleUri(uri);
        },
        onError: (err) {
          debugPrint('AppLinks stream error: $err');
        },
      );
    } catch (e) {
      debugPrint('AppLinks initialization error: $e');
    }
  }

  void _handleUri(Uri uri) {
    globalDeepLinkUri = uri; // ✅ Store URI globally

    AppRoute.navigatorKey.currentState?.pushNamed(
      AppRoute.landingScreen,
      arguments: LandingScreenArgs(url: uri.toString()),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
