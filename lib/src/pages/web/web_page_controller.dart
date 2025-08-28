import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart'; // Required for SnackPosition and Colors

enum WebViewLoadState { initial, loading, success, error }

class WebPageController extends GetxController {
  // --- Reactive Variables ---
  final RxInt loadingPercentage = 0.obs;
  final RxString currentPageTitle = ''.obs; // To store the current page title
  final RxBool canGoBack = false.obs;       // To check if webview can go back
  final RxBool canGoForward = false.obs;    // To check if webview can go forward
  final Rx<WebViewLoadState> loadState = WebViewLoadState.initial.obs;
  final RxString errorMessage = ''.obs;     // To store any error messages

  // --- Non-Reactive Variables ---
  late final WebViewController webViewController;
  final String initialUrl;

  // --- Constructor ---
  WebPageController({required this.initialUrl});

  // --- Lifecycle Methods ---
  @override
  void onInit() {
    super.onInit();
    _initializeWebView();
  }

  // --- Private Methods ---
  void _initializeWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Optional: for transparent background
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          print('Page started loading: $url');
          loadState.value = WebViewLoadState.loading;
          loadingPercentage.value = 0;
          errorMessage.value = ''; // Clear previous errors
          _updateNavigationState();
        },
        onProgress: (int progress) {
          loadingPercentage.value = progress;
        },
        onPageFinished: (String url) async {
          print('Page finished loading: $url');
          loadingPercentage.value = 100;
          loadState.value = WebViewLoadState.success;
          // Fetch page title (optional)
          final title = await webViewController.getTitle();
          if (title != null) {
            currentPageTitle.value = title;
          }
          _updateNavigationState();
        },
        onWebResourceError: (WebResourceError error) {
          print('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
                url: ${error.url}
                        ''');
          loadState.value = WebViewLoadState.error;
          errorMessage.value = error.description;
          loadingPercentage.value = 100; // Stop progress bar
          // Optionally, show a more prominent error message or navigate to an error page
          Get.snackbar(
            "Loading Error",
            error.description,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          _updateNavigationState();
        },
        onNavigationRequest: (NavigationRequest request) {
          // Example: Prevent navigation to certain domains
          if (request.url.startsWith('https://www.youtube.com/')) {
            print('Blocking navigation to ${request.url}');
            // Get.snackbar("Blocked", "Navigation to YouTube is not allowed.", snackPosition: SnackPosition.BOTTOM);
            return NavigationDecision.prevent;
          }
          print('Allowing navigation to ${request.url}');
          return NavigationDecision.navigate;
        },
        // Optional: Handle HTTP errors (available in webview_flutter 4.x.x+)
        // onHttpError: (HttpResponseError error) {
        //   print('HTTP error: ${error.response?.statusCode} for ${error.request?.uri}');
        //   loadState.value = WebViewLoadState.error;
        //   errorMessage.value = 'HTTP Error: ${error.response?.statusCode}';
        //   loadingPercentage.value = 100; // Stop progress bar
        //   _updateNavigationState();
        // },
      ))
      ..loadRequest(Uri.parse(initialUrl));
  }

  Future<void> _updateNavigationState() async {
    canGoBack.value = await webViewController.canGoBack();
    canGoForward.value = await webViewController.canGoForward();
  }

  // --- Public Methods (callable from UI) ---

  Future<void> goBack() async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
      _updateNavigationState();
    } else {
      Get.snackbar("Navigation", "Cannot go back further.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> goForward() async {
    if (await webViewController.canGoForward()) {
      await webViewController.goForward();
      _updateNavigationState();
    } else {
      Get.snackbar("Navigation", "Cannot go forward further.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> reload() async {
    errorMessage.value = ''; // Clear errors before reloading
    loadState.value = WebViewLoadState.initial; // Reset state
    await webViewController.reload();
  }

  Future<void> loadNewUrl(String url) async {
    if (url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
      errorMessage.value = '';
      loadState.value = WebViewLoadState.initial;
      loadingPercentage.value = 0;
      await webViewController.loadRequest(Uri.parse(url));
    } else {
      Get.snackbar("Invalid URL", "The provided URL is not valid.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Example of running JavaScript
  Future<String?> runJavaScript(String jsString) async {
    try {
      final result = await webViewController.runJavaScriptReturningResult(jsString);
      return result.toString();
    } catch (e) {
      print("Error running JavaScript: $e");
      Get.snackbar("JavaScript Error", "Failed to execute script.", snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

// Clean up resources if needed, though GetX handles controller disposal
// @override
// void onClose() {
//   // If you had any manual stream subscriptions or heavy resources, dispose them here.
//   // webViewController itself is managed by the WebViewWidget.
//   print('WebPageController for $initialUrl is closing.');
//   super.onClose();
// }
}