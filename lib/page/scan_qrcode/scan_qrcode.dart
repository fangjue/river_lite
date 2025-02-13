import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCode extends StatefulWidget {
  ScanQRCode({Key key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '扫码',
          style: TextStyle(fontSize: 16),
        ),
        elevation: 0,
        foregroundColor: os_white,
        backgroundColor: os_black,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: os_black,
      body: Center(child: QRViewExample()),
    );
  }
}

class QRViewExample extends StatefulWidget {
  QRViewExample({Key key}) : super(key: key);

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              height: 400,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
        ),
        Container(height: 30),
        Bounce(
          infinite: true,
          from: 30,
          child: Icon(
            Icons.arrow_upward,
            size: 40,
            color: os_white,
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != result?.code) {
        XSVibrate(type: FeedbackType.success);
        setState(() {
          result = scanData;
        });
        final code = result.code;
        if (code.contains(
            "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")) {
          final id = int.parse(code.split(
              "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")[1]);
          Navigator.pushNamed(context, '/topic_detail', arguments: id)
              .then((value) => setState(() {
                    result = null;
                  }));
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
