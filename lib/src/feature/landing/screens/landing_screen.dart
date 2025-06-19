import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final WebViewController controller;

  bool isLoading = true;
  double _progress = 0;
  bool hasInternet = false;
  bool hasLoadedOnce = false;

  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  final String url = "https://www.einfosite.com/";
  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ Could not launch $url");
    }
  }
  @override
  void initState() {
    super.initState();

    // Create WebView controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(

          onNavigationRequest: (NavigationRequest request) {
            print(request.url);
            final uri = Uri.parse(request.url);
            if (uri.host.contains("einfo.site") &&
                uri.pathSegments.contains('login-success')) {

              final username = uri.pathSegments[1];
              debugPrint("✅ Logged in as: $username");

              // Send FCM token to API
              return NavigationDecision.navigate;
            }
            final isInternalDomain = uri.host.contains("einfosite.com") ;

            if (isInternalDomain) {

              return NavigationDecision.navigate;
            } else {
              _launchExternalUrl(request.url);
              return NavigationDecision.prevent;
            }

          },

          onPageStarted: (_) {
            setState(() {
              isLoading = true;
              _progress = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
              _progress = 1.0;
              hasLoadedOnce = true;
            });
          },
        ),
      );

    // Listen for connectivity changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final hasNetwork =
          results.isNotEmpty && results.first != ConnectivityResult.none;

      setState(() {
        hasInternet = hasNetwork;
      });

      if (hasNetwork && !hasLoadedOnce) {
        controller.loadRequest(Uri.parse(url));
      }
    });

    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final hasNetwork =
        results.isNotEmpty && results.first != ConnectivityResult.none;

    setState(() {
      hasInternet = hasNetwork;
    });

    if (hasNetwork && !hasLoadedOnce) {
      controller.loadRequest(Uri.parse(url));
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
      body: Stack(
        children: [
          hasInternet
              ? (isLoading || _progress < 1)
                    ? Positioned(
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
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SafeArea(
                        child: WebViewWidget(
                          key: const ValueKey("webview"),
                          controller: controller,
                        ),
                      )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.grey, size: 60),
                      SizedBox(height: 20),
                      Text(
                        "No Internet Connection",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Waiting for internet...",
                        style: TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                ),

          // if (hasInternet && (isLoading || _progress < 1))
          //   Positioned(
          //     top: 0,
          //     left: 0,
          //     right: 0,
          //     child: SafeArea(
          //       child: AnimatedOpacity(
          //         opacity: _progress < 1 ? 1.0 : 0.0,
          //         duration: const Duration(milliseconds: 300),
          //         child: LinearProgressIndicator(
          //           value: _progress,
          //           minHeight: 3,
          //           backgroundColor: Colors.grey.shade200,
          //           valueColor: const AlwaysStoppedAnimation<Color>(
          //             Colors.blueAccent,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //
          // if (!hasInternet)
          //   const Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.wifi_off, color: Colors.grey, size: 60),
          //         SizedBox(height: 20),
          //         Text(
          //           "No Internet Connection",
          //           style: TextStyle(fontSize: 18, color: Colors.black54),
          //         ),
          //         SizedBox(height: 10),
          //         Text(
          //           "Waiting for internet...",
          //           style: TextStyle(color: Colors.black38),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}
