import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './audio_player_widget.dart';
import './waveform_widget.dart';

class VoiceMessageCardWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isExpanded;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onPlayTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final Color scoreColor;

  const VoiceMessageCardWidget({
    super.key,
    required this.message,
    required this.isExpanded,
    required this.isPlaying,
    required this.onTap,
    required this.onPlayTap,
    required this.onLongPress,
    required this.onDelete,
    required this.scoreColor,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(message['id']),
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.getSuccessColor(true),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            const Text(
              'Share',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
          return false;
        } else {
          // Handle share action
          HapticFeedback.lightImpact();
          return false;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onLongPress();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: isExpanded ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: isExpanded
                ? Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header row
                    Row(
                      children: [
                        // Play button
                        GestureDetector(
                          onTap: onPlayTap,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: isPlaying ? 'pause' : 'play_arrow',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Waveform and duration
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WaveformWidget(
                                waveformData:
                                    List<double>.from(message['waveformData']),
                                isPlaying: isPlaying,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message['duration'],
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),

                        // Mental state score
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${message['mentalStateScore'].toStringAsFixed(1)}',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: scoreColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Important indicator
                        if (message['isImportant']) ...[
                          const SizedBox(width: 8),
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.getWarningColor(true),
                            size: 16,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Timestamp and tags
                    Row(
                      children: [
                        Text(
                          _formatTimestamp(message['timestamp']),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        ...((message['tags'] as List)
                            .take(2)
                            .map((tag) => Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                    ),
                                  ),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),

              // Expanded content
              if (isExpanded) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Audio player
                      if (isPlaying)
                        AudioPlayerWidget(
                          audioUrl: message['audioUrl'],
                          onPlaybackComplete: onPlayTap,
                        ),

                      const SizedBox(height: 16),

                      // Transcription
                      Text(
                        'Transcription',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message['transcription'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 16),

                      // Analysis
                      Text(
                        'Mental State Analysis',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message['analysis'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 16),

                      // Advice
                      Text(
                        'Generated Advice',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.getSuccessColor(true)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['advice'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
