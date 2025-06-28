import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MoodTrendChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String selectedPeriod;

  const MoodTrendChartWidget({
    super.key,
    required this.data,
    required this.selectedPeriod,
  });

  @override
  State<MoodTrendChartWidget> createState() => _MoodTrendChartWidgetState();
}

class _MoodTrendChartWidgetState extends State<MoodTrendChartWidget> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
            padding: EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Mood Trend',
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(widget.selectedPeriod,
                        style: AppTheme.lightTheme.textTheme.labelMedium
                            ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500))),
              ]),
              SizedBox(height: 24),
              SizedBox(
                  height: 200,
                  child: LineChart(LineChartData(
                      gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                                strokeWidth: 1);
                          }),
                      titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < widget.data.length) {
                                      return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                              widget.data[value.toInt()]["date"]
                                                  as String,
                                              style: AppTheme.lightTheme
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                      color: AppTheme
                                                          .lightTheme
                                                          .colorScheme
                                                          .onSurfaceVariant)));
                                    }
                                    return Container();
                                  })),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 2,
                                  reservedSize: 40,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(value.toInt().toString(),
                                            style: AppTheme
                                                .lightTheme.textTheme.labelSmall
                                                ?.copyWith(
                                                    color: AppTheme
                                                        .lightTheme
                                                        .colorScheme
                                                        .onSurfaceVariant)));
                                  }))),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                              bottom: BorderSide(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                  width: 1),
                              left: BorderSide(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                  width: 1))),
                      minX: 0,
                      maxX: (widget.data.length - 1).toDouble(),
                      minY: 0,
                      maxY: 10,
                      lineTouchData: LineTouchData(
                          enabled: true,
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? touchResponse) {
                            setState(() {
                              if (touchResponse != null &&
                                  touchResponse.lineBarSpots != null) {
                                _touchedIndex =
                                    touchResponse.lineBarSpots!.first.spotIndex;
                              } else {
                                _touchedIndex = null;
                              }
                            });
                          },
                          touchTooltipData: LineTouchTooltipData(
                              tooltipBorder: BorderSide(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2)),
                              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  final flSpot = barSpot;
                                  if (flSpot.x.toInt() >= 0 &&
                                      flSpot.x.toInt() < widget.data.length) {
                                    final data = widget.data[flSpot.x.toInt()];
                                    return LineTooltipItem(
                                        '${data["timestamp"]}\nScore: ${flSpot.y.toStringAsFixed(1)}',
                                        AppTheme
                                            .lightTheme.textTheme.labelMedium!
                                            .copyWith(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurface));
                                  }
                                  return null;
                                }).toList();
                              })),
                      lineBarsData: [
                        LineChartBarData(
                            spots: widget.data.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(),
                                  (entry.value["score"] as double));
                            }).toList(),
                            isCurved: true,
                            gradient: LinearGradient(colors: [
                              AppTheme.lightTheme.primaryColor,
                              AppTheme.getSuccessColor(true),
                            ]),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                      radius: _touchedIndex == index ? 6 : 4,
                                      color: AppTheme.lightTheme.primaryColor,
                                      strokeWidth: 2,
                                      strokeColor: AppTheme
                                          .lightTheme.colorScheme.surface);
                                }),
                            belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                    colors: [
                                      AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.2),
                                      AppTheme.getSuccessColor(true)
                                          .withValues(alpha: 0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter))),
                      ]))),
              SizedBox(height: 16),
              Row(children: [
                CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16),
                SizedBox(width: 8),
                Expanded(
                    child: Text('Tap on data points for detailed information',
                        style: AppTheme.lightTheme.textTheme.labelSmall
                            ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant))),
              ]),
            ])));
  }
}
