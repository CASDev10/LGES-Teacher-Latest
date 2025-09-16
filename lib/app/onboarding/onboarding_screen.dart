import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/h_padding.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/pages/login_screen.dart';
import '../../../components/custom_button.dart';
import 'widget/dot_indicators.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.whiteColor,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.dark,
    ));
    return BaseScaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) => setState(() {
                    selectedIndex = index;
                    if (index == 2) {
                      isLastPage = true;
                    } else {
                      isLastPage = false;
                    }
                  }),
                  scrollDirection: Axis.horizontal,
                  children: [
                    PageviewChild(
                      imagePath: "assets/images/svg/onboarding1.svg",
                      title: "Welcome to\nLearner",
                      subTitle:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt dolore magna aliqua',
                    ),
                    PageviewChild(
                      imagePath: "assets/images/svg/onboarding2.svg",
                      title: "Welcome to\nLearner",
                      subTitle:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt dolore magna aliqua',
                    ),
                    PageviewChild(
                      imagePath: "assets/images/svg/onboarding3.svg",
                      title: "Welcome to\nLearner",
                      subTitle:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt dolore magna aliqua',
                    ),
                  ],
                ),
              ),
              BuildDotIndicators(
                selectedIndex: selectedIndex,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                title: !isLastPage ? "Next" : "Get Started",
                height: 50,
                onPressed: () {
                  isLastPage
                      ? NavRouter.push(context, LoginScreen())
                      : pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  NavRouter.push(context, LoginScreen());
                },
                child: const TextView(
                  'Skip Now',
                  color: AppColors.darkGreyColor,
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

class PageviewChild extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;

  const PageviewChild(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: SvgPicture.asset(imagePath),
        ),
        const SizedBox(
          height: 40,
        ),
        TextView(
          title,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          fontSize: 30,
          color: AppColors.primaryDark,
        ),
        const SizedBox(
          height: 22,
        ),
        TextView(
          subTitle,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.greyColor,
        ).hPadding(),
      ],
    );
  }
}
