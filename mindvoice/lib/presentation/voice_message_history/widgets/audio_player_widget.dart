import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final VoidCallback onPlaybackComplete;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.onPlaybackComplete,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  double _playbackSpeed = 1.0;
  bool _isPlaying = true;
  Duration _currentPosition = Duration.zero;
  final Duration _totalDuration = const Duration(minutes: 2, seconds: 34);

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: _totalDuration,
      vsync: this,
    );

    _progressController.addListener(() {
      setState(() {
        _currentPosition = Duration(
          milliseconds:
              (_progressController.value * _totalDuration.inMilliseconds)
                  .round(),
        );
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onPlaybackComplete();
      }
    });

    // Start playback
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _progressController.forward();
    } else {
      _progressController.stop();
    }

    HapticFeedback.lightImpact();
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 0.5;
      } else {
        _playbackSpeed = 1.0;
      }
    });

    // Update animation speed
    _progressController.duration = Duration(
      milliseconds: (_totalDuration.inMilliseconds / _playbackSpeed).round(),
    );

    HapticFeedback.selectionClick();
  }

  void _seekTo(double value) {
    _progressController.value = value;
    HapticFeedback.selectionClick();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Progress bar
          Row(
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: _progressController.value,
                  onChanged: _seekTo,
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Speed control
              GestureDetector(
                onTap: _changeSpeed,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Rewind 15s
              IconButton(
                onPressed: () {
                  final newValue =
                      (_progressController.value - 0.1).clamp(0.0, 1.0);
                  _seekTo(newValue);
                },
                icon: CustomIconWidget(
                  iconName: 'replay_10',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),

              // Play/Pause
              GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ),

              // Forward 15s
              IconButton(
                onPressed: () {
                  final newValue =
                      (_progressController.value + 0.1).clamp(0.0, 1.0);
                  _seekTo(newValue);
                },
                icon: CustomIconWidget(
                  iconName: 'forward_10',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),

              // More options
              IconButton(
                onPressed: () {
                  // Show more options
                },
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
