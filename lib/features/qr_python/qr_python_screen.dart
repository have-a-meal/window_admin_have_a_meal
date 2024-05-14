import 'package:flutter/material.dart';

class QrPythonScreen extends StatefulWidget {
  const QrPythonScreen({super.key});

  @override
  State<QrPythonScreen> createState() => _QrPythonScreenState();
}

class _QrPythonScreenState extends State<QrPythonScreen> {
  final bool _isQRView = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () async {},
            icon: const Icon(Icons.qr_code_2),
            label: const Text("QR 스캐너 실행"),
          ),
        ],
      ),
    );
  }
}
