import 'package:flutter/material.dart';
import '../presentation/voice_message_history/voice_message_history.dart';
import '../presentation/ai_generated_advice/ai_generated_advice.dart';
import '../presentation/ble/ble_device_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String voiceMessageHistory = '/voice-message-history';
  static const String aiGeneratedAdvice = '/ai-generated-advice';
  static const String bleDevice = '/ble-device';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const VoiceMessageHistory(),
    voiceMessageHistory: (context) => const VoiceMessageHistory(),
    aiGeneratedAdvice: (context) => const AiGeneratedAdvice(),
    bleDevice: (context) => const BleDeviceScreen(),
  };
}
