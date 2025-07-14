import 'dart:async';
import 'dart:io';

import '../../../common/routes/app_route_args.dart';
import '../gateways/landing_gateway.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LandingScreen extends StatefulWidget {
  final Object? arguments;
  const LandingScreen({super.key, this.arguments});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
  bool isLoading = true;
  double _progress = 0;
  bool hasInternet = false;
  bool hasLoadedOnce = false;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  late PullToRefreshController pullToRefreshController;

  // Track dark mode
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    _setStatusBarColor(_isDarkMode);

    _checkInitialConnectivity();
    _setupConnectivityListener();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blueAccent),
      onRefresh: () async {
        if (webViewController != null) {
          if (Platform.isAndroid) {
            webViewController!.reload();
          } else if (Platform.isIOS) {
            final url = await webViewController!.getUrl();
            if (url != null) {
              webViewController!.loadUrl(urlRequest: URLRequest(url: url));
            }
          }
        }
      },
    );
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final isDark = brightness == Brightness.dark;
    if (isDark != _isDarkMode) {
      setState(() {
        _isDarkMode = isDark;
      });
      _setStatusBarColor(isDark);
    }
  }

  void _setStatusBarColor(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDarkMode ? Colors.black : Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void _setupConnectivityListener() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final hasNetwork =
          results.isNotEmpty && results.first != ConnectivityResult.none;
      setState(() => hasInternet = hasNetwork);

      if (hasNetwork && !hasLoadedOnce) {
        webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_url)));
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final hasNetwork = result != ConnectivityResult.none;
    setState(() => hasInternet = hasNetwork);

    if (hasNetwork && !hasLoadedOnce) {
      webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_url)));
    }
  }

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ Could not launch $url");
    }
  }

  Future<bool> _handleWebViewFileUploadPermissions() async {
    if (Platform.isAndroid) {
      final results = await [
        Permission.camera,
        Permission.photos,
        Permission.storage,
      ].request();
      final needsSettings = results.values.any(
        (status) => status.isPermanentlyDenied,
      );

      if (needsSettings) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Permission permanently denied. Enable it from Settings.",
              ),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
              ),
            ),
          );
        }
        return false;
      }

      return results.values.every((status) => status.isGranted);
    }

    if (Platform.isIOS) {
      final result = await Permission.photos.request();
      if (result.isPermanentlyDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Photo access denied. Enable from Settings."),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
              ),
            ),
          );
        }
        return false;
      }
      return result.isGranted;
    }

    return true;
  }

  String get _url => (widget.arguments as LandingScreenArgs).url;

  @override
  void dispose() {
    connectivitySubscription.cancel();
    pullToRefreshController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? Colors.black : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;

    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null) {
          bool canGoBack = await webViewController!.canGoBack();
          if (canGoBack) {
            webViewController!.goBack();
            return false; // Don't pop the screen, just go back in webview
          }
        }
        return true; // Pop the screen if no back history in webview
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            color: backgroundColor,
            child: Column(
              children: [
                if (hasInternet && isLoading)
                  AnimatedOpacity(
                    opacity: _progress < 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 3,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    ),
                  ),
                Expanded(
                  child: hasInternet
                      ? InAppWebView(
                          initialUrlRequest: URLRequest(url: WebUri(_url)),
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true,
                            mediaPlaybackRequiresUserGesture: false,
                            allowsInlineMediaPlayback: true,
                            useOnDownloadStart: true,
                            useShouldOverrideUrlLoading: true,
                            allowFileAccess: true,
                            verticalScrollBarEnabled: false,
                          ),
                          pullToRefreshController: pullToRefreshController,
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                            controller.addJavaScriptHandler(
                              handlerName: 'onThemeChange',
                              callback: (args) {
                                if (args.isNotEmpty && args[0] is String) {
                                  final isDark = args[0] == 'dark';
                                  if (isDark != _isDarkMode) {
                                    setState(() {
                                      _isDarkMode = isDark;
                                    });
                                    _setStatusBarColor(isDark);
                                  }
                                }
                              },
                            );
                          },
                          onLoadStop: (controller, url) async {
                            pullToRefreshController.endRefreshing();
                            setState(() {
                              hasLoadedOnce = true;
                              isLoading = false;
                              _progress = 1.0;
                            });

                            await controller.evaluateJavascript(
                              source: """
                              function detectTheme() {
                                const isDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
                                window.flutter_inappwebview.callHandler('onThemeChange', isDark ? 'dark' : 'light');
                              }
                              detectTheme();
                              if (window.matchMedia) {
                                window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
                                  detectTheme();
                                });
                              }
                            """,
                            );
                          },
                          onLoadError: (controller, url, code, message) {
                            pullToRefreshController.endRefreshing();
                            setState(() {
                              isLoading = false;
                              _progress = 1.0;
                            });
                          },
                          onProgressChanged: (controller, progress) {
                            setState(() {
                              _progress = progress / 100;
                              isLoading = progress < 100;
                            });
                          },
                          onPermissionRequest: (controller, request) async {
                            final granted =
                                await _handleWebViewFileUploadPermissions();
                            return PermissionResponse(
                              resources: request.resources,
                              action: granted
                                  ? PermissionResponseAction.GRANT
                                  : PermissionResponseAction.DENY,
                            );
                          },
                          shouldOverrideUrlLoading:
                              (controller, navAction) async {
                                final uri = navAction.request.url;
                                if (uri == null)
                                  return NavigationActionPolicy.ALLOW;

                                debugPrint(
                                  "🔗 Navigating to: ${uri.toString()}",
                                );

                                if (uri.scheme == 'tel' ||
                                    uri.scheme == 'mailto') {
                                  try {
                                    if (uri.scheme == 'tel') {
                                      await _launchPhone(context, uri.path);
                                    } else if (uri.scheme == 'mailto') {
                                      await _launchEmail(context, uri.path);
                                    }
                                  } catch (e) {
                                    debugPrint('❌ Error launching URL: $e');
                                  }

                                  return NavigationActionPolicy.CANCEL;
                                }

                                final isLoginSuccess =
                                    uri.host.contains("einfo.site") &&
                                    uri.pathSegments.length > 1 &&
                                    uri.pathSegments.first == "login-success";

                                final isLogOutSuccess =
                                    uri.host.contains("einfo.site") &&
                                    uri.pathSegments.length > 1 &&
                                    uri.pathSegments.first == "logout-success";

                                if (isLoginSuccess) {
                                  final username = uri.pathSegments[1];
                                  debugPrint("✅ Logged in as: $username");

                                  try {
                                    final fcmToken = Platform.isAndroid
                                        ? await FirebaseMessaging.instance
                                              .getToken()
                                        : await FirebaseMessaging.instance
                                              .getToken();
                                    if (fcmToken != null) {
                                      await SendTokenGateway.endToken(
                                        fcmToken,
                                        username,
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint("❌ Failed to get FCM token: $e");
                                  }

                                  return NavigationActionPolicy.ALLOW;
                                }

                                if (isLogOutSuccess) {
                                  final username = uri.pathSegments[1];
                                  debugPrint("✅ Logged in as: $username");

                                  try {
                                    final fcmToken = await FirebaseMessaging
                                        .instance
                                        .getToken();
                                    if (fcmToken != null) {
                                      await SendTokenGateway.removeToken(
                                        fcmToken,
                                        username,
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint("❌ Failed to get FCM token: $e");
                                  }

                                  return NavigationActionPolicy.ALLOW;
                                }

                                final isInternal =
                                    uri.host.contains("einfo.site") ||
                                    uri.host.contains("einfosite.com");
                                if (!isInternal) {
                                  _launchExternalUrl(uri.toString());
                                  return NavigationActionPolicy.CANCEL;
                                }

                                return NavigationActionPolicy.ALLOW;
                              },
                        )
                      : _buildNoInternet(textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoInternet(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18, color: textColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 10),
          Text(
            "Waiting for internet...",
            style: TextStyle(color: textColor.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(BuildContext context, String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar(context, "No dialer app found.");
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar(context, "No email app found.");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
