class VoiceMessage {
  final String filePath;
  final DateTime timestamp;
  String? transcription;
  String? analysis;
  String? advice;

  VoiceMessage({
    required this.filePath,
    required this.timestamp,
    this.transcription,
    this.analysis,
    this.advice,
  });
} 