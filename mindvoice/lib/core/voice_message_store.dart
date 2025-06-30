import 'package:flutter/foundation.dart';
import 'voice_message_model.dart';

class VoiceMessageStore extends ChangeNotifier {
  static final VoiceMessageStore _instance = VoiceMessageStore._internal();
  factory VoiceMessageStore() => _instance;
  VoiceMessageStore._internal();

  final List<VoiceMessage> _messages = [];

  List<VoiceMessage> get messages => List.unmodifiable(_messages);

  void addMessage(VoiceMessage message) {
    _messages.insert(0, message); // newest first
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }
} 