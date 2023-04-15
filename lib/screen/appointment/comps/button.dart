import 'package:flutter/material.dart';

import '../../../config/theme/theme.dart';


class Button extends StatelessWidget {
  const Button(
      {Key? key,
        required this.width,
        required this.title,
        required this.onPressed,
        required this.disable})
      : super(key: key);

  final double width;
  final String title;
  final bool disable; //this is used to disable button
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colorAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15))
        ),

        onPressed: disable ? null : onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}