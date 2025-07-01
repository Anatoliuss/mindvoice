import 'package:flutter/material.dart';
import '../../core/ble_service.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../../core/app_export.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class BleDeviceScreen extends StatefulWidget {
  const BleDeviceScreen({Key? key}) : super(key: key);

  @override
  State<BleDeviceScreen> createState() => _BleDeviceScreenState();
}

class _BleDeviceScreenState extends State<BleDeviceScreen> {
  final BleService _bleService = BleService();
  BluetoothDevice? _connectingDevice;
  bool _connected = false;
  String? _error;
  int _audioPackets = 0;
  Stream<Uint8List>? _audioStream;
  StreamSubscription<Uint8List>? _audioSubscription;
  List<int> _audioBuffer = [];
  String? _savedFilePath;

  @override
  void dispose() {
    _audioSubscription?.cancel();
    _handleDisconnectAndSave();
    super.dispose();
  }

  void _startListeningForAudio() {
    final stream = _bleService.receiveAudioStream();
    if (stream != null) {
      _audioSubscription = stream.listen((data) {
        setState(() {
          _audioPackets++;
          _audioBuffer.addAll(data);
        });
        // TODO: Save/process audio data as needed
      });
    }
  }

  Future<void> _handleDisconnectAndSave() async {
    if (_audioBuffer.isNotEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now();
      final filePath = '${dir.path}/audio_${timestamp.toIso8601String().replaceAll(':', '-')}.raw';
      final file = File(filePath);
      await file.writeAsBytes(_audioBuffer);
      // Add to message store
      VoiceMessageStore().addMessage(
        VoiceMessage(filePath: filePath, timestamp: timestamp),
      );
      setState(() {
        _savedFilePath = filePath;
        _audioBuffer.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect to ESP32')),
      body: _connected
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Connected to ESP32!'),
                  const SizedBox(height: 16),
                  Text('Audio packets received: $_audioPackets'),
                ],
              ),
            )
          : StreamBuilder<List<ScanResult>>(
              stream: _bleService.scanForDevices(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final devices = snapshot.data!;
                if (devices.isEmpty) {
                  return const Center(child: Text('No BLE devices found.'));
                }
                return ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index].device;
                    return ListTile(
                      title: Text(device.name.isNotEmpty ? device.name : device.id.id),
                      subtitle: Text(device.id.id),
                      trailing: _connectingDevice == device
                          ? const CircularProgressIndicator()
                          : null,
                      onTap: _connectingDevice == null
                          ? () async {
                              setState(() {
                                _connectingDevice = device;
                                _error = null;
                              });
                              try {
                                await _bleService.connectToDevice(device);
                                setState(() {
                                  _connected = true;
                                });
                                _startListeningForAudio();
                              } catch (e) {
                                setState(() {
                                  _error = 'Failed to connect: $e';
                                  _connectingDevice = null;
                                });
                              }
                            }
                          : null,
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: _error != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : null,
    );
  }
} 