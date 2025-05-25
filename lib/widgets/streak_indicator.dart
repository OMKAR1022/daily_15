import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class StreakIndicator extends StatelessWidget {
  final int days;
  final Color? color;

  const StreakIndicator({
    Key? key,
    required this.days,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department,
          color: color ?? AppColors.streakColor,
          size: 16.r,
        ),
        SizedBox(width: 4.w),
        Text(
          '$days days',
          style: TextStyle(
            color: color ?? AppColors.streakColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
