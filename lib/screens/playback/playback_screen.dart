import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../widget/filter_video_section.dart';
import '../widget/date_time_picker_widget.dart';
import '../../core/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaybackScreen extends StatelessWidget {
  final bool isActive;

  const PlaybackScreen({super.key, this.isActive = true});

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
        title: Text(
          'Xem lại',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
