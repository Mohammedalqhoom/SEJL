import 'package:get/get.dart';
import 'package:sdad_app/controllers/addCustomerController.dart';
import 'package:sdad_app/controllers/add_invoice_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/customers_controller.dart';
import '../controllers/invoices_controller.dart';
import '../controllers/dashboard_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => CustomersController());
    Get.lazyPut(() => InvoicesController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => AddCustomerController());
    Get.lazyPut(() => AddInvoiceController());
  }
}
