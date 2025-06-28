import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class KeyMetricsCardWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const KeyMetricsCardWidget({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Metrics',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    title: 'Average Mood',
                    value:
                        (metrics["averageMood"] as double).toStringAsFixed(1),
                    icon: 'mood',
                    color: AppTheme.lightTheme.primaryColor,
                    progress: (metrics["averageMood"] as double) / 10,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    title: 'Improvement',
                    value:
                        '+${(metrics["improvementPercentage"] as double).toStringAsFixed(1)}%',
                    icon: 'trending_up',
                    color: AppTheme.getSuccessColor(true),
                    progress:
                        (metrics["improvementPercentage"] as double) / 100,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildMetricItem(
              title: 'Consistency Score',
              value:
                  '${(metrics["consistencyScore"] as double).toStringAsFixed(1)}%',
              icon: 'timeline',
              color: AppTheme.getAccentColor(true),
              progress: (metrics["consistencyScore"] as double) / 100,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required String icon,
    required Color color,
    required double progress,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 20,
                ),
              ),
              if (isFullWidth) ...[
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (!isFullWidth) ...[
            SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
