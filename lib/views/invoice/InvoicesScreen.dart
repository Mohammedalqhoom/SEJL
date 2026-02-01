import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/controllers/invoices_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/InvoiceItem.dart';
import 'package:sdad_app/views/invoice/add_invoice_screen.dart';

class InvoicesScreen extends StatelessWidget {
  InvoicesScreen({super.key});

  final customersController = Get.find<CustomersController>();
  final controller = Get.find<InvoicesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text('الفواتير', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.purple,
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

        if (controller.invoicesList.isEmpty) {
          return const Center(child: Text('لا توجد فواتير'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.invoicesList.length,
          itemBuilder: (context, index) {
            final invoice = controller.invoicesList[index];
            final customerName = customersController.getCstomerNameById(
              invoice.customerId,
            );

            return InvoiceItem(invoice: invoice, customerName: customerName);
          },
        );
      }),

      //زر إضافة فاتورة
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_invoice_btn',
        backgroundColor: AppColors.purple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => AddInvoiceScreen());
        },
      ),
    );
  }
}
