import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/report/domain/entities/temperature_report.dart';

class TemperatureChart extends StatelessWidget {
  const TemperatureChart({super.key, required this.records});

  final List<TemperatureReport> records;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    final spots = _buildSpots();
    final temps = records.map((r) => r.temperatureC).toList();
    final minY = (temps.reduce((a, b) => a < b ? a : b) - 5).floorToDouble();
    final maxY = (temps.reduce((a, b) => a > b ? a : b) + 5).ceilToDouble();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Biểu đồ nhiệt độ',
            style: AppTextStyles.titleMediumAppBar().copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 12.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 24.w, height: 3.h, color: AppColors.primary2),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 250.h,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _yInterval(minY, maxY),
                  verticalInterval: _xInterval(),
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Colors.grey, strokeWidth: 0.8),
                  getDrawingVerticalLine: (_) =>
                      FlLine(color: Colors.grey, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: AppColors.textPrimary, width: 0.8),
                    bottom: BorderSide(
                      color: AppColors.textPrimary,
                      width: 0.8,
                    ),
                    top: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 25.w,
                      interval: _yInterval(minY, maxY),
                      getTitlesWidget: (val, _) => Text(
                        val.toInt().toString(),
                        style: AppTextStyles.titleSmall2(color: Colors.black),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20.h,
                      interval: _xInterval(),
                      getTitlesWidget: (val, _) {
                        final t = records.first.timestamp.add(
                          Duration(minutes: val.toInt()),
                        );
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            DateFormat('HH:mm').format(t),
                            style: AppTextStyles.titleSmall(
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                // Đường dữ liệu
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.primary2,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary2.withValues(alpha: 0.08),
                    ),
                  ),
                ],
                // Hold khi chạm vào đường dữ liệu
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) =>
                        AppColors.primary2.withValues(alpha: 0.85),
                    getTooltipItems: (spots) => spots.map((s) {
                      final t = records.first.timestamp.add(
                        Duration(minutes: s.x.toInt()),
                      );
                      return LineTooltipItem(
                        '${DateFormat('HH:mm').format(t)}\n${s.y.toStringAsFixed(1)} °C',
                        TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Chuyển danh sách records sang FlSpot (X = phút từ đầu, Y = nhiệt độ)
  List<FlSpot> _buildSpots() {
    final origin = records.first.timestamp;
    return records.map((r) {
      final x = r.timestamp.difference(origin).inMinutes.toDouble();
      return FlSpot(x, r.temperatureC);
    }).toList();
  }

  /// Khoảng cách nhãn trục Y
  double _yInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 15) return 5;
    if (range <= 30) return 10;
    return 15;
  }

  /// Khoảng cách nhãn trục X (phút), tối đa 5 nhãn
  double _xInterval() {
    if (records.length <= 1) return 60;
    final origin = records.first.timestamp;
    final totalMinutes = records.last.timestamp
        .difference(origin)
        .inMinutes
        .toDouble();
    final interval = (totalMinutes / 4).ceilToDouble();
    return interval < 1 ? 1 : interval;
  }
}
