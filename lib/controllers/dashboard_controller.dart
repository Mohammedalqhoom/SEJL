import 'package:get/get.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/controllers/invoices_controller.dart';

class DashboardController extends GetxController {
  final isLoding = false.obs;

  final customersCount = 0.obs;
  final totalDebt = 0.0.obs;
  final overdueCount = 0.obs;
  final invoicecontollor = Get.find<InvoicesController>();
  final CustomersController contollor = Get.put(CustomersController());

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() {
    isLoding.value = true;
    customersCount.value = contollor.customers.length;
    totalDebt.value = 15.5;
    overdueCount.value = invoicecontollor.invoiceOverdueCount;
    isLoding.value = false;
  }
}
