import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/features/map/domain/entities/route_history_point.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_bloc.dart';
import 'package:stream_video/features/review/presentation/bloc/playback_state.dart';

class RouteLogSheet extends StatefulWidget {
  const RouteLogSheet({super.key});

  @override
  State<RouteLogSheet> createState() => _RouteLogSheetState();
}

class _RouteLogSheetState extends State<RouteLogSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackBloc, PlaybackState>(
      builder: (context, state) {
        final allPoints = state.history;

        // Lọc theo query tìm kiếm
        final filtered = _query.isEmpty
            ? allPoints
            : allPoints.where((p) {
                final address = (p.address ?? '').toLowerCase();
                final time = _formatTimestamp(p.timestamp).toLowerCase();
                return address.contains(_query) || time.contains(_query);
              }).toList();

        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            child: Column(
              children: [
                // Header
                _buildHeader(context, state),
                // Search bar
                _buildSearchBar(),
                const Divider(height: 1),
                // List
                Expanded(
                  child: state.status == PlaybackStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                      ? Center(
                          child: Text(
                            'Không có dữ liệu cho lộ trình ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final point = filtered[index];
                            final isCurrentPoint = state.currentPoint == point;
                            return _RouteLogItem(
                              point: point,
                              isActive: isCurrentPoint,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PlaybackState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              'Lộ trình',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/list.png',
              width: 24.w,
              height: 25.h,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40.h,
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 10.h),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm lộ trình',
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 18.sp,
          ),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                    size: 16.sp,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onChanged: (val) => setState(() => _query = val.toLowerCase()),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$h:$m:$s $d-$mo-${dt.year}';
  }
}

// Item row
class _RouteLogItem extends StatelessWidget {
  const _RouteLogItem({required this.point, required this.isActive});

  final RouteHistoryPoint point;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final isStopped = point.speedGPS == 0;

    final borderColor = isStopped
        ? const Color.fromARGB(255, 255, 17, 0)
        : Colors.blue;

    return Container(
      height: 40.h,
      color: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Đường kẻ dọc bên trái
            Container(width: 4, color: borderColor),
            SizedBox(width: 12.w),
            // Timestamp
            Expanded(
              flex: 5,
              child: Text(
                _formatTimestamp(point.timestamp),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // Tốc độ
            SizedBox(
              width: 68.w,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: point.speedGPS.toInt().toString(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'Km/h',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Quãng đường
            SizedBox(
              width: 48.w,
              child: Text(
                '${point.cumulativeKm.toStringAsFixed(1)} Km',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
              ),
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$h:$m:$s $d-$mo-${dt.year}';
  }
}
