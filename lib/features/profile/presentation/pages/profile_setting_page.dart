import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_event.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_state.dart';
import 'package:stream_video/core/app_colors.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [_buildHeader(), _buildMenuItems(context)]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 50.h,
        bottom: 30.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: const BoxDecoration(gradient: AppGradients.primaryButton),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Khung Logo
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(8.w),
            child: Center(
              // Hiện tại dùng icon tạm, nếu có logo asset thì thay bằng Image.asset
              child: Icon(
                Icons.directions_car,
                color: Colors.redAccent,
                size: 36.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Thông tin Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '50H12712',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () {
                    // TODO: Xử lý xem thông tin chi tiết
                  },
                  child: Row(
                    children: [
                      Text(
                        'Thông tin của tôi',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.9),
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

  Widget _buildMenuItems(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildItem(
            icon: Icons.lock_outline,
            iconColor: Colors.purple.shade300,
            title: 'Đổi mật khẩu',
            onTap: () {
              // TODO: Xử lý đổi mật khẩu
            },
          ),
          _buildDivider(),
          _buildItem(
            icon: Icons.settings_outlined,
            iconColor: Colors.grey.shade700,
            title: 'Cài đặt',
            onTap: () {
              // TODO: Xử lý cài đặt (đổi theme, ngôn ngữ)
            },
          ),
          _buildDivider(),
          _buildItem(
            icon: Icons.logout,
            iconColor: Colors.blue.shade400,
            title: 'Đăng xuất',
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
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black54,
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Icon(icon, color: iconColor, size: 26.sp),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.shade400,
        size: 16.sp,
      ),
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
