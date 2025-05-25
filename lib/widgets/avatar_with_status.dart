import 'package:flutter/material.dart';


import '../utils/constants.dart';

class AvatarWithStatus extends StatelessWidget {
  final String avatarUrl;
  final double size;
  final bool isOnline;

  const AvatarWithStatus({
    Key? key,
    required this.avatarUrl,
    this.size = 50,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey[300],
          backgroundImage: AssetImage(avatarUrl),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
