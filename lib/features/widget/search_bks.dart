import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/features/vehicles/data/models/vehicle_mock_data.dart';

// ─── Theme extension ───────────────────────────────────────────────────────────
extension AppThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardColor => isDark
      ? AppColors.darkSurface.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.85);

  Color get textColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get searchBg =>
      isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white;

  LinearGradient get gradient =>
      isDark ? AppGradients.darkHeader : AppGradients.primaryButton;
}

// ─── Widget chính ──────────────────────────────────────────────────────────────
class SearchBKS extends StatefulWidget {
  const SearchBKS({
    super.key,
    this.initialSelected,
    this.onConfirm,
    this.onCancel,
  });

  final String? initialSelected;

  final ValueChanged<String?>? onConfirm;
  final VoidCallback? onCancel;

  @override
  State<SearchBKS> createState() => _SearchBKSState();
}

class _SearchBKSState extends State<SearchBKS> {
  late final List<String> _allPlates;
  late List<String> _filtered;
  String? _selected;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Lấy danh sách biển số từ vehicleMockData
    _allPlates = vehicleMockData.map((v) => v.plate).toList();
    _filtered = List.from(_allPlates);
    _selected = widget.initialSelected;
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? List.from(_allPlates)
          : _allPlates.where((p) => p.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchBar(controller: _searchCtrl),
        Expanded(
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final plate = _filtered[index];
              return _PlateItem(
                plate: plate,
                isSelected: plate == _selected,
                onTap: () => setState(() => _selected = plate),
              );
            },
          ),
        ),
        _ActionBar(
          onCancel: widget.onCancel ?? () => Navigator.of(context).pop(),
          onConfirm: () => widget.onConfirm?.call(_selected),
        ),
      ],
    );
  }
}

//  Thanh tìm kiếm
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final gradient = context.gradient;

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: SizedBox(
        height: 30.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm biển số',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12.sp,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 4.w,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.white, size: 16.r),
              prefixIconConstraints: BoxConstraints(
                minWidth: 28.w,
                minHeight: 30.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide.none,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (_, value, __) => value.text.isNotEmpty
                    ? GestureDetector(
                        onTap: controller.clear,
                        child: Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 14.r,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 20.w,
                minHeight: 30.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//  Item biển số
class _PlateItem extends StatelessWidget {
  const _PlateItem({
    required this.plate,
    required this.isSelected,
    required this.onTap,
  });

  final String plate;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    plate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: context.textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check, color: AppColors.gradientEnd, size: 20.r),
              ],
            ),
          ),
          Divider(height: 0.2, thickness: 0.2, color: context.textColor),
        ],
      ),
    );
  }
}

//  Thanh hành động
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onCancel, required this.onConfirm});

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final btnStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: Size(double.infinity, 54.h),
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
    );
    final labelStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return SizedBox(
      height: 40.h,
      child: Container(
        decoration: BoxDecoration(gradient: context.gradient),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onCancel,
                style: btnStyle,
                child: Text('Trở lại', style: labelStyle),
              ),
            ),
            Container(width: 1, height: 40.h, color: Colors.white54),
            Expanded(
              child: TextButton(
                onPressed: onConfirm,
                style: btnStyle,
                child: Text('Xác nhận', style: labelStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Helper: mở dialog tìm kiếm biển số
Future<String?> showSearchBKS(BuildContext context, {String? initialSelected}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 120.h),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.55,
        child: SearchBKS(
          initialSelected: initialSelected,
          onConfirm: (plate) => Navigator.of(context).pop(plate),
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    ),
  );
}
