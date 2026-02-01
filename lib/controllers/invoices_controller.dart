import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sdad_app/core/repositories/invoices_repository.dart';
import '../models/invoice_model.dart';

class InvoicesController extends GetxController {
  final InvoicesRepository _DALrepository = InvoicesRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final invoicesList = <InvoiceModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;
      error.value = null;

      final ownerId = _auth.currentUser!.uid;

      final result = await _DALrepository.getInvoices(ownerId: ownerId);
      invoicesList.assignAll(result);
    } catch (e) {
      error.value = 'فشل تحميل الفواتير';
    } finally {
      isLoading.value = false;
    }
  }

  int get invoiceOverdueCount {
    DateTime now = DateTime.now();

    return invoicesList.where((invoice) {
      bool isMarkedOverdue = invoice.status == "overdue";

      bool isActuallyOverdue =
          invoice.status == "unpaid" && invoice.dueDate.isBefore(now);

      return isMarkedOverdue || isActuallyOverdue;
    }).length;
  }

  void processInvoicePayment({
    required String invoiceId,
    required double paymentAmount,
  }) {
    int index = invoicesList.indexWhere((inv) => inv.id == invoiceId);

    if (index != -1) {
      InvoiceModel currentInvoice = invoicesList[index];

      double remainingAmount = currentInvoice.amount - paymentAmount;

      String newStatus = (remainingAmount <= 0) ? 'paid' : 'unpaid';

      invoicesList[index] = currentInvoice.copyWith(
        amount: remainingAmount < 0 ? 0 : remainingAmount, //
        status: newStatus,
      );

      invoicesList.refresh();
    }
  }

  void addInvoiceLocally(InvoiceModel invoice) {
    invoicesList.insert(0, invoice);
  }
}
