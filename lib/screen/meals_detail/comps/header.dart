import 'package:flutter/material.dart';

import '../../../config/theme/fitness_app_theme.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Diet Plan Detail',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 30,
            letterSpacing: 0.5,
            color: FitnessAppTheme.lightText,
          ),
        )
      ],
    );
  }
}
