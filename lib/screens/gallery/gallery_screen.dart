import 'package:flutter/material.dart';
import 'package:stream_video/core/text_styles.dart';
import '../../core/app_colors.dart';
import '../widget/filter_video_section.dart';
import '../../features/widget/date_time_picker_widget.dart';
import '../../core/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryScreen extends StatelessWidget {
  final bool isActive;
  const GalleryScreen({super.key, this.isActive = true});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Thư viện ảnh', style: AppTextStyles.titleMedium()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                child: DateTimePickerWidget(),
              ),
              SizedBox(height: 10),
              FilterVideoSection(isActive: isActive),
            ],
          ),
        ),
      ),
    );
  }
}
