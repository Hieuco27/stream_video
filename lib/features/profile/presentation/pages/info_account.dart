import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/auth/domain/entities/user_entity.dart';
import 'package:stream_video/core/text_styles.dart';

class InfoAccountPage extends StatelessWidget {
  final UserEntity user;
  const InfoAccountPage({super.key, required this.user});

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
          'Thông tin tài khoản',
          style: AppTextStyles.titleMediumAppBar(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              rows: [
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Tên đăng nhập',
                  value: user.email,
                ),
                _InfoRow(
                  icon: Icons.account_circle_outlined,
                  label: 'Tên tài khoản',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Số điện thoại',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user.email,
                ),
                _InfoRow(
                  icon: Icons.description_outlined,
                  label: 'Mô tả',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.manage_accounts_outlined,
                  label: 'Loại tài khoản',
                  value: '--',
                ),
                _InfoRow(
                  icon: Icons.devices_outlined,
                  label: 'Số lượng thiết bị',
                  value: '--',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required List<_InfoRow> rows}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...rows.expand(
            (row) => [
              row,
              const Divider(
                height: 1,
                thickness: 0.8,
                indent: 14,
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
          Icon(icon, size: 16.sp, color: AppColors.gradientStart),
          SizedBox(width: 10.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: AppTextStyles.labelLarge()),
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
