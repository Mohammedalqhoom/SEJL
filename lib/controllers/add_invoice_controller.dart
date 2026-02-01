import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/controllers/invoices_controller.dart';
import 'package:sdad_app/core/repositories/invoices_repository.dart';
import 'package:sdad_app/core/repositories/customers_repository.dart';
import 'package:sdad_app/models/invoice_model.dart';

class AddInvoiceController extends GetxController {
  final InvoicesRepository _invoicesRepo = InvoicesRepository();
  final CustomersRepository _customersRepo = CustomersRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final isLoading = false.obs;
  final error = RxnString();

  Future<void> addInvoice({
    required String customerId,
    required double amount,
    required DateTime dueDate,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final ownerId = _auth.currentUser!.uid;

      //
      final id_invoice = await _invoicesRepo.createInvoice(
        ownerId: ownerId,
        customerId: customerId,
        amount: amount,
        dueDate: dueDate,
      );

      // 2️ تحديث دين العميل
      await _customersRepo.incrementCustomerDebt(
        ownerId: ownerId,
        customerId: customerId,
        amount: amount,
      );

      final newInvoice = InvoiceModel(
        id: id_invoice,
        amount: amount,
        customerId: customerId,
        dueDate: dueDate,
        status: "unpaid",
        createdAt: DateTime.now(),
      );

      Get.find<InvoicesController>().addInvoiceLocally(newInvoice);
      Get.find<CustomersController>().updatedebtCustomer(customerId, amount);
      Get.back(); //
    } catch (e) {
      error.value = 'فشل إنشاء الفاتورة';
    } finally {
      isLoading.value = false;
    }
  }
}
