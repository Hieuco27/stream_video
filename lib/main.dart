import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit/media_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stream_video/firebase_options.dart';
import 'package:stream_video/core/app_router.dart';
import 'package:stream_video/core/service_locator.dart';
import 'package:stream_video/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthBloc(
                signInUseCase: sl.signInUseCase,
                signOutUseCase: sl.signOutUseCase,
                resetPasswordUseCase: sl.resetPasswordUseCase,
                getCurrentUserUseCase: sl.getCurrentUserUseCase,
                rememberMeUseCase: sl.rememberMeUseCase,
              ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Camera App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
          ),
        );
      },
    );
  }
}
