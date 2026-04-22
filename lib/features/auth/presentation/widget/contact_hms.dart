import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHMS extends StatelessWidget {
  const ContactHMS({super.key});
  static Future<void> launchZalo() async {
    const zaloAppUrl = 'zalo://qr/p/221017559928962481';
    const zaloWebUrl = 'https://zalo.me/221017559928962481';

    final appUri = Uri.parse(zaloAppUrl);
    final webUri = Uri.parse(zaloWebUrl);

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> launchWebsite() async {
    const url = 'https://gps.rovigps.vn/';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> launchFacebook() async {
    const facebookAppUrl = 'fb://page/61550990070865';
    const facebookWebUrl =
        'https://www.facebook.com/p/ROVI-GPS-61550990070865/';
    final appUri = Uri.parse(facebookAppUrl);
    final webUri = Uri.parse(facebookWebUrl);
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum HotlineMode { call, sms }

class Hotline extends StatelessWidget {
  const Hotline({super.key, this.mode = HotlineMode.call});

  final HotlineMode mode;

  static const _hotline1 = '0825448558';
  static const _hotline2 = '0899858565';

  static Future<void> _launchPhone(String number, {bool isSms = false}) async {
    final uri = Uri.parse('${isSms ? 'sms' : 'tel'}:$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isSms = mode == HotlineMode.sms;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _HotlineRow(
              label: 'Hotline 1:',
              number: '0825 448 558',
              isSms: isSms,
              onTap: () => _launchPhone(_hotline1, isSms: isSms),
            ),

            Divider(height: 1, indent: 50.w, color: Colors.grey[100]),

            _HotlineRow(
              label: 'Hotline 2:',
              number: '0899 858 565',
              isSms: isSms,
              onTap: () => _launchPhone(_hotline2, isSms: isSms),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

class _HotlineRow extends StatelessWidget {
  const _HotlineRow({
    required this.label,
    required this.number,
    required this.isSms,
    required this.onTap,
  });

  final String label;
  final String number;
  final bool isSms;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = isSms
        ? Icons.chat_bubble_outline_rounded
        : Icons.phone_rounded;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gradientStart, size: 22.sp),
            SizedBox(width: 18.w),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.labelLarge().copyWith(
                      color: AppColors.backgroundColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    number,
                    style: AppTextStyles.labelLarge().copyWith(
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
