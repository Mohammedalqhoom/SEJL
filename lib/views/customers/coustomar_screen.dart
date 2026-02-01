import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/customerCard.dart';
import 'package:sdad_app/views/customers/add_coustomar_screen.dart';

class CustomersScreen extends StatelessWidget {
  CustomersScreen({super.key});

  final CustomersController controller = Get.find<CustomersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('العملاء', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Text(
              controller.error.value!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.customers.isEmpty) {
          return const Center(child: Text('لا يوجد عملاء'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.customers.length,
          itemBuilder: (context, index) {
            final customer = controller.customers[index];
            return CustomerCard(customer: customer);
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        heroTag: 'add_customer_btn',
        onPressed: () {
          Get.to(() => AddCustomerScreen());
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.buttonGradient,
          ),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
