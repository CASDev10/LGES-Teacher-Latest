import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/module/home/pages/home_screen.dart';
import '../../config/routes/nav_router.dart';
import '../../constants/app_colors.dart';
import '../onboarding/onboarding_screen.dart';
import 'splash_cubit.dart';

class SplashaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.whiteColor,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark,
      ),
    );
    return BlocProvider(
      create: (context) => SplashCubit()..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state == SplashState.authenticated) {
            NavRouter.pushReplacement(context, HomeScreen());
          } else if (state == SplashState.unauthenticated) {
            NavRouter.pushReplacement(context, const OnboardingScreen());
          }
        },
        child: BaseScaffold(
          hMargin: 0,
          body: SafeArea(
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/png/bg_splash.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
