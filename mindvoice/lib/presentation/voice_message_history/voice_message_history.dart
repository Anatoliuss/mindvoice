import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/app_export.dart';
import './widgets/date_section_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/voice_message_card_widget.dart';
import '../../core/openai_service.dart';

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
  bool _isTranscribing = false;
  int? _transcribingIndex;
  bool _isSummarizing = false;
  int? _summarizingIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

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
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _refreshMessages() async {
    // For MVP, just refresh UI
    setState(() {});
  }

  Future<void> _playPause(int index, String filePath) async {
    if (_playingIndex == index && _audioPlayer.playing) {
      await _audioPlayer.pause();
      setState(() {});
      return;
    }
    try {
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
      setState(() {
        _playingIndex = index;
      });
      _audioPlayer.positionStream.listen((pos) {
        setState(() {
          _position = pos;
        });
      });
      _audioPlayer.durationStream.listen((dur) {
        setState(() {
          _duration = dur ?? Duration.zero;
        });
      });
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _playingIndex = null;
            _position = Duration.zero;
          });
        }
      });
    } catch (e) {
      print('Audio playback error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = VoiceMessageStore().messages;
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bluetooth),
                label: const Text('Connect to ESP32 Device'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.bleDevice);
                },
              ),
            ),
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
          // Trigger manual recording (future feature)
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
    final messages = VoiceMessageStore().messages;
    final filtered = _isSearching && _searchQuery.isNotEmpty
        ? messages.where((m) => (m.transcription ?? '').toLowerCase().contains(_searchQuery.toLowerCase())).toList()
        : messages;
    if (filtered.isEmpty) {
      return const EmptyStateWidget();
    }
    return RefreshIndicator(
      onRefresh: _refreshMessages,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final message = filtered[index];
          return Card(
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  _playingIndex == index && _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () => _playPause(index, message.filePath),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.filePath.split('/').last),
                  Text(message.timestamp.toString(), style: const TextStyle(fontSize: 12)),
                  if (message.transcription != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Transcription: ${message.transcription}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  if (message.analysis != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Summary: ${message.analysis}',
                        style: const TextStyle(fontSize: 13, color: Colors.blueAccent),
                      ),
                    ),
                  if (message.advice != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Advice: ${message.advice}',
                        style: const TextStyle(fontSize: 13, color: Colors.green),
                      ),
                    ),
                  if (_playingIndex == index && _duration > Duration.zero)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: LinearProgressIndicator(
                        value: _position.inMilliseconds / _duration.inMilliseconds,
                      ),
                    ),
                  if (_isTranscribing && _transcribingIndex == index)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: LinearProgressIndicator(),
                    ),
                  if (_isSummarizing && _summarizingIndex == index)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.text_fields),
                    tooltip: 'Transcribe',
                    onPressed: _isTranscribing
                        ? null
                        : () async {
                            setState(() {
                              _isTranscribing = true;
                              _transcribingIndex = index;
                            });
                            final transcription = await OpenAIService().transcribeAudio(message.filePath);
                            setState(() {
                              message.transcription = transcription ?? 'Transcription failed.';
                              _isTranscribing = false;
                              _transcribingIndex = null;
                            });
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.psychology),
                    tooltip: 'Summarize & Advise',
                    onPressed: (message.transcription == null || _isSummarizing)
                        ? null
                        : () async {
                            setState(() {
                              _isSummarizing = true;
                              _summarizingIndex = index;
                            });
                            final result = await OpenAIService().summarizeAndAdvise(message.transcription!);
                            setState(() {
                              message.analysis = result?['summary'] ?? 'No summary.';
                              message.advice = result?['advice'] ?? 'No advice.';
                              _isSummarizing = false;
                              _summarizingIndex = null;
                            });
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}