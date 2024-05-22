import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/custom_outlined_bottom.dart';

Widget forgotPasswordLogin(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {},
        child: Text(
          'Forgot Password?',
          style: Styles.textStyle14.copyWith(
            color: theme.primary,
          ),
        ),
      ),
    ],
  );
}

Widget registerRowLogin(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Don't have an account?",
        style: Styles.textStyle14.copyWith(color: AppColor.gray500),
      ),
      TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: () {},
        child: Text(
          "Sign Up",
          style: Styles.textStyle14.copyWith(
            color: theme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

Widget buildDivider(BuildContext context) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 9.h),
            child: SizedBox(
                width: 137.h,
                child: const Divider(
                  color: Colors.grey,
                ))),
        Text('OR',
            style: Styles.textStyle18
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
        Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 9.h),
            child: SizedBox(
                width: 137.h,
                child: const Divider(
                  color: Colors.grey,
                )))
      ]);
}

Widget buildSocial(BuildContext context) {
  return Column(children: [
    CustomOutlinedButton(
        buttonStyle: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColor.gray500,
            width: 0.6,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        text: "Sign in with Google",
        leftIcon: Container(
          margin: EdgeInsets.only(right: 30.w),
          child: CustomImageView(
              imagePath: Assets.images.icons.imgGoogle.path,
              height: 20.h,
              width: 19.w),
        ),
        onPressed: () {}),
    SizedBox(height: 16.h),
    CustomOutlinedButton(
      alignment: Alignment.centerLeft,
      buttonStyle: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AppColor.gray500,
          width: 0.6,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      text: "Sign in with Apple",
      onPressed: () {},
      leftIcon: Container(
        margin: EdgeInsets.only(right: 30.w),
        child: CustomImageView(
            imagePath: Assets.images.icons.imgApple.path,
            height: 20.h,
            width: 16.w),
      ),
    ),
    SizedBox(height: 16.h),
    CustomOutlinedButton(
      buttonStyle: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AppColor.gray500,
          width: 0.6,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      text: "Sign in with Facebook",
      onPressed: () {},
      leftIcon: Container(
        margin: EdgeInsets.only(right: 30.w),
        child: CustomImageView(
            imagePath: Assets.images.icons.imgFacebook.path,
            height: 25.h,
            width: 25.w),
      ),
    ),
  ]);
}
