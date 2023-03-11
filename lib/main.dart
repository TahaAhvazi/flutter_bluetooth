import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Bluetooth Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> _scanResults = [];
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    super.dispose();
    _stopScan();
  }

  void _startScan() {
    _scanSubscription = _flutterBlue.scan().listen((scanResult) {
      setState(() {
        _scanResults.add(scanResult);
      });
    });
  }

  void _stopScan() {
    _scanSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          ScanResult result = _scanResults[index];
          return ListTile(
            title: Text(result.device.name),
            subtitle: Text(result.device.id.toString()),
            trailing: Text('${result.device.id} dBm'),
          );
        },
      ),
    );
  }
}
