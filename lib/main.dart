import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/bindings/app_binding.dart';
import 'package:sdad_app/bindings/main_binding.dart';

import 'package:sdad_app/views/auth/login_screen.dart';
import 'package:sdad_app/views/layout/main_layout.dart';
import 'package:sdad_app/views/registerScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const sdadapp());
}

class sdadapp extends StatelessWidget {
  const sdadapp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: '/login',

      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),

        GetPage(
          name: '/main',
          page: () => MainLayout(),
          binding: MainBinding(),
        ),
        GetPage(name: '/register', page: () => Registerscreen()),
      ],
    );
  }
}
