import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/controllers/addCustomerController.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/app_input_field.dart';

class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({super.key});
  final controllerCustomar = Get.find<CustomersController>();
  final addCustomerController = Get.find<AddCustomerController>();

  final _formKey = GlobalKey<FormState>();

  String name = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('إضافة عميل', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppInputField(
                    label: ' إسم العميل',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                    onSaved: (value) => name = value!,
                  ),

                  const SizedBox(height: 16),

                  AppInputField(
                    label: 'رقم الهاتف ',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      return null;
                    },
                    onSaved: (value) => phone = value!,
                  ),

                  const SizedBox(height: 30),

                  Obx(() {
                    if (addCustomerController.isLoading.value) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }

                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            addCustomerController.addCustomer(
                              name: name,
                              phone: phone,
                            );
                          }
                        },

                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'حفظ العميل ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  Obx(() {
                    if (addCustomerController.error.value != null) {
                      return Text(
                        addCustomerController.error.value!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
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
    );
  }
}
