import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    this.onPhonePressed,
    this.onChatPressed,
    this.onMenuPressed,
  });

  final VoidCallback? onPhonePressed;
  final VoidCallback? onChatPressed;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _CircleButton(
                icon: Icons.phone,
                onPressed: onPhonePressed ?? () {},
              ),
              const SizedBox(width: 12),
              _CircleButton(
                icon: Icons.chat,
                onPressed: onChatPressed ?? () {},
              ),
            ],
          ),
          _CircleButton(icon: Icons.menu, onPressed: onMenuPressed ?? () {}),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
