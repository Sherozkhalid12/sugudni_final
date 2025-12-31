import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sugudeni/view/customer/products/scan/scanned-product-detail.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanned = false;
  String scannedCode = '';
  // Removed dummyProduct - QR code will fetch real product from API

  late MobileScannerController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(Barcode barcode) {
    if (!_isScanned && barcode.rawValue != null) {
      setState(() {
        _isScanned = true;
        scannedCode = barcode.rawValue!;
      });
      // Navigate to ProductDetailsScreen with dummy data

      // Show dummy product for any scanned QR code
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('Product Found'),
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text('Product Name: ${dummyProduct['name']}'),
      //         Text('Price: \$${dummyProduct['price']}'),
      //       ],
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           setState(() {
      //             _isScanned = false;
      //             scannedCode = '';
      //           });
      //           Navigator.of(context).pop();
      //         },
      //         child: const Text('Scan Again'),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product QR Code'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                _onDetect(barcode);
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
