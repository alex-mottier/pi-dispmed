import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'device_screen.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  ScanningScreenState createState() => ScanningScreenState();
}

class ScanningScreenState extends State<ScanningScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  void startScan() {
    setState(() {
      isScanning = true;
    });
    flutterBlue.startScan(timeout: const Duration(seconds: 4)).then((results) {
      setState(() {
        scanResults = results;
        isScanning = false;
      });
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceScreen(device: device,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isScanning ? null : startScan,
            child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final result = scanResults[index];
                return ListTile(
                  title: Text(result.device.name.isEmpty ? 'Unknown Device' : result.device.name),
                  subtitle: Text(result.device.id.toString()),
                  onTap: () => connectToDevice(result.device),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
