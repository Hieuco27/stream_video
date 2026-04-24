import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

class VehicleDetailPage extends StatelessWidget {
  final VehicleEntity vehicle;

  const VehicleDetailPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textColor,
      appBar: AppBar(
        backgroundColor: AppColors.gradientStart,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Thông tin chi tiết',
          style: AppTextStyles.titleMediumAppBar(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Thông tin',
              rows: [
                _InfoRow(
                  icon: Icons.credit_card,
                  label: 'Biển số',
                  value: vehicle.plate,
                ),
                _InfoRow(icon: Icons.tag, label: 'Số hiệu', value: vehicle.id),
                _InfoRow(icon: Icons.sim_card, label: 'IMEI', value: '--'),
                _InfoRow(icon: Icons.devices, label: 'Loại TB', value: '--'),
                _InfoRow(
                  icon: Icons.directions_car,
                  label: 'Loại xe',
                  value: vehicle.type,
                ),
                _InfoRow(
                  icon: Icons.compare_arrows,
                  label: 'Số VIN',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.account_balance,
                  label: 'Sở giao thông',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Lái xe',
                  value: vehicle.name.isNotEmpty ? vehicle.name : '--',
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'SĐT lái xe',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Giấy phép LX',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.wifi_calling_3_outlined,
                  label: 'SIM IMEI',
                  value: '--',
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildSection(
              title: 'Trạng thái',
              rows: [
                _InfoRow(
                  icon: Icons.map_outlined,
                  label: 'Địa chỉ',
                  value: vehicle.location,
                ),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Toạ độ',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.access_time,
                  label: 'Cập nhật',
                  value: vehicle.lastUpdate,
                ),
                _InfoRow(
                  icon: Icons.speed,
                  label: 'Vận tốc',
                  value: vehicle.speed,
                ),
                _InfoRow(
                  icon: Icons.power,
                  label: 'GPS',
                  value: vehicle.engine,
                ),
                _InfoRow(
                  icon: Icons.battery_full,
                  label: 'GSM/LTE',
                  value: vehicle.battery,
                ),

                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Điện áp',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Thẻ nhớ',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Động cơ',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Điều hòa',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Mức nhiên liệu ',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Cửa xe ',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Nhiệt độ ',
                  value: vehicle.signal,
                ),
                _InfoRow(
                  icon: Icons.signal_cellular_alt,
                  label: 'Nhiên liệu ',
                  value: vehicle.signal,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildSection(
              title: 'Thống kê ',
              rows: [
                _InfoRow(
                  icon: Icons.map_outlined,
                  label: 'SL dừng đỗ',
                  value: vehicle.parkingDuration,
                ),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'SL mở cửa',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.access_time,
                  label: 'SL quá tốc độ',
                  value: vehicle.stopDuration,
                ),
                _InfoRow(
                  icon: Icons.speed,
                  label: 'TG lái xe liên tục ',
                  value: vehicle.continuousDrivingTime,
                ),
                _InfoRow(
                  icon: Icons.power,
                  label: 'TG lái xe trong ngày',
                  value: vehicle.drivingTimeToday,
                ),
                _InfoRow(
                  icon: Icons.battery_full,
                  label: 'Km trong ngày',
                  value: vehicle.kmToday,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<_InfoRow> rows}) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(title, style: AppTextStyles.titleMediumBlack()),
          ),
          ...rows.expand(
            (row) => [
              row,
              const Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.gradientStart),
          SizedBox(width: 10.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: AppTextStyles.bodyLarge()),
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.labelLarge(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
