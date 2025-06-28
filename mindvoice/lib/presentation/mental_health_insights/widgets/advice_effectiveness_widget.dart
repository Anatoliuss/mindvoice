import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AdviceEffectivenessWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AdviceEffectivenessWidget({
    super.key,
    required this.data,
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'track_changes',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Advice Effectiveness',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = data[index];
                return _buildAdviceItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceItem(Map<String, dynamic> item) {
    final effectiveness = item["effectiveness"] as int;
    final userReported = item["userReported"] as bool;
    final advice = item["advice"] as String;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  advice,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: userReported
                      ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: userReported ? 'verified_user' : 'schedule',
                      color: userReported
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      userReported ? 'Reported' : 'Pending',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: userReported
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: effectiveness / 100,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getEffectivenessColor(effectiveness),
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                '$effectiveness%',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getEffectivenessColor(effectiveness),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEffectivenessColor(int effectiveness) {
    if (effectiveness >= 80) {
      return AppTheme.getSuccessColor(true);
    } else if (effectiveness >= 60) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
