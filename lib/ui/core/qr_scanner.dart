import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override 
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: false
  );

//avoid scanning QR-Code multiple times
bool _hasScanned = false;

void _handleBarcode(BarcodeCapture capture) {
  if (_hasScanned) return;

  final barcode = capture.barcodes.firstOrNull;
  final value = barcode?.rawValue;

  if (value == null) return;

  _hasScanned = true;

  controller.stop();
  Navigator.of(context).pop(value);
  }


@override
  void initState() {
    super.initState();
    //start listening for lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    //start listening to barcode events
    _subscription = controller.barcodes.listen(_handleBarcode);

    //start scanner
    unawaited(controller.start());
  } 

//Lifecycle Changes

  StreamSubscription<BarcodeCapture>? _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _subscription?.cancel();
        _subscription = null;
        unawaited(controller.stop());
        break;

      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
    }
  }


  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    await controller.dispose();
    super.dispose();
  }
 
 //Main Scanner
  @override
  Widget build(BuildContext context) {
   return MobileScanner(
    controller: controller,
   );
  }
}