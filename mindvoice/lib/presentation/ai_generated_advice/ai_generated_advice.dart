import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/advice_card_widget.dart';
import './widgets/advice_filter_chip_widget.dart';
import './widgets/primary_advice_card_widget.dart';

class AiGeneratedAdvice extends StatefulWidget {
  const AiGeneratedAdvice({super.key});

  @override
  State<AiGeneratedAdvice> createState() => _AiGeneratedAdviceState();
}

class _AiGeneratedAdviceState extends State<AiGeneratedAdvice>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _filteredAdvice = [];

  final List<String> _filterCategories = [
    'All',
    'Breathing',
    'Exercise',
    'Mindfulness',
    'Sleep',
    'Nutrition'
  ];

  final List<Map<String, dynamic>> _mockAdviceData = [
    {
      "id": 1,
      "category": "Breathing",
      "title": "4-7-8 Breathing Technique",
      "description":
          "Practice the 4-7-8 breathing pattern to reduce anxiety and promote relaxation. Inhale for 4 counts, hold for 7, exhale for 8.",
      "detailedDescription":
          "This ancient breathing technique activates your parasympathetic nervous system, helping to calm your mind and body. Start by sitting comfortably with your back straight. Place the tip of your tongue against the ridge behind your upper teeth. Exhale completely through your mouth, making a whoosh sound. Close your mouth and inhale quietly through your nose for 4 counts. Hold your breath for 7 counts. Exhale completely through your mouth for 8 counts, making the whoosh sound again. Repeat this cycle 3-4 times.",
      "difficulty": "Easy",
      "timeCommitment": "5 minutes",
      "isPrimary": true,
      "isHelpful": null,
      "hasReminder": false,
      "progress": 0.0,
      "icon": "air",
      "estimatedBenefit": "Reduces anxiety by 40% within 2 minutes"
    },
    {
      "id": 2,
      "category": "Exercise",
      "title": "Morning Gentle Stretching",
      "description":
          "Start your day with 10 minutes of gentle stretching to improve mood and energy levels.",
      "detailedDescription":
          "Morning stretches help release tension accumulated during sleep and prepare your body for the day ahead. Focus on neck rolls, shoulder shrugs, gentle spinal twists, and light leg stretches. This routine increases blood flow, reduces stiffness, and releases endorphins that naturally boost your mood.",
      "difficulty": "Easy",
      "timeCommitment": "10 minutes",
      "isPrimary": false,
      "isHelpful": true,
      "hasReminder": true,
      "progress": 0.6,
      "icon": "fitness_center",
      "estimatedBenefit": "Improves energy levels by 25%"
    },
    {
      "id": 3,
      "category": "Mindfulness",
      "title": "5-Minute Gratitude Practice",
      "description":
          "Write down three things you're grateful for each morning to shift focus toward positive aspects of life.",
      "detailedDescription":
          "Gratitude practice rewires your brain to notice positive experiences more readily. Each morning, write down three specific things you're grateful for, no matter how small. Include why you're grateful for each item and how it makes you feel. This practice strengthens neural pathways associated with positive emotions and reduces symptoms of depression.",
      "difficulty": "Easy",
      "timeCommitment": "5 minutes",
      "isPrimary": false,
      "isHelpful": null,
      "hasReminder": false,
      "progress": 0.0,
      "icon": "favorite",
      "estimatedBenefit": "Increases happiness by 30%"
    },
    {
      "id": 4,
      "category": "Sleep",
      "title": "Digital Sunset Routine",
      "description":
          "Create a technology-free hour before bedtime to improve sleep quality and reduce mental stimulation.",
      "detailedDescription":
          "Blue light from screens interferes with melatonin production, making it harder to fall asleep. Establish a 'digital sunset' by turning off all screens one hour before your intended bedtime. Use this time for relaxing activities like reading, gentle stretching, journaling, or meditation. Keep your bedroom cool, dark, and quiet for optimal sleep conditions.",
      "difficulty": "Medium",
      "timeCommitment": "60 minutes",
      "isPrimary": false,
      "isHelpful": false,
      "hasReminder": true,
      "progress": 0.3,
      "icon": "bedtime",
      "estimatedBenefit": "Improves sleep quality by 45%"
    },
    {
      "id": 5,
      "category": "Nutrition",
      "title": "Mindful Eating Practice",
      "description":
          "Eat one meal per day without distractions, focusing on taste, texture, and satisfaction signals.",
      "detailedDescription":
          "Mindful eating helps you develop a healthier relationship with food and can reduce stress-related eating patterns. Choose one meal each day to eat without phones, TV, or other distractions. Chew slowly, notice flavors and textures, and pay attention to hunger and fullness cues. This practice can improve digestion and help you make more conscious food choices.",
      "difficulty": "Medium",
      "timeCommitment": "20 minutes",
      "isPrimary": false,
      "isHelpful": null,
      "hasReminder": false,
      "progress": 0.0,
      "icon": "restaurant",
      "estimatedBenefit": "Reduces stress eating by 35%"
    }
  ];

  @override
  void initState() {
    super.initState();
    _filteredAdvice = List.from(_mockAdviceData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAdvice() {
    setState(() {
      _filteredAdvice = _mockAdviceData.where((advice) {
        final matchesCategory = _selectedFilter == 'All' ||
            (advice['category'] as String) == _selectedFilter;
        final matchesSearch = _searchController.text.isEmpty ||
            (advice['title'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (advice['description'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  Future<void> _refreshAdvice() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New advice generated based on recent analysis'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _markAsHelpful(int adviceId, bool isHelpful) {
    setState(() {
      final index =
          _mockAdviceData.indexWhere((advice) => advice['id'] == adviceId);
      if (index != -1) {
        _mockAdviceData[index]['isHelpful'] = isHelpful;
      }
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isHelpful ? 'Marked as helpful' : 'Feedback recorded'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _setReminder(int adviceId) {
    setState(() {
      final index =
          _mockAdviceData.indexWhere((advice) => advice['id'] == adviceId);
      if (index != -1) {
        _mockAdviceData[index]['hasReminder'] =
            !(_mockAdviceData[index]['hasReminder'] as bool);
      }
    });

    HapticFeedback.mediumImpact();

    final hasReminder = _mockAdviceData.firstWhere(
        (advice) => advice['id'] == adviceId)['hasReminder'] as bool;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(hasReminder ? 'Reminder set' : 'Reminder removed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareWithTherapist(Map<String, dynamic> advice) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Share with Therapist',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Share "${advice['title']}" recommendation with your mental health professional?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Shared with therapist'),
                        ),
                      );
                    },
                    child: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryAdvice =
        _filteredAdvice.where((advice) => advice['isPrimary'] == true).toList();
    final secondaryAdvice =
        _filteredAdvice.where((advice) => advice['isPrimary'] != true).toList();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'AI-Generated Advice',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isRefreshing ? null : _refreshAdvice,
            icon: _isRefreshing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAdvice,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Header with date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Generated on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _filterAdvice(),
                decoration: InputDecoration(
                  hintText: 'Search advice...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _filterAdvice();
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              ),
            ),

            // Filter chips
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filterCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _filterCategories[index];
                  return AdviceFilterChipWidget(
                    label: category,
                    isSelected: _selectedFilter == category,
                    onTap: () {
                      setState(() {
                        _selectedFilter = category;
                      });
                      _filterAdvice();
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _filteredAdvice.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Primary advice card
                        if (primaryAdvice.isNotEmpty) ...[
                          PrimaryAdviceCardWidget(
                            advice: primaryAdvice.first,
                            onMarkHelpful: _markAsHelpful,
                            onSetReminder: _setReminder,
                            onShareWithTherapist: _shareWithTherapist,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Secondary advice cards
                        ...secondaryAdvice.map((advice) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AdviceCardWidget(
                                advice: advice,
                                onMarkHelpful: _markAsHelpful,
                                onSetReminder: _setReminder,
                                onShareWithTherapist: _shareWithTherapist,
                              ),
                            )),

                        const SizedBox(height: 100), // Bottom padding for FAB
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refreshAdvice,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'psychology',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: const Text('New Advice'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'insights',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'insights',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'Advice',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/voice-message-history');
              break;
            case 1:
              Navigator.pushNamed(context, '/mental-health-insights');
              break;
            case 2:
              // Already on advice screen
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'psychology_alt',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              'No Advice Available',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Record more voice messages to get personalized mental health advice based on your patterns.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/voice-message-history'),
              icon: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
