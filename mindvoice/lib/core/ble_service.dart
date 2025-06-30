import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';

class BleService {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _audioCharacteristic;

  // TODO: Replace with your ESP32's actual service and characteristic UUIDs
  static const String audioServiceUuid = '0000abcd-0000-1000-8000-00805f9b34fb';
  static const String audioCharacteristicUuid = '0000dcba-0000-1000-8000-00805f9b34fb';

  // Scan for BLE devices
  Stream<List<ScanResult>> scanForDevices() {
    _flutterBlue.startScan(timeout: const Duration(seconds: 5));
    return _flutterBlue.scanResults;
  }

  // Connect to a device by its id
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
    _connectedDevice = device;
    await _discoverServices();
  }

  // Discover services and characteristics
  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;
    List<BluetoothService> services = await _connectedDevice!.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toLowerCase() == audioServiceUuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() == audioCharacteristicUuid) {
            _audioCharacteristic = characteristic;
            break;
          }
        }
      }
    }
  }

  // Listen for audio data (as bytes)
  Stream<Uint8List>? receiveAudioStream() {
    if (_audioCharacteristic == null) return null;
    _audioCharacteristic!.setNotifyValue(true);
    return _audioCharacteristic!.value.map((list) => Uint8List.fromList(list));
  }

  // Disconnect
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _audioCharacteristic = null;
    }
  }
} 