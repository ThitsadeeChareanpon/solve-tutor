import 'package:flutter/material.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';

export 'sizebox.dart';

final _util = UtilityHelper();
Widget solveIcon() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(color: CustomColors.greenPrimary.withOpacity(0.5)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ph_video.png',
            scale: _util.isTablet() ? 2.5 : 4,
          ),
          S.w(10),
          Text(
            'SOLVE LIVE',
            style: CustomStyles.bold16Black.copyWith(
              color: CustomColors.greenPrimary,
              fontSize: _util.addMinusFontSize(14),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget iconSolveVdo() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(color: CustomColors.greenPrimary.withOpacity(0.5)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ph_video.png',
            scale: _util.isTablet() ? 2.5 : 4,
          ),
          S.w(10),
          Text(
            'VDO',
            style: CustomStyles.bold16Black.copyWith(
              color: CustomColors.greenPrimary,
              fontSize: _util.addMinusFontSize(14),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget iconSolvPad() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(color: CustomColors.greenPrimary.withOpacity(0.5)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: Row(
        children: [
          Image.asset(
            'assets/images/icon_select_pdf.png',
            scale: _util.isTablet() ? 2.5 : 4,
          ),
          S.w(10),
          Text(
            'SOLVEPAD',
            style: CustomStyles.bold16Black.copyWith(
              color: CustomColors.greenPrimary,
              fontSize: _util.addMinusFontSize(14),
            ),
          ),
        ],
      ),
    ),
  );
}
