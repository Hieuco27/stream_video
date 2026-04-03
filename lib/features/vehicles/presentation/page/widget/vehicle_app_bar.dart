import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/app_colors.dart';

class VehicleAppBar extends StatelessWidget {
  const VehicleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),

              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.textPrimary,
                      size: 20.sp,
                    ),
                  ),

                  // Title
                  Expanded(
                    child: Text(
                      'Danh sách xe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Filter icon button
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.textPrimary,
                        size: 20.sp,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 14.w),
                          Icon(
                            Icons.search,
                            color: AppColors.textPrimary,
                            size: 22.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Tìm kiếm xe',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.view_list_rounded,
                        color: AppColors.textPrimary,
                        size: 20.sp,
                      ),
                      onPressed: () {},
                    ),
                  ),

                  SizedBox(width: 6.w),

                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.textPrimary,
                        size: 20.sp,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
