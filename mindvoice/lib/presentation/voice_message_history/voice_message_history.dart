import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/date_section_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/voice_message_card_widget.dart';

class VoiceMessageHistory extends StatefulWidget {
  const VoiceMessageHistory({super.key});

  @override
  State<VoiceMessageHistory> createState() => _VoiceMessageHistoryState();
}

class _VoiceMessageHistoryState extends State<VoiceMessageHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  String? _expandedMessageId;
  String? _playingMessageId;

  // Mock data for voice messages
  final List<Map<String, dynamic>> _voiceMessages = [
    {
      "id": "msg_001",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "duration": "2:34",
      "mentalStateScore": 7.2,
      "waveformData": [0.2, 0.5, 0.8, 0.3, 0.6, 0.9, 0.4, 0.7, 0.1, 0.8],
      "transcription":
          "I had a really productive day at work today. The presentation went well and my team was very supportive. I feel confident about the upcoming project deadlines.",
      "analysis":
          "Positive emotional state detected with high confidence levels. Indicators of professional satisfaction and team collaboration.",
      "advice":
          "Continue building on this positive momentum. Consider documenting what made today successful to replicate these conditions.",
      "tags": ["work", "confidence", "teamwork"],
      "isImportant": false,
      "audioUrl": "https://example.com/audio1.mp3"
    },
    {
      "id": "msg_002",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "duration": "1:47",
      "mentalStateScore": 4.8,
      "waveformData": [0.3, 0.2, 0.4, 0.6, 0.3, 0.5, 0.2, 0.4, 0.3, 0.5],
      "transcription":
          "Feeling a bit overwhelmed with all the tasks I need to complete. The deadline is approaching and I'm not sure if I can finish everything on time.",
      "analysis":
          "Mild stress indicators present. Voice patterns suggest anxiety about time management and workload.",
      "advice":
          "Try breaking down large tasks into smaller, manageable steps. Consider using time-blocking techniques to organize your schedule.",
      "tags": ["stress", "deadline", "overwhelmed"],
      "isImportant": true,
      "audioUrl": "https://example.com/audio2.mp3"
    },
    {
      "id": "msg_003",
      "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      "duration": "3:12",
      "mentalStateScore": 8.5,
      "waveformData": [0.7, 0.9, 0.6, 0.8, 0.5, 0.9, 0.7, 0.8, 0.6, 0.9],
      "transcription":
          "Had an amazing weekend with family. We went hiking and spent quality time together. I feel refreshed and ready for the week ahead.",
      "analysis":
          "Excellent emotional state with strong positive indicators. Family time and outdoor activities showing beneficial effects.",
      "advice":
          "Maintain this balance between work and personal life. Regular outdoor activities and family time are clearly beneficial for your wellbeing.",
      "tags": ["family", "hiking", "refreshed", "weekend"],
      "isImportant": false,
      "audioUrl": "https://example.com/audio3.mp3"
    },
    {
      "id": "msg_004",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "duration": "2:15",
      "mentalStateScore": 6.1,
      "waveformData": [0.4, 0.6, 0.5, 0.7, 0.4, 0.6, 0.5, 0.6, 0.4, 0.7],
      "transcription":
          "Meeting with the client went okay, but I feel like I could have prepared better. Need to work on my presentation skills.",
      "analysis":
          "Moderate confidence levels with self-reflective tendencies. Shows growth mindset and willingness to improve.",
      "advice":
          "Self-reflection is a strength. Consider joining a public speaking group or practicing presentations with colleagues.",
      "tags": ["client", "presentation", "improvement"],
      "isImportant": false,
      "audioUrl": "https://example.com/audio4.mp3"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMessages {
    if (_searchQuery.isEmpty) return _voiceMessages;

    return _voiceMessages.where((message) {
      final transcription = (message['transcription'] as String).toLowerCase();
      final tags = (message['tags'] as List).join(' ').toLowerCase();
      final query = _searchQuery.toLowerCase();

      return transcription.contains(query) || tags.contains(query);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedMessages {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();

    for (final message in _filteredMessages) {
      final timestamp = message['timestamp'] as DateTime;
      final difference = now.difference(timestamp).inDays;

      String groupKey;
      if (difference == 0) {
        groupKey = 'Today';
      } else if (difference == 1) {
        groupKey = 'Yesterday';
      } else if (difference <= 7) {
        groupKey = 'This Week';
      } else {
        groupKey = 'Earlier';
      }

      grouped.putIfAbsent(groupKey, () => []);
      grouped[groupKey]!.add(message);
    }

    return grouped;
  }

  Color _getScoreColor(double score) {
    if (score >= 7.0) return AppTheme.getSuccessColor(true);
    if (score >= 5.0) return AppTheme.getWarningColor(true);
    return AppTheme.lightTheme.colorScheme.error;
  }

  void _toggleExpanded(String messageId) {
    setState(() {
      _expandedMessageId = _expandedMessageId == messageId ? null : messageId;
    });
  }

  void _togglePlayback(String messageId) {
    setState(() {
      _playingMessageId = _playingMessageId == messageId ? null : messageId;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Edit Tags'),
              onTap: () {
                Navigator.pop(context);
                // Handle edit tags
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'alarm',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Set Reminder'),
              onTap: () {
                Navigator.pop(context);
                // Handle set reminder
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'star',
                color: AppTheme.getWarningColor(true),
                size: 24,
              ),
              title: Text(message['isImportant']
                  ? 'Remove Important'
                  : 'Mark Important'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  message['isImportant'] = !message['isImportant'];
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMessage(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text(
            'Are you sure you want to delete this voice message? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _voiceMessages.removeWhere((msg) => msg['id'] == messageId);
              });
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMessages() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // In real app, sync with ESP32C3 device
    setState(() {
      // Refresh logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with date range selector and search
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _isSearching
                            ? TextField(
                                controller: _searchController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'Search messages...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              )
                            : Text(
                                'Voice Messages',
                                style:
                                    AppTheme.lightTheme.textTheme.headlineSmall,
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                              _searchQuery = '';
                            }
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: _isSearching ? 'close' : 'search',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'History'),
                      Tab(text: 'Insights'),
                      Tab(text: 'Advice'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // History Tab
                  _buildHistoryTab(),

                  // Insights Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'insights',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Mental Health Insights',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/mental-health-insights');
                          },
                          child: const Text('View Detailed Insights'),
                        ),
                      ],
                    ),
                  ),

                  // Advice Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AI Generated Advice',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/ai-generated-advice');
                          },
                          child: const Text('View All Advice'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Trigger manual recording
          HapticFeedback.mediumImpact();
        },
        child: CustomIconWidget(
          iconName: 'mic',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_filteredMessages.isEmpty) {
      return const EmptyStateWidget();
    }

    return RefreshIndicator(
      onRefresh: _refreshMessages,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _groupedMessages.length,
        itemBuilder: (context, index) {
          final groupKey = _groupedMessages.keys.elementAt(index);
          final messages = _groupedMessages[groupKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSectionHeaderWidget(title: groupKey),
              const SizedBox(height: 8),
              ...messages.map((message) => Column(
                    children: [
                      VoiceMessageCardWidget(
                        message: message,
                        isExpanded: _expandedMessageId == message['id'],
                        isPlaying: _playingMessageId == message['id'],
                        onTap: () => _toggleExpanded(message['id']),
                        onPlayTap: () => _togglePlayback(message['id']),
                        onLongPress: () => _showContextMenu(context, message),
                        onDelete: () => _deleteMessage(message['id']),
                        scoreColor: _getScoreColor(message['mentalStateScore']),
                      ),
                      const SizedBox(height: 12),
                    ],
                  )),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}