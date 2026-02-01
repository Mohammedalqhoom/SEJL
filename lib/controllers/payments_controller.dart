import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdad_app/controllers/invoices_controller.dart';
import 'package:sdad_app/core/repositories/PaymentsRepository/PaymentsRepository.dart';
import 'package:sdad_app/core/repositories/customers_repository.dart';
import 'package:sdad_app/core/repositories/invoices_repository.dart';

import 'package:sdad_app/models/paymentModel.dart';

import 'customers_controller.dart'; //

class PaymentsController extends GetxController {
  final PaymentsRepository _paymentServer = PaymentsRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final invoice = Get.find<InvoicesController>();
  final _customarRepos = CustomersRepository();
  final _invoicesRepo = InvoicesRepository();
  final paymentsList = <PaymentModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadPayments(); //
  }

  Future<void> loadPayments() async {
    try {
      isLoading.value = true;
      error.value = null;

      final ownerId = _auth.currentUser!.uid;

      final result = await _paymentServer.getPayments(ownerId: ownerId);
      paymentsList.assignAll(result);
    } catch (e) {
      error.value = 'فشل تحميل الدفعات';
      print("Error loading payments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmPaymentProcess({
    required String customerId,
    required String invoiceId,
    required double paymentAmount,
    required String method,
  }) async {
    try {
      isLoading.value = true;
      String ownerId = FirebaseAuth.instance.currentUser!.uid;

      final invController = Get.find<InvoicesController>();
      final invoiceIndex = invController.invoicesList.indexWhere(
        (i) => i.id == invoiceId,
      );

      if (invoiceIndex == -1) throw "الفاتورة غير موجودة";

      double currentAmount = invController.invoicesList[invoiceIndex].amount;
      double newRemainingAmount = currentAmount - paymentAmount;
      String newStatus = (newRemainingAmount <= 0) ? 'paid' : 'unpaid';

      await _paymentServer.createPayment(
        ownerId: ownerId,
        invoiceId: invoiceId,
        amount: paymentAmount,
        method: method,
        paymentDate: DateTime.now(),
      );

      await _invoicesRepo.updateInvoiceAfterPayment(
        ownerId: ownerId,
        invoiceId: invoiceId,
        remainingAmount: newRemainingAmount < 0 ? 0 : newRemainingAmount,
        status: newStatus,
      );

      await _customarRepos.updateCustomerDebt(
        ownerId: ownerId,
        customerId: customerId,
        amountChange: -paymentAmount,
      );

      invController.processInvoicePayment(
        invoiceId: invoiceId,
        paymentAmount: paymentAmount,
      );

      final custController = Get.find<CustomersController>();
      custController.updatedebtCustomer(customerId, -paymentAmount);

      Get.back();
      Get.snackbar(
        "نجاح",
        "تمت العملية وتحديث الحسابات",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء التحديث: $e");
    } finally {
      isLoading.value = false;
    }
  }

  double get totalCollectedPayments {
    return paymentsList.fold(0.0, (sum, payment) => sum + payment.amount);
  }
}
