import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:stream_video/core/app_theme.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_event.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_state.dart';
import 'package:stream_video/core/text_styles.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Inline error messages
  String? _confirmError;
  String? _samePasswordError;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onConfirmChanged(String value) {
    setState(() {
      if (value.isNotEmpty && value != _newCtrl.text) {
        _confirmError = 'Mật khẩu không khớp';
      } else {
        _confirmError = null;
      }
    });
  }

  void _onNewPasswordChanged(String value) {
    setState(() {
      if (_confirmCtrl.text.isNotEmpty && _confirmCtrl.text != value) {
        _confirmError = 'Mật khẩu không khớp';
      } else {
        _confirmError = null;
      }
      if (value.isNotEmpty && value == _oldCtrl.text) {
        _samePasswordError = 'Mật khẩu mới không được trùng mật khẩu cũ';
      } else {
        _samePasswordError = null;
      }
    });
  }

  void _submit() {
    final oldPw = _oldCtrl.text.trim();
    final newPw = _newCtrl.text.trim();
    final confirmPw = _confirmCtrl.text.trim();

    // Final validation before dispatch
    if (oldPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_confirmError != null || _samePasswordError != null) return;

    context.read<AuthBloc>().add(
      AuthChangePasswordRequested(
        oldPassword: oldPw,
        newPassword: newPw,
        confirmPassword: confirmPw,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Đổi mật khẩu thành công!'),
              backgroundColor: Colors.green.shade600,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.primaryButton,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Đổi mật khẩu',
              style: AppTextStyles.titleMediumAppBar(),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Mật khẩu cũ ──
                    _label('Mật khẩu cũ'),
                    SizedBox(height: 8.h),
                    _PasswordField(
                      controller: _oldCtrl,
                      hint: 'Nhập mật khẩu cũ',
                      obscure: _obscureOld,
                      onToggle: () =>
                          setState(() => _obscureOld = !_obscureOld),
                      onChanged: (_) {},
                    ),
                    SizedBox(height: 20.h),

                    // ── Mật khẩu mới ──
                    _label('Mật khẩu mới'),
                    SizedBox(height: 8.h),
                    _PasswordField(
                      controller: _newCtrl,
                      hint: 'Nhập mật khẩu mới',
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      onChanged: _onNewPasswordChanged,
                    ),
                    if (_samePasswordError != null) ...[
                      SizedBox(height: 6.h),
                      _ErrorText(_samePasswordError!),
                    ],
                    SizedBox(height: 20.h),

                    // ── Nhập lại mật khẩu mới ───
                    _label('Nhập lại mật khẩu mới'),
                    SizedBox(height: 8.h),
                    _PasswordField(
                      controller: _confirmCtrl,
                      hint: 'Nhập lại mật khẩu mới',
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      onChanged: _onConfirmChanged,
                    ),
                    if (_confirmError != null) ...[
                      SizedBox(height: 6.h),
                      _ErrorText(_confirmError!),
                    ],
                    SizedBox(height: 40.h),

                    // ── Nút Đổi mật khẩu ───
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gradientStart,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Đổi mật khẩu',
                                style: AppTextStyles.titleMediumAppBar(),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.titleSmall2());
}

// ─── Password TextField ───
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        style: AppTextStyles.titleSmall2().copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textPrimary,
              size: 20.r,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.textPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.textPrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.gradientStart, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// Inline error text
class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade600, size: 14.r),
        SizedBox(width: 4.w),
        Text(
          message,
          style: AppTextStyles.titleSmall2().copyWith(
            color: Colors.red.shade600,
          ),
        ),
      ],
    );
  }
}
