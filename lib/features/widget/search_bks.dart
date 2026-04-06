import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';

// ─── Mock BKS data ────────────────────────────────────────────────────────────
const List<String> mockBksPlates = [
  '38E00115',
  '38E00016',
  '38A30079',
  '38A03608',
  '38A23791',
  '38A15024',
  '38A15192',
  '38A13778',
  '51A12345',
  '51B67890',
  '43C11223',
  '30F99887',
];

class SearchBKS extends StatefulWidget {
  const SearchBKS({
    super.key,
    this.plates, // danh sách biển số
    this.initialSelected,
    this.onConfirm,
    this.onCancel,
  });

  final List<String>? plates;
  final String? initialSelected;
  final ValueChanged<String?>? onConfirm;
  final VoidCallback? onCancel;

  @override
  State<SearchBKS> createState() => _SearchBKSState();
}

class _SearchBKSState extends State<SearchBKS> {
  late List<String> _allPlates;
  late List<String> _filtered;
  String? _selected;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allPlates = widget.plates ?? mockBksPlates;
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
      mainAxisSize: MainAxisSize.max,
      children: [
        _SearchBar(controller: _searchCtrl),

        Expanded(
          child: ListView.separated(
            itemCount: _filtered.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, thickness: 0.8, color: AppColors.border),
            itemBuilder: (context, index) {
              final plate = _filtered[index];
              final isSelected = plate == _selected;
              return _PlateItem(
                plate: plate,
                isSelected: isSelected,
                onTap: () => setState(() => _selected = plate),
              );
            },
          ),
        ),

        _ActionBar(
          onCancel: () {
            if (widget.onCancel != null) {
              widget.onCancel!();
            } else {
              Navigator.of(context).pop();
            }
          },
          onConfirm: () => widget.onConfirm?.call(_selected),
        ),
      ],
    );
  }
}

// ─── Thanh tìm kiếm ───────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: SizedBox(
        height: 30.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Colors.black38, width: 1),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12.sp,
              ),
              isDense: true,
              prefixIcon: Icon(Icons.search, color: Colors.white, size: 16.r),
              prefixIconConstraints: BoxConstraints(
                minWidth: 28.w,
                minHeight: 30.h,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 4.w,
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

// ─── Item biển số ─────────────────────────────────────────────────────────────
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check, color: AppColors.gradientEnd, size: 20.r),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.8,
            color: AppColors.darkTextSecondary,
          ),
        ],
      ),
    );
  }
}

// ─── Thanh hành động ──────────────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onCancel, required this.onConfirm});
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            // Trở lại
            Expanded(
              child: TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 54.h),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  'Trở lại',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Divider dọc
            Container(width: 1, height: 30.h, color: Colors.white54),

            // Xác nhận
            Expanded(
              child: TextButton(
                onPressed: onConfirm,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 54.h),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper: mở SearchBKS dưới dạng dialog giữa màn ─────────────────────────
Future<String?> showSearchBKS(
  BuildContext context, {
  List<String>? plates,
  String? initialSelected,
}) {
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
          plates: plates,
          initialSelected: initialSelected,
          onConfirm: (plate) => Navigator.of(context).pop(plate),
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    ),
  );
}
