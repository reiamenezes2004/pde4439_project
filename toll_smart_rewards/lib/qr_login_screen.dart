import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRLoginScreen extends StatefulWidget {
  const QRLoginScreen({super.key});

  @override
  State<QRLoginScreen> createState() => _QRLoginScreenState();
}

class _QRLoginScreenState extends State<QRLoginScreen> {
  bool _scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String code = barcodes.first.rawValue!;
      setState(() => _scanned = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code: $code')),
      );
      // TODO: Navigate or authenticate
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Scan QR to Login'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,
        ),
        onDetect: _onDetect,
      ),
    );
  }
}
