import 'dart:io';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';

/// Handles Facebook App Install Attribution for Android.
///
/// On first app open, the Meta SDK automatically fires an ACTIVATE_APP event
/// when auto-logging is enabled. Facebook matches this event against its ad
/// click records to attribute the install to a specific campaign in Ads Manager.
class FacebookAttributionService {
  static final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  /// Call once at app startup.
  static Future<void> initialize() async {
    // Only initialize for Android as per user requirement
    if (!Platform.isAndroid) {
      debugPrint('ℹ️ Facebook Attribution: skipped (platform is not Android)');
      return;
    }

    try {
      // Enable auto-logging — this makes the Meta SDK automatically fire
      // the ACTIVATE_APP event, which Facebook uses to count ad installs
      await _facebookAppEvents.setAdvertiserTracking(enabled: true);
      await _facebookAppEvents.setAutoLogAppEventsEnabled(true);
      debugPrint('✅ Facebook Attribution: auto-logging enabled for Android');
    } catch (e) {
      // Never crash the app due to attribution failure
      debugPrint('⚠️ Facebook Attribution: failed to initialize — $e');
    }
  }

  /// Optional: log when a user completes registration / signup.
  /// Useful for optimising ad campaigns towards quality installs.
  static Future<void> logCompleteRegistration() async {
    if (!Platform.isAndroid) return;

    try {
      await _facebookAppEvents.logEvent(
        name: 'CompleteRegistration',
        parameters: {'method': 'app'},
      );
      debugPrint('✅ Facebook Attribution: CompleteRegistration event logged');
    } catch (e) {
      debugPrint('⚠️ Facebook Attribution: failed to log event — $e');
    }
  }
}
