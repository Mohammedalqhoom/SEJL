import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/controllers/addCustomerController.dart';
import 'package:sdad_app/controllers/add_invoice_controller.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/controllers/invoices_controller.dart';
import 'package:sdad_app/controllers/navigation_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/views/customers/coustomar_screen.dart';
import 'package:sdad_app/views/dashboard/dashboard_screen.dart';
import 'package:sdad_app/views/invoice/InvoicesScreen.dart';
import 'package:sdad_app/views/report/reportScreen.dart';

class MainLayout extends StatelessWidget {
  MainLayout({super.key});

  final navController = Get.find<NavigationController>();

  final customersController = Get.find<CustomersController>();

  final controllerinvoice = Get.find<InvoicesController>();
  final addCustomerController = Get.find<AddCustomerController>();

  final invoiceController = Get.find<AddInvoiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: navController.currentIndex.value,
          children: [
            DashboardScreen(),
            CustomersScreen(),
            InvoicesScreen(),
            Reportscreen(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeIndex,
          selectedItemColor: AppColors.purple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'العملاء'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'الفواتير',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'التقارير',
            ),
          ],
        );
      }),
    );
  }
}
