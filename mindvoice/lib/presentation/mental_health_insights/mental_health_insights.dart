import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/advice_effectiveness_widget.dart';
import './widgets/category_breakdown_widget.dart';
import './widgets/key_metrics_card_widget.dart';
import './widgets/mood_trend_chart_widget.dart';
import './widgets/pattern_recognition_widget.dart';
import './widgets/weekly_summary_widget.dart';

class MentalHealthInsights extends StatefulWidget {
  const MentalHealthInsights({super.key});

  @override
  State<MentalHealthInsights> createState() => _MentalHealthInsightsState();
}

class _MentalHealthInsightsState extends State<MentalHealthInsights>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0; // 0: Week, 1: Month, 2: 3 Months
  final List<String> _periods = ['Week', 'Month', '3 Months'];

  // Mock data for insights
  final List<Map<String, dynamic>> _moodTrendData = [
    {"date": "Mon", "score": 7.2, "timestamp": "2024-01-15"},
    {"date": "Tue", "score": 6.8, "timestamp": "2024-01-16"},
    {"date": "Wed", "score": 8.1, "timestamp": "2024-01-17"},
    {"date": "Thu", "score": 7.5, "timestamp": "2024-01-18"},
    {"date": "Fri", "score": 8.3, "timestamp": "2024-01-19"},
    {"date": "Sat", "score": 7.9, "timestamp": "2024-01-20"},
    {"date": "Sun", "score": 8.5, "timestamp": "2024-01-21"},
  ];

  final Map<String, dynamic> _keyMetrics = {
    "averageMood": 7.6,
    "improvementPercentage": 12.5,
    "consistencyScore": 85.2,
  };

  final List<Map<String, dynamic>> _aiInsights = [
    {
      "insight": "Your mood tends to improve after morning recordings",
      "supportingData": "78% higher scores between 8-10 AM",
      "confidence": 0.89,
    },
    {
      "insight": "Weekend recordings show more positive emotional patterns",
      "supportingData": "Average weekend score: 8.2 vs weekday: 7.4",
      "confidence": 0.76,
    },
  ];

  final Map<String, dynamic> _weeklySummary = {
    "bestDay": {
      "day": "Sunday",
      "score": 8.5,
      "factors": ["Good sleep", "Exercise"]
    },
    "worstDay": {
      "day": "Tuesday",
      "score": 6.8,
      "factors": ["Work stress", "Poor sleep"]
    },
  };

  final List<Map<String, dynamic>> _adviceEffectiveness = [
    {"advice": "Morning meditation", "effectiveness": 85, "userReported": true},
    {"advice": "Evening journaling", "effectiveness": 72, "userReported": true},
    {"advice": "Regular exercise", "effectiveness": 91, "userReported": false},
    {"advice": "Sleep schedule", "effectiveness": 68, "userReported": true},
  ];

  final Map<String, dynamic> _categoryBreakdown = {
    "positive": 45.2,
    "neutral": 32.1,
    "anxious": 12.7,
    "sad": 10.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPlaceholderTab('Voice Messages'),
                _buildInsightsTab(),
                _buildPlaceholderTab('AI Advice'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportData,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'file_download',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'Export',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        'Mental Health Insights',
        style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: _tabController.index == 0
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Messages'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'insights',
                  color: _tabController.index == 1
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Insights'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'psychology',
                  color: _tabController.index == 2
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('AI Advice'),
              ],
            ),
          ),
        ],
        labelColor: AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.primaryColor,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/voice-message-history');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/ai-generated-advice');
          }
        },
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        '$title Screen',
        style: AppTheme.lightTheme.textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildInsightsTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimePeriodSelector(),
            SizedBox(height: 24),
            MoodTrendChartWidget(
              data: _moodTrendData,
              selectedPeriod: _periods[_selectedPeriod],
            ),
            SizedBox(height: 24),
            KeyMetricsCardWidget(metrics: _keyMetrics),
            SizedBox(height: 24),
            PatternRecognitionWidget(insights: _aiInsights),
            SizedBox(height: 24),
            WeeklySummaryWidget(summary: _weeklySummary),
            SizedBox(height: 24),
            AdviceEffectivenessWidget(data: _adviceEffectiveness),
            SizedBox(height: 24),
            CategoryBreakdownWidget(data: _categoryBreakdown),
            SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: _periods.asMap().entries.map((entry) {
          int index = entry.key;
          String period = entry.value;
          bool isSelected = _selectedPeriod == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = index;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    // Simulate data refresh
    setState(() {
      // Update data here
    });
  }

  void _exportData() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
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
            SizedBox(height: 24),
            Text(
              'Export Data',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Export as PDF Report'),
              subtitle: Text('Comprehensive insights report'),
              onTap: () {
                Navigator.pop(context);
                // Implement PDF export
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.getSuccessColor(true),
                size: 24,
              ),
              title: Text('Export as CSV Data'),
              subtitle: Text('Raw data for analysis'),
              onTap: () {
                Navigator.pop(context);
                // Implement CSV export
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
