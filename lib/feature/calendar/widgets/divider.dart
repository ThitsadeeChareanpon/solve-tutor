import 'package:flutter/material.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';

Widget buildDivider(context) {
  return const Padding(
    padding: EdgeInsets.only(left: 24, right: 24),
    child: Divider(),
  );
}

Widget buildDividerShort(context) {
  return const SizedBox(
    width: double.infinity,
    child: Divider(),
  );
}

Widget buildVerticalDividerGray(double height, double width) {
  final util = UtilityHelper();

  return SizedBox(
    height: height,
    child: VerticalDivider(
      color: CustomColors.grayE5E6E9,
      thickness: 2,
      indent: util.isTablet() ? 5 : 2,
      endIndent: util.isTablet() ? 0 : 5,
      width: width,
    ),
  );
}
