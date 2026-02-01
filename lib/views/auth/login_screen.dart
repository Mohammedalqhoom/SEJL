import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sdad_app/controllers/login_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/app_input_field.dart';
import 'package:sdad_app/models/User_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.find<LoginController>();

  String _email = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //  خلفية متدرجة
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              //  Card شفاف
              color: Colors.white.withOpacity(0.12),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SEJL',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'مرحبا بك فى سجلك الرقمي',
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 30),

                      AppInputField(
                        label: 'البريد الإلكتروني',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'البريد الإلكتروني مطلوب';
                          }
                          if (!value.contains('@')) {
                            return 'البريد الإلكتروني غير صحيح';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value!,
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        label: 'كلمة المرور',
                        icon: Icons.lock,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'كلمة المرور مطلوبة';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),

                      const SizedBox(height: 24),

                      Obx(() {
                        if (controller.state.isLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final credentials = LoginCredentials(
                                  email: _email,
                                  password: _password,
                                );

                                await controller.login(credentials);
                              }
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      Obx(() {
                        if (controller.state.error != null) {
                          return Text(
                            controller.state.error!,
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 12),

                      Obx(() {
                        if (controller.state.showRegister) {
                          return TextButton(
                            onPressed: () {
                              Get.offAllNamed('/register');
                            },
                            child: const Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
