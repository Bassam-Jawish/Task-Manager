import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/default_textformfield.dart';
import '../../../../injection_container.dart';
import '../bloc/task_bloc.dart';

Future<void> addTaskDialog(BuildContext context, GlobalKey<FormState> formKey) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.02),
        child: Text('Add Task', style: Styles.textStyle24.copyWith(color: AppColor.primaryLight)),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Container(
            height: height * 0.2,
            width: width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: _buildForm(context, formKey),
          ),
        ),
      ),
      actions: [
        _buildCancelButton(context),
        SizedBox(width: width * 0.05),
        _buildAddButton(context, formKey),
      ],
    ),
  );
}

Widget _buildForm(BuildContext context, GlobalKey<FormState> formKey) {
  final state = context.watch<TaskBloc>().state;

  return Form(
    key: formKey,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What To Do:',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColor.secondaryLight),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.012),
        CustomTextFormField(
          autoValidateMode: AutovalidateMode.onUserInteraction,
          controller: state.taskController,
          textStyle: Styles.textStyle16.copyWith(color: Colors.black),
          hintText: "Enter your task here",
          hintStyle: Styles.textStyle16,
          textInputType: TextInputType.text,
          validator: (value) => value!.isEmpty ? "Please enter task here" : null,
          prefix: SizedBox(),
          contentPadding: EdgeInsets.only(top: 8.h, bottom: 8.h),
        ),
      ],
    ),
  );
}

Widget _buildCancelButton(BuildContext context) {
  return TextButton(
    style: ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((states) => AppColor.shadeColor),
    ),
    onPressed: () {
      Navigator.pop(context);
      context.read<TaskBloc>().add(ClearTaskController());
    },
    child: Text('Cancel', style: Styles.textStyle16.copyWith(color: AppColor.primaryLight)),
  );
}

Widget _buildAddButton(BuildContext context, GlobalKey<FormState> formKey) {
  return TextButton(
    style: ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((states) => AppColor.shadeColor),
    ),
    onPressed: () => _onAddTaskPressed(context, formKey),
    child: Text('Add Task', style: Styles.textStyle16.copyWith(color: AppColor.primaryLight)),
  );
}

void _onAddTaskPressed(BuildContext context, GlobalKey<FormState> formKey) {
  if (formKey.currentState!.validate()) {
    final state = context.read<TaskBloc>().state;
    context.read<TaskBloc>().add(AddTask(state.taskController!.text, userId!, false));
    context.read<TaskBloc>().add(ClearTaskController());
    Navigator.pop(context);
  }
}
