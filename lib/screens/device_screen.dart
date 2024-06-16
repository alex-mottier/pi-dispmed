import 'package:ble_scanner/screens/sole_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({super.key, required this.device});

  @override
  DeviceScreenState createState() => DeviceScreenState();
}

class DeviceScreenState extends State<DeviceScreen> {
  List<BluetoothService> servicesList = [];
  Map<Guid, List<int>> readValues = <Guid, List<int>>{};
  bool isDiscoveringServices = true;
  bool hasSoleService = false;

  @override
  void initState() {
    super.initState();
    discoverServices();
  }

  void discoverServices() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      setState(() {
        servicesList = services;
        isDiscoveringServices = false;
        hasSoleService = services.any((service) => service.uuid.toString() == "0000181c-0000-1000-8000-00805f9b34fb");
      });
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              setState(() {
                readValues[characteristic.uuid] = value;
              });
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        isDiscoveringServices = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.device.disconnect();
            Navigator.pop(context);
          },
        ),
      ),
      body: isDiscoveringServices
          ? const Center(child: CircularProgressIndicator())
          : hasSoleService
          
          ? SoleServiceDisplay(service: servicesList.firstWhere((service) => service.uuid.toString() == "0000181c-0000-1000-8000-00805f9b34fb"), readValues: readValues)
          : ListView(
        children: servicesList.map((service) {
          return ExpansionTile(
            title: Text('Service: ${service.uuid}'),
            children: service.characteristics.map((characteristic) {
              return ListTile(
                title: Text('Characteristic: ${characteristic.uuid}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Properties: ${characteristic.properties}'),
                    Text('Value: ${readValues[characteristic.uuid]?.toString() ?? 'N/A'}'),
                  ],
                ),
                onTap: () {
                  if (characteristic.properties.notify) {
                    characteristic.setNotifyValue(true);
                  } else {
                    readCharacteristic(characteristic);
                  }
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  void readCharacteristic(BluetoothCharacteristic characteristic) async {
    var value = await characteristic.read();
    setState(() {
      readValues[characteristic.uuid] = value;
    });
  }
}
