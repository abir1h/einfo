import 'dart:async';
import '../../../common/routes/app_route_args.dart';
import '../gateways/landing_gateway.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LandingScreen extends StatefulWidget {
  final Object? arguments;
  const LandingScreen({super.key, this.arguments});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LandingScreenArgs screenArgs;
  InAppWebViewController? webViewController;

  bool isLoading = true;
  double _progress = 0;
  bool hasInternet = false;
  bool hasLoadedOnce = false;

  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _checkInitialConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  void _setupConnectivityListener() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasNetwork = results.isNotEmpty && results.first != ConnectivityResult.none;
      setState(() => hasInternet = hasNetwork);

      if (hasNetwork && !hasLoadedOnce) {
        webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri((widget.arguments as LandingScreenArgs).url)),
        );
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final hasNetwork = result != ConnectivityResult.none;
    setState(() => hasInternet = hasNetwork);

    if (hasNetwork && !hasLoadedOnce) {
      webViewController?.loadUrl(
        urlRequest: URLRequest(url: WebUri((widget.arguments as LandingScreenArgs).url)),
      );
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

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            if (hasInternet)
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri((widget.arguments as LandingScreenArgs).url),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  useOnDownloadStart: true,
                  useShouldOverrideUrlLoading: true,allowFileAccess: true
                ),


                onWebViewCreated: (controller) {
                  webViewController = controller;

                  // controller.setOnShowFileChooser((params) async {
                  //   return null; // Let system open file picker (camera/gallery)
                  // });
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                    isLoading = progress < 100;
                  });
                },
                shouldOverrideUrlLoading: (controller, navAction) async {
                  final uri = navAction.request.url!;
                  debugPrint("🔗 Navigating to: ${uri.toString()}");

                  final isLoginSuccess = uri.host.contains("einfo.site") &&
                      uri.pathSegments.length > 1 &&
                      uri.pathSegments.first == "login-success";

                  if (isLoginSuccess) {
                    final username = uri.pathSegments[1];
                    debugPrint("✅ Logged in as: $username");

                    try {
                      final fcmToken = await FirebaseMessaging.instance.getToken();
                      if (fcmToken != null) {
                        SendTokenGateway.endToken(fcmToken, username);
                      }
                    } catch (e) {
                      debugPrint("❌ Failed to get FCM token: $e");
                    }

                    return NavigationActionPolicy.ALLOW;
                  }

                  final isInternal = uri.host.contains("einfosite.com") ||uri.host.contains("einfo.site") ;
                  if (!isInternal) {
                    _launchExternalUrl(uri.toString());
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
              ),

            if (!hasInternet)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    SizedBox(height: 20),
                    Text("No Internet Connection", style: TextStyle(fontSize: 18, color: Colors.black54)),
                    SizedBox(height: 10),
                    Text("Waiting for internet...", style: TextStyle(color: Colors.black38)),
                  ],
                ),
              ),

            if (hasInternet && isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: AnimatedOpacity(
                    opacity: _progress < 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 3,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
