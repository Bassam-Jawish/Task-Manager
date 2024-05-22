import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../injection_container.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context).colorScheme;
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.7),
                child: TextButton(
                  onPressed: () {
                    state.pageController!.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: state.pageController!,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    context
                        .read<OnboardingBloc>()
                        .add(ChangeOnboardingIndicator(index));
                  },
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.03),
                      child: Column(
                        children: [
                         ClipOval(
                           child: Image.asset(contents[i].ImageURL,
                                    height: height * 0.32, fit: BoxFit.fill),
                         ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: contents.asMap().entries.map((entry) {
                              final index = entry.key;
                              return Container(
                                width: 8.0.r,
                                height: 8.0.r,
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state.current == index
                                        ? theme.primary
                                        : const Color(0xFFF5F5F5)),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: height * 0.06,
                          ),
                          Text(
                            contents[i].title,
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: theme.secondary),
                          ),
                          SizedBox(height: height * 0.04),
                          Text(
                            contents[i].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              state.current == 0
                  ? SizedBox(
                      height: height * 0.07,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          state.pageController!.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: height * 0.07,
                          width: width * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              state.pageController!.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: Styles.textStyle16
                                  .copyWith(color: theme.onPrimary),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.07,
                          width: width * 0.4,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (state.current == contents.length - 1) {
                                await SecureStorage.writeSecureData(
                                    key: 'isOnboarding', value: 'true');
                               isOnboarding = 'true';
                                GoRouter.of(context)
                                    .pushReplacement(AppRouter.kLoginPage);
                              }
                              state.pageController!.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
                              //textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontFamily: 'IBM Plex Sans',fontSize: width*0.032),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              state.current == contents.length - 1
                                  ? "Go"
                                  : "Next",
                              style: Styles.textStyle16
                                  .copyWith(color: theme.onPrimary),
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}

class Onboarding {
  final int id;
  final String title;
  final String ImageURL;
  final String description;

  Onboarding(this.id, this.title, this.ImageURL, this.description);
}

List<Onboarding> contents = [
  Onboarding(0, 'Welcome to Task Manager', Assets.images.logo.logo.path,
      "Welcome to TaskMaster, your ultimate companion for productivity. Let's get you started on a journey to efficient task management!"),
  Onboarding(
      1,
      'Organize and Prioritize',
      Assets.images.onboarding.task.path,
      'Easily organize your tasks with our intuitive interface. Prioritize your to-dos, set deadlines, and stay on top of your schedule with minimal effort.'),
];
