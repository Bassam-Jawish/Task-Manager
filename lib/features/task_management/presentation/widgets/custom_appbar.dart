// app_bar.dart

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_image_view.dart';

class CustomAppBar extends StatelessWidget {
  final String name;
  final String image;
  final Function() onAddPressed;

  const CustomAppBar({
    required this.name,
    required this.image,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Hello, $name",
                style: Styles.textStyle24.copyWith(
                  color: AppColor.primaryLight,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10.w),
              CustomImageView(
                imagePath: image,
                height: 40.h,
                width: 36.w,
              ),
            ],
          ),
          IconButton(
            onPressed: onAddPressed,
            icon: Icon(
              Icons.add,
              color: AppColor.secondaryLight,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
