import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:stream_video/features/vehicles/domain/entities/vehicle_entity.dart';

//  Column definitions
class _Col {
  const _Col(this.label, this.width, this.value);
  final String label;
  final double width;
  final String Function(VehicleEntity v) value;
}

const double _bksWidth = 130;
const double _rowHeight = 45;
const double _headerHeight = 45;

String _statusLabel(VehicleStatus s) {
  switch (s) {
    case VehicleStatus.moving:
      return 'Đang chạy';
    case VehicleStatus.stopped:
      return 'Dừng đỗ';
    case VehicleStatus.engineOff:
      return 'Tắt máy';
    case VehicleStatus.noSignal:
      return 'Mất tín hiệu';
    case VehicleStatus.noGps:
      return 'Mất GPS';
  }
}

Color _statusColor(VehicleStatus s) {
  switch (s) {
    case VehicleStatus.moving:
      return const Color(0xFF1976D2);
    case VehicleStatus.stopped:
      return const Color(0xFFE53935);
    case VehicleStatus.engineOff:
      return const Color(0xFF555555);
    case VehicleStatus.noSignal:
      return const Color(0xFFFF6B35);
    case VehicleStatus.noGps:
      return const Color(0xFFFFCC02);
  }
}

final List<_Col> _columns = [
  _Col('Tên lái xe', 130, (v) => v.name.isEmpty ? '—' : v.name),
  _Col('Ắc quy', 90, (v) => v.battery.isEmpty ? '—' : v.battery),
  _Col('Analog 1', 90, (_) => '—'),
  _Col('Analog 2', 90, (_) => '—'),
  _Col('GPLX', 100, (_) => '—'),
  _Col('Hạng xe', 100, (v) => v.type.isEmpty ? '—' : v.type),
  _Col('Hướng', 80, (_) => '—'),
  _Col('IMEI', 120, (_) => '—'),
  _Col('Tổng KM tích lũy', 140, (_) => '—'),
  _Col('Tổng KM trong ca', 140, (v) => v.kmToday.isEmpty ? '—' : v.kmToday),
  _Col(
    'Lái xe liên tục',
    130,
    (v) => v.continuousDrivingTime.isEmpty ? '—' : v.continuousDrivingTime,
  ),
  _Col(
    'Lái xe tổng ngày',
    140,
    (v) => v.drivingTimeToday.isEmpty ? '—' : v.drivingTimeToday,
  ),
  _Col(
    'Tọa độ',
    160,
    (v) =>
        '${v.latitude.toStringAsFixed(5)}, ${v.longitude.toStringAsFixed(5)}',
  ),
  _Col('Công ty', 120, (_) => '—'),
  _Col('Màu xe', 90, (_) => '—'),
  _Col('Nhiệt độ', 90, (_) => '—'),
  _Col('Số lần dừng', 110, (_) => '—'),
  _Col('Tốc độ', 80, (v) => v.speed.isEmpty ? '—' : '${v.speed} km/h'),
  _Col(
    'Thời gian dừng',
    130,
    (v) => v.stopDuration.isEmpty ? '—' : v.stopDuration,
  ),
  _Col(
    'Cập nhật lần cuối',
    150,
    (v) => v.lastUpdate.isEmpty ? '—' : v.lastUpdate,
  ),
  _Col('Trạng thái', 120, (v) => _statusLabel(v.status)),
  _Col('Địa chỉ', 200, (v) => v.lastLocation.isEmpty ? '—' : v.lastLocation),
];

//  Main Widget
class VehicleTable extends StatefulWidget {
  const VehicleTable({super.key, required this.vehicles});
  final List<VehicleEntity> vehicles;

  @override
  State<VehicleTable> createState() => _VehicleTableState();
}

class _VehicleTableState extends State<VehicleTable> {
  // Search
  final TextEditingController _searchCtrl = TextEditingController();
  List<VehicleEntity> _filtered = [];

  // Shared horizontal scroll controller
  final ScrollController _headerScrollCtrl = ScrollController();
  final List<ScrollController> _rowScrollCtrls = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.vehicles;
    _searchCtrl.addListener(_onSearch);
    _headerScrollCtrl.addListener(_syncFromHeader);
    _buildRowControllers(widget.vehicles.length);
  }

  // tìm kiếm
  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    final newFiltered = q.isEmpty
        ? widget.vehicles
        : widget.vehicles
              .where((v) => v.plate.toLowerCase().contains(q))
              .toList();

    // Rebuild controllers TRƯỚC setState để build() dùng đúng controllers
    if (_rowScrollCtrls.length != newFiltered.length) {
      _buildRowControllers(newFiltered.length);
    }

    setState(() {
      _filtered = newFiltered;
    });

    // Sau khi build xong, sync tất cả row controllers về vị trí header hiện tại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_headerScrollCtrl.hasClients) return;
      final offset = _headerScrollCtrl.offset;
      for (final c in _rowScrollCtrls) {
        if (c.hasClients && c.offset != offset) {
          c.jumpTo(offset);
        }
      }
    });
  }

  // tạo controller cho từng hàng
  void _buildRowControllers(int count) {
    for (final c in _rowScrollCtrls) {
      c.removeListener(() {});
      c.dispose();
    }
    _rowScrollCtrls.clear();
    for (int i = 0; i < count; i++) {
      final ctrl = ScrollController();
      ctrl.addListener(() => _syncFromRow(ctrl));
      _rowScrollCtrls.add(ctrl);
    }
  }

  bool _isSyncing = false;

  // Đồng bộ lên header
  void _syncFromHeader() {
    if (_isSyncing) return;
    _isSyncing = true;
    final offset = _headerScrollCtrl.offset;
    for (final c in _rowScrollCtrls) {
      if (c.hasClients && c.offset != offset) {
        c.jumpTo(offset);
      }
    }
    _isSyncing = false;
  }

  // Đồng bộ Row
  void _syncFromRow(ScrollController source) {
    if (_isSyncing) return;
    _isSyncing = true;
    final offset = source.offset;
    if (_headerScrollCtrl.hasClients && _headerScrollCtrl.offset != offset) {
      _headerScrollCtrl.jumpTo(offset);
    }
    for (final c in _rowScrollCtrls) {
      if (c != source && c.hasClients && c.offset != offset) {
        c.jumpTo(offset);
      }
    }
    _isSyncing = false;
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    _headerScrollCtrl.removeListener(_syncFromHeader);
    _headerScrollCtrl.dispose();
    for (final c in _rowScrollCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  //  Build
  @override
  Widget build(BuildContext context) {
    final headerBg = Colors.white;
    final evenRow = Colors.white;
    final oddRow = Colors.white;
    final borderColor = Colors.black;

    return Scaffold(
      backgroundColor: evenRow,
      body: Column(
        children: [
          //  App Bar
          Container(
            decoration: BoxDecoration(gradient: AppGradients.primaryButton),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        'Danh sách xe',
                        style: AppTextStyles.titleMediumAppBar(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search bar
          Container(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
              top: 12.h,
            ),
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 14.w),
                  Icon(Icons.search, color: AppColors.textPrimary, size: 22.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm xe',
                        hintStyle: AppTextStyles.titleSmall2(),
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.only(top: 2.h),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: AppTextStyles.titleSmall2(),
                    ),
                  ),
                  // if (_searchCtrl.text.isNotEmpty)
                  //   GestureDetector(
                  //     onTap: () => _searchCtrl.clear(),
                  //     child: Padding(
                  //       padding: EdgeInsets.only(right: 10.w),
                  //       child: Icon(
                  //         Icons.close,
                  //         size: 18.sp,
                  //         color: AppColors.textSecondary,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),

          // Table Header + Body (filtered)
          Expanded(
            child: Column(
              children: [
                // Header row
                Container(
                  margin: EdgeInsets.only(top: 13.h),
                  height: _headerHeight.h,
                  decoration: BoxDecoration(
                    color: headerBg,
                    border: Border(
                      top: BorderSide(color: borderColor, width: 1),
                      bottom: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      _HeaderCell(
                        label: 'BKS',
                        width: _bksWidth.w,
                        isFirst: true,
                        bg: headerBg,
                        borderColor: borderColor,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _headerScrollCtrl,
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Row(
                            children: _columns
                                .map(
                                  (col) => _HeaderCell(
                                    label: col.label,
                                    width: col.width.w,
                                    isFirst: false,
                                    bg: headerBg,
                                    borderColor: borderColor,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Data rows
                Expanded(
                  child: _filtered.isEmpty
                      ? Center(
                          child: Text(
                            'Không tìm thấy xe "${_searchCtrl.text}"',
                            style: AppTextStyles.labelMedium(),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _filtered.length,
                          itemBuilder: (_, index) {
                            if (index >= _rowScrollCtrls.length) {
                              return const SizedBox.shrink();
                            }
                            final v = _filtered[index];
                            final bg = index.isEven ? evenRow : oddRow;
                            return _TableRow(
                              vehicle: v,
                              scrollCtrl: _rowScrollCtrls[index],
                              bg: bg,
                              borderColor: borderColor,
                              index: index,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Header Cell
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.width,
    required this.isFirst,
    required this.bg,
    required this.borderColor,
  });

  final String label;
  final double width;
  final bool isFirst;
  final Color bg;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        border: Border(right: BorderSide(color: borderColor, width: 0.8)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.titleSmall3(color: Colors.black),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// Table Row
class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.vehicle,
    required this.scrollCtrl,
    required this.bg,
    required this.borderColor,
    required this.index,
  });

  final VehicleEntity vehicle;
  final ScrollController scrollCtrl;
  final Color bg;
  final Color borderColor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _rowHeight.h,
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          // Fixed BKS cell — icon + biển số
          Container(
            width: _bksWidth.w,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: borderColor, width: 0.8)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24.sp,
                  height: 24.sp,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1,
                      child: SvgPicture.asset(
                        'assets/images/map/car1.svg',
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          _statusColor(vehicle.status),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    vehicle.plate,
                    style: AppTextStyles.titleSmall3(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable data cells
          Expanded(
            child: SingleChildScrollView(
              controller: scrollCtrl,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: _columns
                    .map(
                      (col) => _DataCell(
                        text: col.value(vehicle),
                        width: col.width.w,
                        borderColor: borderColor,
                        textColor: col.label == 'Trạng thái'
                            ? _statusColor(vehicle.status)
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Data Cell
class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.text,
    required this.width,
    required this.borderColor,
    this.isBold = false,
    this.textColor,
  });

  final String text;
  final double width;
  final Color borderColor;
  final bool isBold;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : AppColors.textPrimary;

    return Container(
      width: width,
      height: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall(
          color: textColor ?? defaultColor,
        ).copyWith(fontWeight: isBold ? FontWeight.w700 : FontWeight.w400),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
