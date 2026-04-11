import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';

class DateTimePickerWidget extends StatefulWidget {
  const DateTimePickerWidget({
    super.key,
    this.startDate,
    this.endDate,
    this.onStartChanged,
    this.onEndChanged,
  });

  /// Controlled mode: truyền giá trị từ ngoài.
  /// Nếu null → widget tự quản lý state nội bộ (standalone).
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime>? onStartChanged;
  final ValueChanged<DateTime>? onEndChanged;

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  final Color _textColor = AppColors.primary3;
  final Color _underlineColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.startDate ?? DateTime(now.year, now.month, now.day, 0, 0, 0);
    _endDate = widget.endDate ?? DateTime(now.year, now.month, now.day, 23, 59, 0);
  }

  @override
  void didUpdateWidget(covariant DateTimePickerWidget old) {
    super.didUpdateWidget(old);
    if (widget.startDate != null && widget.startDate != old.startDate) {
      _startDate = widget.startDate!;
    }
    if (widget.endDate != null && widget.endDate != old.endDate) {
      _endDate = widget.endDate!;
    }
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return "$y-$m-$d $h:$min:$s";
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime initialDate = isStart ? _startDate : _endDate;

    // 1. Popup chọn Ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: _textColor, // Header background color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // 2. Popup chọn Giờ
    if (!context.mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: _textColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    // Hợp nhất ngày và giờ
    final DateTime newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
      0,
    );

    setState(() {
      if (isStart) {
        _startDate = newDateTime;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate.add(const Duration(hours: 1));
        }
        widget.onStartChanged?.call(_startDate);
        widget.onEndChanged?.call(_endDate);
      } else {
        _endDate = newDateTime;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate.subtract(const Duration(hours: 1));
          widget.onStartChanged?.call(_startDate);
        }
        widget.onEndChanged?.call(_endDate);
      }
    });
  }

  Widget _buildDatePickerField(DateTime dateTime, bool isStart) {
    return SizedBox(
      height: 30.h,
      child: GestureDetector(
        onTap: () => _selectDateTime(context, isStart),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _underlineColor, width: 0.6),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDateTime(dateTime),
                style: TextStyle(
                  color: _textColor,
                  fontSize: 12.sp,
                  //fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: _textColor, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDatePickerField(_startDate, true)),
        SizedBox(width: 16.w),
        Expanded(child: _buildDatePickerField(_endDate, false)),
      ],
    );
  }
}
