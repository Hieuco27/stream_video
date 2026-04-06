import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/widget/search_BKS.dart';

/// Thanh bộ lọc: Chọn BKS + Chọn Kênh + Nút Xem
class FilterBar extends StatefulWidget {
  final String selectedKenh;
  final List<String> listKenh;
  final ValueChanged<String> onKenhChanged;
  final VoidCallback onPlay;
  final String? initialBks;
  final ValueChanged<String?>? onBksChanged;

  const FilterBar({
    super.key,
    required this.selectedKenh,
    required this.listKenh,
    required this.onKenhChanged,
    required this.onPlay,
    this.initialBks,
    this.onBksChanged,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? _selectedBks;

  @override
  void initState() {
    super.initState();
    _selectedBks = widget.initialBks;
  }

  Future<void> _openBksSearch() async {
    final result = await showSearchBKS(context, initialSelected: _selectedBks);
    if (result != null) {
      setState(() => _selectedBks = result);
      widget.onBksChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // ── Nút chọn BKS ──
          Expanded(
            flex: 35,
            child: GestureDetector(
              onTap: _openBksSearch,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                              text: _selectedBks ?? 'Chọn xe',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                                color: _selectedBks != null
                                    ? Colors.black
                                    : Colors.black45,
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

          // ── Nút chọn Kênh ─────────────────────────────────────────────────
          Expanded(
            flex: 35,
            child: PopupMenuButton<String>(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              offset: Offset(0, 45.h),
              onSelected: widget.onKenhChanged,
              itemBuilder: (BuildContext context) => widget.listKenh.map((
                String kh,
              ) {
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
                              text: widget.selectedKenh,
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

          // ── Nút Xem ───────────────────────────────────────────────────────
          Expanded(
            flex: 20,
            child: SizedBox(
              height: 30.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gradientStart,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                onPressed: widget.onPlay,
                child: Text('Xem', style: TextStyle(fontSize: 12.sp)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
