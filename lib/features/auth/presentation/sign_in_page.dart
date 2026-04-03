import 'package:flutter/material.dart';
import 'package:stream_video/core/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_event.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_state.dart';
import 'package:stream_video/features/auth/presentation/widget/custom_text_field.dart';
import 'package:stream_video/features/auth/presentation/widget/validator.dart';
import 'package:stream_video/features/auth/presentation/widget/bottom_action_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video/core/text_styles.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusRequested());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go('/');
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                // Background gradient
                const _BackgroundWidget(),
                // Content
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 40.h),
                            // Logo
                            Image.asset(
                              'assets/images/logo2.png',
                              height: 120.h,
                            ),
                            SizedBox(height: 16.h),
                            // Title
                            SizedBox(height: 20.h),
                            // Email
                            CustomTextField(
                              controller: _emailController,
                              hintText: 'Tài khoản',
                              prefixIcon: Icons.person,
                              validator: AuthValidators.validateEmail,
                            ),
                            SizedBox(height: 16.h),

                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Mật khẩu',
                              prefixIcon: Icons.lock,
                              obscureText: _obscurePassword,
                              validator: AuthValidators.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.gradientStart,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Remember me + Forgot password row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Remember me
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24.w,
                                      height: 24.h,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppColors.gradientStart,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Ghi nhớ đăng nhập',
                                      style: AppTextStyles.titleSmall2(),
                                    ),
                                  ],
                                ),
                                // Forgot password
                                GestureDetector(
                                  onTap: () {
                                    // TODO: handle forgot password
                                  },
                                  child: Text(
                                    'Quên mật khẩu?',
                                    style: AppTextStyles.titleSmall2(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            // Sign In button
                            SizedBox(
                              width: double.infinity,
                              height: 40.h,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          context.read<AuthBloc>().add(
                                            AuthSignInRequested(
                                              email: _emailController.text
                                                  .trim(),
                                              password:
                                                  _passwordController.text,
                                              rememberMe: _rememberMe,
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gradientStart,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 3,
                                ),
                                child: Text(
                                  'ĐĂNG NHẬP',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Bạn chưa có tài khoản? ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // TODO: navigate to sign up
                                  },
                                  child: Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.gradientStart,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom action buttons
                if (!isKeyboardOpen) const BottomActionBar(),

                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Background with gradient overlay
class _BackgroundWidget extends StatelessWidget {
  const _BackgroundWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.05,
            child: Image.asset('assets/images/logo3.png', fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
