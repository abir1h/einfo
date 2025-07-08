import 'dart:async';
import 'package:app_links/app_links.dart';

class AppLinkService {
  static final AppLinkService _instance = AppLinkService._internal();
  factory AppLinkService() => _instance;

  AppLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  /// Initializes the app link listeners
  Future<void> init({
    required void Function(Uri uri) onLinkReceived,
  }) async {
    try {
      // ✅ Use getInitialLink instead of getInitialAppLink
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        onLinkReceived(initialUri);
      }

      // Listen for app links while app is running
      _subscription = _appLinks.uriLinkStream.listen(
            (Uri uri) {
          onLinkReceived(uri);
        },
        onError: (err) {
          print('AppLinks stream error: $err');
        },
      );
    } catch (e) {
      print('AppLinks initialization error: $e');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
