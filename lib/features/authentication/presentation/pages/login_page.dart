import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../widgets/login_body.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundColorLight,
        appBar: null,
        body: SafeArea(child: LoginBody()),
      ),
    );
  }
}
