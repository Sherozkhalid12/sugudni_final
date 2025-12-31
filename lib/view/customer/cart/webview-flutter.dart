import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/global-functions.dart' as global;
import 'package:sugudeni/utils/routes/routes-name.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? paymentMethod; // 'stripe' or 'orangemoney'

  const WebViewScreen({
    super.key,
    required this.url,
    this.paymentMethod,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentCompleted = false;
  String? _lastUrl;
  bool _wasOnStripeCheckout = false;
  bool _wasOnOrangeMoneyCheckout = false;
  int _successCheckAttempts = 0;
  static const int _maxSuccessCheckAttempts = 10;

  @override
  void initState() {
    super.initState();

    // Check initial URL to set payment provider flags
    final initialUri = Uri.tryParse(widget.url);
    if (initialUri != null) {
      final host = initialUri.host.toLowerCase();
      final path = initialUri.path.toLowerCase();
      if (host.contains('checkout.stripe.com') &&
          (path.contains('/c/pay/') || path.contains('/pay/'))) {
        _wasOnStripeCheckout = true;
        global.customPrint('Initial URL is Stripe checkout page');
      } else if (host.contains('orangemoney.com') &&
          (path.contains('/payment/') || path.contains('/checkout/'))) {
        _wasOnOrangeMoneyCheckout = true;
        global.customPrint('Initial URL is Orange Money checkout page');
      }
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            global.customPrint('WebView Page Started: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            _lastUrl = url;
            _handleUrlChange(url);
          },
          onPageFinished: (String url) async {
            global.customPrint('WebView Page Finished: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            _lastUrl = url;
            _handleUrlChange(url);

            // Inject JavaScript to check for payment success indicators in page content
            // Only check if payment hasn't completed and we haven't exceeded attempts
            if (mounted &&
                !_paymentCompleted &&
                _successCheckAttempts < _maxSuccessCheckAttempts) {
              _successCheckAttempts++;
              await _checkPageContentForSuccess();
            }
          },
          onWebResourceError: (WebResourceError error) {
            global.customPrint('WebView Error: ${error.description}');
            if (mounted && !_paymentCompleted) {
              _handlePaymentError('Network error: ${error.description}');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _checkPageContentForSuccess() async {
    if (_paymentCompleted || !mounted) return;

    try {
      // Get current URL to check if we're still on payment provider's page
      final currentUrl = await _controller.currentUrl();
      if (currentUrl == null) return;

      final uri = Uri.tryParse(currentUrl);
      if (uri == null) return;

      final host = uri.host.toLowerCase();
      final path = uri.path.toLowerCase();

      // Don't check page content if we're still on the payment provider's checkout page
      final isStripeCheckoutPage = host.contains('checkout.stripe.com') &&
          (path.contains('/c/pay/') || path.contains('/pay/'));
      final isOrangeMoneyCheckoutPage = host.contains('orangemoney.com') &&
          (path.contains('/payment/') || path.contains('/checkout/'));

      if (isStripeCheckoutPage || isOrangeMoneyCheckoutPage) {
        global.customPrint(
            'Still on payment provider page - skipping content check');
        return;
      }

      // JavaScript to check for payment success indicators in page content
      // Only run this after we've been redirected from the payment provider
      final jsCode = '''
        (function() {
          // Check for common success indicators in page content
          const bodyText = document.body ? document.body.innerText.toLowerCase() : '';
          const titleText = document.title ? document.title.toLowerCase() : '';
          const url = window.location.href.toLowerCase();
          
          // Success indicators - look for explicit success messages
          const successIndicators = [
            'payment successful',
            'payment completed',
            'thank you',
            'order confirmed',
            'payment confirmed',
            'transaction successful',
            'payment succeeded',
            'your payment was successful'
          ];
          
          // Check if any success indicator is found in body text (not just URL)
          let foundSuccess = false;
          for (let indicator of successIndicators) {
            if (bodyText.includes(indicator) || titleText.includes(indicator)) {
              foundSuccess = true;
              break;
            }
          }
          
          // Check for specific Stripe success elements (only if not on Stripe checkout page)
          const stripeSuccess = document.querySelector('[data-testid="payment-success"]') ||
                                document.querySelector('.payment-success') ||
                                document.querySelector('.success-message') ||
                                (document.querySelector('[class*="success"]') && 
                                 !document.querySelector('[class*="checkout"]'));
          
          if (stripeSuccess) {
            foundSuccess = true;
          }
          
          // Check for Orange Money specific success indicators
          const orangeMoneySuccess = bodyText.includes('payment successful') ||
                                     bodyText.includes('transaction successful') ||
                                     bodyText.includes('payment completed') ||
                                     bodyText.includes('merci') ||
                                     bodyText.includes('succès') ||
                                     titleText.includes('success') ||
                                     titleText.includes('succès');
          
          if (orangeMoneySuccess) {
            foundSuccess = true;
          }
          
          // Check for error messages in Orange Money callback
          const hasError = bodyText.includes('endpoint was not found') ||
                          bodyText.includes('error') ||
                          bodyText.includes('failed') ||
                          bodyText.includes('échec');
          
          if (hasError && !foundSuccess) {
            return JSON.stringify({
              success: false,
              error: true,
              bodyText: bodyText.substring(0, 200),
              titleText: titleText,
              url: window.location.href,
              status: null
            });
          }
          
          // Check URL parameters
          const urlParams = new URLSearchParams(window.location.search);
          const status = urlParams.get('status') || urlParams.get('payment_status') || urlParams.get('result');
          if (status && ['success', 'succeeded', 'paid', 'completed'].includes(status.toLowerCase())) {
            foundSuccess = true;
          }
          
          return JSON.stringify({
            success: foundSuccess,
            bodyText: bodyText.substring(0, 200),
            titleText: titleText,
            url: window.location.href,
            status: status
          });
        })();
      ''';

      final result = await _controller.runJavaScriptReturningResult(jsCode);
      global.customPrint('Page Content Check Result: $result');

      final resultStr = result.toString();

      // Special handling for Orange Money callback
      final currentUri = Uri.tryParse(currentUrl);
      if (currentUri != null) {
        final currentHost = currentUri.host.toLowerCase();
        final currentPath = currentUri.path.toLowerCase();
        final isCurrentOrangeMoneyCallback =
            currentHost.contains('api.sugudeni.com') &&
                (currentPath.contains('orange-callback') ||
                    currentPath.contains('orange_callback') ||
                    currentPath.contains('orangemoney-callback'));

        // If we're on Orange Money callback after checkout, treat as success
        // (Even if endpoint shows error, reaching callback means payment was processed)
        if (isCurrentOrangeMoneyCallback && _wasOnOrangeMoneyCheckout) {
          global.customPrint(
              'Orange Money callback reached after checkout - treating as success');
          _handlePaymentSuccess();
          return;
        }
      }

      // Check if result indicates error (for other cases)
      if (resultStr.toLowerCase().contains('"error":true') ||
          resultStr.toLowerCase().contains('"error": true')) {
        global.customPrint('Payment error detected from page content');
        // Only treat as failure if we're not on Orange Money callback
        if (currentUri != null) {
          final currentHost = currentUri.host.toLowerCase();
          final currentPath = currentUri.path.toLowerCase();
          final isCurrentOrangeMoneyCallback =
              currentHost.contains('api.sugudeni.com') &&
                  (currentPath.contains('orange-callback') ||
                      currentPath.contains('orange_callback') ||
                      currentPath.contains('orangemoney-callback'));

          if (isCurrentOrangeMoneyCallback && _wasOnOrangeMoneyCheckout) {
            // Already handled above, but double-check
            global.customPrint(
                'Orange Money callback with error - still treating as success');
            _handlePaymentSuccess();
            return;
          }
        }
        // If no success indicators, treat as failure
        _handlePaymentFailure('Payment processing error occurred');
        return;
      }

      // Check if result indicates success
      if (resultStr.toLowerCase().contains('"success":true') ||
          resultStr.toLowerCase().contains('"success": true')) {
        global.customPrint('Payment success detected from page content!');
        _handlePaymentSuccess(); // Fire and forget - async operation
        return;
      }

      // Also check URL one more time after page loads
      if (_lastUrl != null) {
        _handleUrlChange(_lastUrl!);
      }
    } catch (e) {
      global.customPrint('Error checking page content: $e');
      // Fallback to URL-based detection
      if (_lastUrl != null) {
        _handleUrlChange(_lastUrl!);
      }
    }
  }

  void _handleUrlChange(String url) {
    if (_paymentCompleted) return;

    global.customPrint('Handling URL change: $url');
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final urlLower = url.toLowerCase();
    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    // Payment method specific patterns
    final isStripe = widget.paymentMethod?.toLowerCase() == 'stripe';
    final isOrangeMoney = widget.paymentMethod?.toLowerCase() == 'orangemoney';

    // IMPORTANT: Do NOT treat Stripe checkout page as success
    // The checkout page URL is: checkout.stripe.com/c/pay/...
    // We should only detect success AFTER payment is completed and user is redirected
    final isStripeCheckoutPage = host.contains('checkout.stripe.com') &&
        (path.contains('/c/pay/') || path.contains('/pay/'));
    final isOrangeMoneyCheckoutPage = host.contains('orangemoney.com') &&
        (path.contains('/payment/') || path.contains('/checkout/'));

    // Track if we were on the payment provider's checkout page
    if (isStripeCheckoutPage) {
      _wasOnStripeCheckout = true;
      global.customPrint('On Stripe checkout page - waiting for redirect');
      return;
    }

    if (isOrangeMoneyCheckoutPage) {
      _wasOnOrangeMoneyCheckout = true;
      global
          .customPrint('On Orange Money checkout page - waiting for redirect');
      return;
    }

    // Orange Money specific callback handling
    final isOrangeMoneyCallback = host.contains('api.sugudeni.com') &&
        (path.contains('orange-callback') ||
            path.contains('orange_callback') ||
            path.contains('orangemoney-callback'));

    // If we're on Orange Money callback URL, check for success/failure indicators
    if (isOrangeMoney && isOrangeMoneyCallback) {
      global.customPrint(
          'Orange Money callback detected - checking for payment status');

      // Check query parameters for Orange Money specific status
      final queryParams = uri.queryParameters;
      final status = queryParams['status']?.toLowerCase() ?? '';
      final paymentStatus = queryParams['payment_status']?.toLowerCase() ?? '';
      final result = queryParams['result']?.toLowerCase() ?? '';
      final success = queryParams['success']?.toLowerCase() ?? '';

      // Orange Money success indicators
      if (status == 'success' ||
          status == 'succeeded' ||
          status == 'paid' ||
          status == 'completed' ||
          paymentStatus == 'success' ||
          paymentStatus == 'succeeded' ||
          paymentStatus == 'paid' ||
          result == 'success' ||
          result == 'succeeded' ||
          result == 'paid' ||
          success == 'true' ||
          success == '1') {
        global.customPrint(
            'Orange Money payment success detected from callback parameters');
        _handlePaymentSuccess();
        return;
      }

      // Orange Money failure indicators
      if (status == 'failed' ||
          status == 'cancelled' ||
          status == 'error' ||
          paymentStatus == 'failed' ||
          paymentStatus == 'cancelled' ||
          result == 'failed' ||
          result == 'cancelled' ||
          success == 'false' ||
          success == '0') {
        global.customPrint(
            'Orange Money payment failure detected from callback parameters');
        _handlePaymentFailure('Payment was cancelled or failed');
        return;
      }

      // If callback URL exists but no explicit status, check page content
      // This will be handled by _checkPageContentForSuccess
      global.customPrint(
          'Orange Money callback detected but no explicit status - will check page content');
    }

    // If we were on Stripe/Orange Money checkout and now we're on the website,
    // this likely means payment was completed and user was redirected
    final isWebsiteUrl = host.contains('sugudeni.com') ||
        host.contains('wmsofts.com') ||
        host.contains('api.sugudeni.com') ||
        host.contains('sugudeni.netlify.app');

    // Check if we just came from payment provider to website (success scenario)
    if ((_wasOnStripeCheckout || _wasOnOrangeMoneyCheckout) &&
        isWebsiteUrl &&
        !isOrangeMoneyCallback) {
      global.customPrint(
          'Redirected from payment provider to website - checking for success indicators');

      // Check for explicit failure indicators first
      final failurePatterns = [
        'cancel',
        'cancelled',
        'error',
        'failed',
        'failure',
        'payment-failed',
        'checkout/cancel',
        'payment/cancel',
        'payment-error',
        'declined',
      ];

      final hasFailureIndicator = failurePatterns.any((pattern) =>
          urlLower.contains(pattern) ||
          path.contains(pattern) ||
          uri.queryParameters.values
              .any((value) => value.toLowerCase().contains(pattern)));

      if (hasFailureIndicator) {
        global.customPrint('Failure indicator found on website redirect');
        _handlePaymentFailure('Payment was cancelled or failed');
        return;
      }

      // If no failure indicators, and we came from payment provider to website,
      // this is likely a successful payment redirect
      global.customPrint(
          'No failure indicators - treating website redirect as success');
      _handlePaymentSuccess();
      return;
    }

    // Special handling: If Orange Money redirects to callback URL, treat as success
    // (unless explicit failure indicators are found)
    if (isOrangeMoney && isOrangeMoneyCallback && !_paymentCompleted) {
      // Check for failure indicators in the callback
      final failurePatterns = [
        'cancel',
        'cancelled',
        'error',
        'failed',
        'failure',
        'declined',
      ];

      final hasFailureIndicator = failurePatterns.any((pattern) =>
          urlLower.contains(pattern) ||
          path.contains(pattern) ||
          uri.queryParameters.keys
              .any((key) => key.toLowerCase().contains(pattern)) ||
          uri.queryParameters.values
              .any((value) => value.toLowerCase().contains(pattern)));

      if (hasFailureIndicator) {
        global.customPrint('Orange Money callback has failure indicators');
        _handlePaymentFailure('Payment was cancelled or failed');
        return;
      }

      // If we reach the callback URL without failure indicators, it's likely a success
      // Wait a moment for page content to load, then check
      global.customPrint(
          'Orange Money callback reached - will check page content for confirmation');
      // The page content check will handle this in onPageFinished
    }

    // Check for success indicators - only after redirect from payment provider
    final successPatterns = [
      'success',
      'successful',
      'payment-success',
      'checkout/success',
      'payment/success',
      'order/success',
      'complete',
      'completed',
      'paid',
      'payment-complete',
      'succeeded',
      'payment-succeeded',
      'thank-you',
      'thankyou',
      'order-confirmed',
      'payment-confirmed',
      'transaction-successful',
    ];

    // Additional check: If URL contains your website domain and has success indicators, treat as success
    if (isWebsiteUrl && !_wasOnStripeCheckout && !_wasOnOrangeMoneyCheckout) {
      // Skip if it's Orange Money callback - handled separately
      if (isOrangeMoneyCallback) {
        return;
      }
      // Only check if we haven't already processed the redirect from payment provider
      // Check if it's a success page on your website
      if (path.contains('success') ||
          path.contains('paid') ||
          path.contains('complete') ||
          path.contains('thank') ||
          path.contains('confirm')) {
        global.customPrint('Success detected: Website URL with success path');
        _handlePaymentSuccess(); // Fire and forget - async operation
        return;
      }
    }

    // Orange Money callback URL handling - if we reach here and it's the callback, check page content
    if (isOrangeMoney && isOrangeMoneyCallback && !_paymentCompleted) {
      // Don't treat callback URL as success immediately - wait for page content check
      // This prevents false positives
      global.customPrint(
          'Orange Money callback URL detected - waiting for page content analysis');
      return;
    }

    // Check for failure/cancel indicators
    final failurePatterns = [
      'cancel',
      'cancelled',
      'error',
      'failed',
      'failure',
      'payment-failed',
      'checkout/cancel',
      'payment/cancel',
      'payment-error',
      'declined',
      // Stripe specific
      if (isStripe) ...[
        'checkout.session.async_payment_failed',
        'payment_intent.payment_failed',
        'stripe.com/cancel',
      ],
      // Orange Money specific
      if (isOrangeMoney) ...[
        'orangemoney.com/cancel',
        'orangemoney.com/error',
        'transaction/failed',
      ],
    ];

    // Check URL path and query parameters
    final queryParams = uri.queryParameters;

    // Only check for success if we're NOT on the payment provider's checkout page
    bool isSuccess = false;
    if (!isStripeCheckoutPage && !isOrangeMoneyCheckoutPage) {
      isSuccess = successPatterns.any((pattern) =>
          urlLower.contains(pattern) ||
          path.contains(pattern) ||
          queryParams.values
              .any((value) => value.toLowerCase().contains(pattern)));
    }

    bool isFailure = failurePatterns.any((pattern) =>
        urlLower.contains(pattern) ||
        path.contains(pattern) ||
        queryParams.values
            .any((value) => value.toLowerCase().contains(pattern)));

    // Check query parameters for explicit success/failure
    // Only check if we're NOT on the payment provider's checkout page
    if (!isStripeCheckoutPage && !isOrangeMoneyCheckoutPage) {
      if (queryParams.containsKey('status')) {
        final status = queryParams['status']?.toLowerCase() ?? '';
        global.customPrint('Status parameter found: $status');
        if (status == 'success' ||
            status == 'succeeded' ||
            status == 'paid' ||
            status == 'completed') {
          isSuccess = true;
        } else if (status == 'failed' ||
            status == 'cancelled' ||
            status == 'error') {
          isFailure = true;
        }
      }

      if (queryParams.containsKey('payment_status')) {
        final paymentStatus =
            queryParams['payment_status']?.toLowerCase() ?? '';
        global.customPrint('Payment status parameter found: $paymentStatus');
        if (paymentStatus == 'succeeded' ||
            paymentStatus == 'paid' ||
            paymentStatus == 'completed') {
          isSuccess = true;
        } else if (paymentStatus == 'failed' || paymentStatus == 'canceled') {
          isFailure = true;
        }
      }

      // Check for other common success parameters
      if (queryParams.containsKey('result')) {
        final result = queryParams['result']?.toLowerCase() ?? '';
        if (result == 'success' || result == 'succeeded' || result == 'paid') {
          isSuccess = true;
        }
      }

      if (queryParams.containsKey('payment_result')) {
        final paymentResult =
            queryParams['payment_result']?.toLowerCase() ?? '';
        if (paymentResult == 'success' ||
            paymentResult == 'succeeded' ||
            paymentResult == 'paid') {
          isSuccess = true;
        }
      }

      // If redirecting to website after Stripe payment, check for success indicators
      if (isStripe && isWebsiteUrl) {
        // If we're on the website after Stripe, and URL has any success indicator, treat as success
        if (successPatterns.any((pattern) => urlLower.contains(pattern))) {
          global.customPrint(
              'Success detected: Website redirect after Stripe payment');
          isSuccess = true;
        }
      }
    }

    global.customPrint(
        'URL Analysis - isSuccess: $isSuccess, isFailure: $isFailure');

    if (isSuccess) {
      global.customPrint('Triggering payment success handler');
      _handlePaymentSuccess();
    } else if (isFailure) {
      global.customPrint('Triggering payment failure handler');
      _handlePaymentFailure('Payment was cancelled or failed');
    }
  }

  Future<void> _handlePaymentSuccess() async {
    if (_paymentCompleted) return;

    global.customPrint('Payment success handler called');

    // Mark as completed first
    _paymentCompleted = true;

    if (!mounted) return;

    setState(() {
      _paymentCompleted = true;
    });

    // Store order details and clear cart resources BEFORE navigation
    if (mounted) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      // Store order details before clearing
      cartProvider.storeOrderDetails();
      await cartProvider.clearCartAndRefresh(context);
    }

    // Show success message BEFORE closing WebView
    if (mounted) {
      try {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: const Text('Payment completed successfully!'),
              duration: const Duration(seconds: 2),
              backgroundColor: greenColor,
              clipBehavior: Clip.hardEdge,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        global.customPrint('Error showing success snackbar: $e');
      }
    }

    // Close WebView and navigate after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      try {
        // Close WebView if possible
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // Navigate to success page
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          try {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesNames.customerPayAtYourAddressView,
              (route) =>
                  route.settings.name == RoutesNames.customerBottomNav ||
                  route.settings.name ==
                      RoutesNames.customerPayAtYourAddressView,
            );
          } catch (e) {
            global.customPrint('Error navigating to success page: $e');
          }
        });
      } catch (e) {
        global.customPrint('Error closing WebView: $e');
      }
    });
  }

  void _handlePaymentFailure(String errorMessage) {
    if (_paymentCompleted) return;

    _paymentCompleted = true;

    if (!mounted) return;

    setState(() {
      _paymentCompleted = true;
    });

    // Show error message BEFORE navigation
    if (mounted) {
      try {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 2),
              backgroundColor: redColor,
              clipBehavior: Clip.hardEdge,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        global.customPrint('Error showing failure snackbar: $e');
      }
    }

    // Navigate back after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      try {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        global.customPrint('Error popping navigator: $e');
      }
    });
  }

  void _handlePaymentError(String errorMessage) {
    if (_paymentCompleted || !mounted) return;

    _handlePaymentFailure('Payment error: $errorMessage');
  }

  Future<bool> _onWillPop() async {
    if (_paymentCompleted) {
      return true;
    }

    // Show confirmation dialog if payment is in progress
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Payment?'),
        content: const Text('Are you sure you want to cancel this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: blackColor),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: MyText(
            text: 'Payment',
            size: 14.sp,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: WebViewWidget(controller: _controller),
            ),
            if (_isLoading && !_paymentCompleted)
              Container(
                color: whiteColor.withOpacity(0.8),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
