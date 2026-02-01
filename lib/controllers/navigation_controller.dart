import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/core/theme/app_colors.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  void changeIndex(int index) {
    if (index == 3) {
      Get.defaultDialog(
        title: "قيد التطوير",
        middleText: "ميزة التقارير ستكون متاحة قريباً في التحديث القادم ",
        textConfirm: "موافق",
        confirmTextColor: Colors.white,
        buttonColor: AppColors.purple,
        onConfirm: () {
          Get.back();
        },
      );

      return;
    }
    currentIndex.value = index;
  }
}
