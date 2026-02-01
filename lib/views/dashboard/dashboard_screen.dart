import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/controllers/dashboard_controller.dart';
import 'package:sdad_app/controllers/invoices_controller.dart';

import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/action_button.dart';
import 'package:sdad_app/core/widgets/activity_item.dart';
import 'package:sdad_app/core/widgets/stat_card.dart';
import 'package:sdad_app/views/customers/add_coustomar_screen.dart';
import 'package:sdad_app/views/invoice/add_invoice_screen.dart';
import 'package:sdad_app/views/payments/PaymentsScreen.dart';

final invoicecontollor = Get.find<InvoicesController>();

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final controller = Get.find<DashboardController>();

  final customarcount = Get.find<CustomersController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      //-------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('سجل', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: AppColors.blueLight,
              child: const Icon(Icons.store, color: Colors.white),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoding.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('اسم المحل', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 6),
                    Text(
                      'سجل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========
              Row(
                children: [
                  Obx(
                    () => StatCard(
                      title: 'العملاء',
                      value: customarcount.customers.length.toString(),
                    ),
                  ),
                  Obx(
                    () => StatCard(
                      title: 'الديون',
                      value: customarcount.totalAllDebts.toStringAsFixed(2),
                    ),
                  ),

                  Obx(
                    () => StatCard(
                      title: 'المتأخرة',
                      value: invoicecontollor.invoiceOverdueCount.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'إجراءات سريعة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  ActionButton(
                    icon: Icons.person_add,
                    label: 'إضافة عميل',
                    onTap: () {
                      Get.to(() => AddCustomerScreen());
                    },
                  ),
                  ActionButton(
                    icon: Icons.receipt_long,
                    label: 'فاتورة جديدة',
                    onTap: () {
                      Get.to(() => AddInvoiceScreen());
                    },
                  ),
                  ActionButton(
                    icon: Icons.payments,
                    label: 'سجل الدفعات',
                    onTap: () {
                      Get.to(() => const PaymentsScreen());
                    },
                  ),
                  ActionButton(
                    onTap: () => showUnderDevelopment(),
                    icon: Icons.notifications_active,
                    label: 'متابعة',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // =========
              const Text(
                'آخر النشاطات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              ActivityItem(
                icon: Icons.payments,
                color: Colors.green,
                title: 'تم استلام دفعة',
                subtitle: 'من أحد العملاء',
              ),
              ActivityItem(
                icon: Icons.warning,
                color: Colors.orange,
                title: 'فاتورة متأخرة',
                subtitle: 'عميل لم يسدد',
              ),
              ActivityItem(
                icon: Icons.receipt,
                color: Colors.blue,
                title: 'فاتورة جديدة',
                subtitle: 'تم إنشاؤها',
              ),
            ],
          ),
        );
      }),
    );
  }

  void showUnderDevelopment() {
    Get.defaultDialog(
      title: "قيد التطوير",
      middleText: "هذه الميزة ستكون متاحة قريباً",
      textConfirm: "موافق",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.purple,
      onConfirm: () => Get.back(),
    );
  }
}
