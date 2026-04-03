import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'select_popup.dart';

/// Thanh bộ lọc: Chọn BKS + Chọn Kênh + Nút Xem
/// Widget này chỉ hiển thị UI, mọi logic xử lý được truyền qua callbacks.
class FilterBar extends StatelessWidget {
  final String selectedBks;
  final String selectedKenh;
  final List<String> listBks;
  final List<String> listKenh;
  final ValueChanged<String> onBksChanged;
  final ValueChanged<String> onKenhChanged;
  final VoidCallback onPlay;

  const FilterBar({
    super.key,
    required this.selectedBks,
    required this.selectedKenh,
    required this.listBks,
    required this.listKenh,
    required this.onBksChanged,
    required this.onKenhChanged,
    required this.onPlay,
  });

  void _showBksPopup(BuildContext context) async {
    final result = await SelectPopup.show(
      context,
      items: listBks,
      initialValue: selectedBks,
    );
    if (result != null) {
      onBksChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Nút chọn BKS
          Expanded(
            flex: 35,
            child: GestureDetector(
              onTap: () => _showBksPopup(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'BKS: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextSpan(
                              text: selectedBks,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, size: 20.sp),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Nút chọn Kênh
          Expanded(
            flex: 35,
            child: PopupMenuButton<String>(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              offset: Offset(0, 45.h),
              onSelected: onKenhChanged,
              itemBuilder: (BuildContext context) => listKenh.map((String kh) {
                return PopupMenuItem<String>(
                  value: kh,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      kh,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Kênh: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            TextSpan(
                              text: selectedKenh,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, size: 20.sp),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Nút Xem
          Expanded(
            flex: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              onPressed: onPlay,
              child: Text('Xem', style: TextStyle(fontSize: 12.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
