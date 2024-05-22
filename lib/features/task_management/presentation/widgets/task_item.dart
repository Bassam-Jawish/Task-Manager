// task_item.dart

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  final int index;
  final VoidCallback onDeletePressed;
  final VoidCallback onCompletePressed;

  const TaskItem({
    required this.task,
    required this.index,
    required this.onDeletePressed,
    required this.onCompletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Task ${index + 1}",
                style: Styles.textStyle20.copyWith(
                  color: AppColor.onPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onDeletePressed,
                icon: Icon(
                  Icons.delete_forever,
                  color: AppColor.secondaryLight,
                  size: 25,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200.w,
                child: Text(
                  task.todo!,
                  style: Styles.textStyle14.copyWith(
                    color: AppColor.onPrimaryLight,
                  ),
                ),
              ),
              CustomElevatedButton(
                text: task.isCompleted! ? 'Completed' : 'Complete?',
                alignment: Alignment.center,
                onPressed: onCompletePressed,
                buttonTextStyle: task.isCompleted!
                    ? Styles.textStyle12.copyWith(
                  color: AppColor.onPrimaryLight,
                )
                    : Styles.textStyle12.copyWith(
                  color: AppColor.primaryLight,
                ),
                width: 100.w,
                buttonStyle: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  backgroundColor: task.isCompleted!
                      ? AppColor.primaryLight
                      : AppColor.backgroundColorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
