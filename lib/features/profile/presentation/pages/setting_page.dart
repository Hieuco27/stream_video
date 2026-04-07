import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/l10n/app_localizations.dart';
import 'package:stream_video/features/profile/presentation/bloc/settings/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final headerGradient = isDark
        ? AppGradients.darkHeader
        : AppGradients.primaryButton;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: headerGradient),
        ),
        centerTitle: true,
        title: Text(
          l10n.settings,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: AppColors.textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              // ── Section: Giao diện ──────────────────────────────────────
              //_buildSectionLabel(l10n.themeSection, textColor),
              SizedBox(height: 8.h),
              _buildThemeCard(context, state, l10n, cardColor, textColor),
            ],
          );
        },
      ),
    );
  }

  // ─── Section label ──────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label, Color textColor) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary1,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // ─── Theme Card ─────────────────────────────────────────────────────────────
  Widget _buildThemeCard(
    BuildContext context,
    SettingsState state,
    AppLocalizations l10n,
    Color cardColor,
    Color textColor,
  ) {
    final isDark = state.themeMode == ThemeMode.dark;

    return Row(
      children: [
        Icon(
          isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
          color: isDark ? Colors.amber : AppColors.primary1,
          size: 24.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            l10n.darkMode,
            style: TextStyle(
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          alignment: Alignment.centerRight,
          child: Switch(
            value: isDark,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF3A3A3A),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.primary1,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            onChanged: (value) {
              context.read<SettingsBloc>().add(
                ChangeThemeEvent(value ? ThemeMode.dark : ThemeMode.light),
              );
            },
          ),
        ),
      ],
    );
  }
}
