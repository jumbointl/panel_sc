// web_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:webview_flutter/webview_flutter.dart';
import 'web_page_controller.dart';

class WebPage extends StatelessWidget { // <--- NOW STATELESS
  final String url;

  const WebPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // Initialize or find your controller
    // Using a tag ensures a unique controller instance per URL if needed
    final WebPageController controller = Get.put(
      WebPageController(initialUrl: url),
      tag: url, // Using the URL as a tag makes the controller instance unique to this page
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(url),

      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: controller.webViewController,
            ),
            Obx(() { // Obx widget from GetX listens to reactive variables
              if (controller.loadingPercentage.value < 100) {
                return LinearProgressIndicator(
                  value: controller.loadingPercentage.value / 100.0,
                );
              } else {
                // Return an empty widget when loading is complete
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}