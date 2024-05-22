import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_circular.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/default_textformfield.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import 'login_widgets.dart';

class LoginBody extends StatelessWidget {
  LoginBody({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.authStatus == AuthStatus.error) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.authStatus == AuthStatus.success) {

          token = state.userInfoEntity!.token;
          userId = state.userInfoEntity!.id!;
          name = state.userInfoEntity!.firstName!;
          image = state.userInfoEntity!.image!;

          await SecureStorage.writeSecureData(key: 'userId', value: userId);
          await SecureStorage.writeSecureData(key: 'token', value: token);
          await SecureStorage.writeSecureData(key: 'name', value: name);
          await SecureStorage.writeSecureData(key: 'image', value: image);
          showToast(text: 'Login Successfully', state: state);
          GoRouter.of(context).pushReplacement(AppRouter.kBasePage);
        }

        if (state.authStatus == AuthStatus.loading) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome", style: Styles.textStyle30.copyWith(color: theme.primary),),
                SizedBox(
                  height: 15.h,
                ),
                CustomTextFormField(
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  controller: _controller,
                  focusNode: _focusNode,
                  textStyle: Styles.textStyle16.copyWith(color: Colors.black),
                  hintText: "Enter your username",
                  hintStyle: Styles.textStyle16,
                  textInputType: TextInputType.text,
                  prefix: Container(
                    margin: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                    child: CustomImageView(
                      imagePath: Assets.images.icons.imgEmail.path,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  prefixConstraints: BoxConstraints(maxHeight: 56.h),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter valid username";
                    }
                    return null;
                  },
                  contentPadding:
                      EdgeInsets.only(top: 8.h, right: 30.w, bottom: 8.h),
                ),
                SizedBox(
                  height: 15.h,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    return previous.isPasswordVis != current.isPasswordVis;
                  },
                  builder: (context, state) {
                    return CustomTextFormField(
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      textStyle: Styles.textStyle16.copyWith(color: Colors.black),
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      hintText: "Enter your password",
                      hintStyle: Styles.textStyle16,
                      textInputType: TextInputType.text,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                        child: CustomImageView(
                          imagePath: Assets.images.icons.imgPassword.path,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      suffix: IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const ChangePassword());
                        },
                        splashColor: Colors.white,
                        iconSize: 26,
                        icon: state.isPasswordVis!
                            ? const Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                      ),
                      obscureText: !state.isPasswordVis!,
                      suffixConstraints: BoxConstraints(maxHeight: 56.h),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      contentPadding:
                          EdgeInsets.only(top: 8.h, right: 30.w, bottom: 8.h),
                    );
                  },
                ),
                forgotPasswordLogin(context),
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return state.isLoading!
                        ? Center(child: circularLoading())
                        : CustomButton(
                            text: 'Login',
                            image: '',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      Login(_controller.text,
                                          _passwordController.text),
                                    );
                              }
                            },
                          );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                registerRowLogin(context),
                SizedBox(
                  height: 10.h,
                ),
                buildDivider(context),
                SizedBox(
                  height: 20.h,
                ),
                buildSocial(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
