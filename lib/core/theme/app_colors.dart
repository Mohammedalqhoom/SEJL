import 'package:flutter/material.dart';

class AppColors {
  static const Color blue = Color(0xFF0A4D68); //خلفيات
  static const Color blueLight = Color(0xFF05BFDB); //نصوص ثانوية
  static const Color purple = Color(0xFF7B2CBF);
  static const Color purpleLight = Color(0xFF9D4EDD);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue, purple],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [purpleLight, purple],
  );
}
