import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SoleServiceDisplay extends StatelessWidget {
  final BluetoothService service;
  final Map<Guid, List<int>> readValues;

  const SoleServiceDisplay({super.key, required this.service, required this.readValues});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/empreinte.png',
              fit: BoxFit.scaleDown,
            ),
          ),
          // Points overlay
          Positioned(
            top: 225,
            left: 115,
            child: buildPoint(readValues, service.characteristics[0].uuid, '1'),
          ),
          Positioned(
            top: 320,
            left: 115,
            child: buildPoint(readValues, service.characteristics[1].uuid, '2'),
          ),
          Positioned(
            top: 535,
            left: 90,
            child: buildPoint(readValues, service.characteristics[2].uuid, '3'),
          ),
          Positioned(
            top: 580,
            left: 60,
            child: buildPoint(readValues, service.characteristics[3].uuid, '4'),
          ),
          Positioned(
            top: 520,
            left: 25,
            child: buildPoint(readValues, service.characteristics[4].uuid, '5'),
          ),
          Positioned(
            top: 450,
            left: 30,
            child: buildPoint(readValues, service.characteristics[5].uuid, '6'),
          ),
          Positioned(
            top: 350,
            left: 20,
            child: buildPoint(readValues, service.characteristics[6].uuid, '7'),
          ),
          Positioned(
            top: 255,
            left: 15,
            child: buildPoint(readValues, service.characteristics[7].uuid, '8'),
          ),
          const Positioned(
            top: 650,
            left: 250,
            child: Text(
              'Sole not connected.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPoint(Map<Guid, List<int>> readValues, Guid uuid, String label) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
            readValues[uuid]?.toString() ?? 'N/A',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
