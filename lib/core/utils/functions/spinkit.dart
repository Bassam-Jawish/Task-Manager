
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../config/theme/colors.dart';

Widget spinKitApp(width) {
  return const SpinKitFadingCircle(
    key: Key('spin'),
    color: AppColor.primaryLight,
    size: 30,
  );
}