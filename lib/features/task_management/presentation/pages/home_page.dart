import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../widgets/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      appBar: null,
      body: SafeArea(child: HomeBody()),
    );
  }
}
