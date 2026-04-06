import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../widget/filter_video_section.dart';
import '../../core/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/text_styles.dart';

class LiveScreen extends StatelessWidget {
  final bool isActive;

  const LiveScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primaryButton),
        ),
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
        title: Text('Xem trực tiếp', style: AppTextStyles.titleMedium()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              FilterVideoSection(isActive: isActive),
            ],
          ),
        ),
      ),
    );
  }
}
