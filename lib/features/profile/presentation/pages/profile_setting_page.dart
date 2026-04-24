import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_event.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_state.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildHeader(context, isDark),
            _buildMenuItems(context, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final gradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 50.h,
        bottom: 30.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(gradient: gradient),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Image.asset(
                'assets/images/logo2.png',
                width: 80.w,
                height: 80.w,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('50H12712', style: AppTextStyles.titleMediumAppBar()),
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () {
                    final state = context.read<AuthBloc>().state;
                    if (state is AuthAuthenticated) {
                      context.push('/info-account', extra: state.user);
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Thông tin của tôi',
                        style: AppTextStyles.labelLarge(color: Colors.white),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 12.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, Color textColor) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildItem(
            icon: Icons.lock_outline,
            iconColor: Colors.purple.shade300,
            title: 'Đổi mật khẩu',
            textColor: textColor,
            onTap: () {
              context.push('/change-password');
            },
          ),
          _buildDivider(),
          _buildItem(
            icon: Icons.settings_outlined,
            iconColor: Colors.grey.shade600,
            title: 'Cài đặt',
            textColor: textColor,
            onTap: () {
              context.push('/settings');
            },
          ),
          _buildDivider(),
          _buildItem(
            icon: Icons.logout,
            iconColor: Colors.blue.shade400,
            title: 'Đăng xuất',
            textColor: textColor,
            onTap: () {
              _confirmSignout(context);
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  void _confirmSignout(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tiêu đề
              Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),

              // Nội dung
              Text(
                'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.backgroundColor,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              // 2 nút
              Row(
                children: [
                  // Nút Hủy
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: AppColors.darkTextSecondary),
                      ),
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Nút Đăng xuất
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        authBloc.add(AuthSignOutRequested());
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      leading: Icon(icon, color: iconColor, size: 26.sp),
      title: Text(title, style: AppTextStyles.labelLarge()),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 14.sp),
      onTap: onTap,
    );
  }

  // Dòng kẻ ngăn cách mờ
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1,
      thickness: 1,
      indent: 60.w, // Thụt lùi text để không đè lên avatar
    );
  }
}
