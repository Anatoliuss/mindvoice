import 'package:flutter/material.dart';
import '../presentation/voice_message_history/voice_message_history.dart';
import '../presentation/mental_health_insights/mental_health_insights.dart';
import '../presentation/ai_generated_advice/ai_generated_advice.dart';

class AppRoutes {
  static const String initial = '/';
  static const String voiceMessageHistory = '/voice-message-history';
  static const String mentalHealthInsights = '/mental-health-insights';
  static const String aiGeneratedAdvice = '/ai-generated-advice';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const VoiceMessageHistory(),
    voiceMessageHistory: (context) => const VoiceMessageHistory(),
    mentalHealthInsights: (context) => const MentalHealthInsights(),
    aiGeneratedAdvice: (context) => const AiGeneratedAdvice(),
  };
}
