import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager_app/core/utils/functions/spinkit.dart';
import 'package:task_manager_app/features/task_management/presentation/widgets/add_task_dialog.dart';
import 'package:task_manager_app/features/task_management/presentation/widgets/custom_appbar.dart';
import 'package:task_manager_app/features/task_management/presentation/widgets/task_item.dart';
import 'package:task_manager_app/injection_container.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../bloc/task_bloc.dart';

class HomeBody extends StatelessWidget {
  HomeBody({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.taskStatus == TaskStatus.errorShowTasks) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.taskStatus == TaskStatus.paginated) {
          skip = limit + skip;
          context
              .read<TaskBloc>()
              .add(GetTasks(userId!, limit, skip, false));
        }
        if (state.taskStatus == TaskStatus.successEditTask) {
          showToast(
              text: "Task Completed Successfully", state: ToastState.success);
        }
        if (state.taskStatus == TaskStatus.successDeleteTask) {
          showToast(
              text: "Task Deleted Successfully", state: ToastState.success);
        }
        if (state.taskStatus == TaskStatus.successAddTask) {
          limit = 5;
          skip = 0;
          context
              .read<TaskBloc>()
              .add(GetTasks(userId!, limit, skip, true));
          showToast(text: "Task Added Successfully", state: ToastState.success);
        }
        if (state.taskStatus == TaskStatus.errorEditTask) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.taskStatus == TaskStatus.errorDeleteTask) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.taskStatus == TaskStatus.errorShowTasks) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state.isTasksLoaded!,
          builder: (context) => RefreshIndicator(
            onRefresh: () async {
              limit = 5;
              skip = 0;
              context
                  .read<TaskBloc>()
                  .add(GetTasks(userId!, limit, skip, true));
              await Future.delayed(Duration(seconds: 2));
            },
            child: SingleChildScrollView(
              controller: state.scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomAppBar(
                      name: name.toString(),
                      image: image.toString(),
                      onAddPressed: () {
                        addTaskDialog(context, formKey);
                      }),
                  ListView.builder(
                    itemCount: state.taskStatus == TaskStatus.paginated
                        ? state.tasksEntity!.length + 1
                        : state.tasksEntity!.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    itemBuilder: (context, index) {
                      if (index < state.tasksEntity!.length) {
                        return TaskItem(
                            task: state.tasksEntity![index],
                            index: index,
                            onDeletePressed: () {
                              context.read<TaskBloc>().add(DeleteTask(
                                  state.tasksEntity![index].taskId!, index));
                            },
                            onCompletePressed: () {
                              if (!state.tasksEntity![index].isCompleted!) {
                                context.read<TaskBloc>()
                                  ..add(EditTask(
                                      state.tasksEntity![index].taskId!,
                                      !state.tasksEntity![index].isCompleted!));
                              }
                            });
                      }
                      return null;
                    },
                    physics: NeverScrollableScrollPhysics(),
                  ),
                  state.taskStatus == TaskStatus.paginated
                      ? Center(child: spinKitApp(100))
                      : SizedBox(),
                ],
              ),
            ),
          ),
          fallback: (context) => spinKitApp(100),
        );
      },
    );
  }
}
