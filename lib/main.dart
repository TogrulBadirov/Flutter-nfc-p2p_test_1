import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC P2P App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _nfcData = "Waiting for NFC";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC P2P App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _nfcData,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNFC,
              child: Text('Start NFC'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startNFC() async {
    try {
      // Start NFC session
      NFCTag tag = await FlutterNfcKit.poll();
      if (tag.ndefAvailable ?? false) {
        // Read NFC tag
        var ndef = await FlutterNfcKit.readNDEFRecords();
        setState(() {
          _nfcData = ndef.map((r) => r.payload).join(', ');
        });
      }

      // Send a message using NFC
      await FlutterNfcKit.transceive("Hello from Flutter!");

    } catch (e) {
      setState(() {
        _nfcData = 'Error: $e';
      });
    } finally {
      // Close NFC session
      await FlutterNfcKit.finish();
    }
  }
}
