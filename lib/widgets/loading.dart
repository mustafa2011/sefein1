import '/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Text('فضلاً انتظر ...',
              style: TextStyle(
                  fontSize: 20,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
