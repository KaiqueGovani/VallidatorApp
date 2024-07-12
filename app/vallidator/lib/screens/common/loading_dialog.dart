import 'package:flutter/material.dart';
import 'package:vallidator/themes/main_colors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.white,
      child: const SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: CircularProgressIndicator(
            color: MainColors.tertiary,
          ),
        ),
      ),
    );
  }
}
