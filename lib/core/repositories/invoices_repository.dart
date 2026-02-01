import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdad_app/models/invoice_model.dart';

class InvoicesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<InvoiceModel>> getInvoices({required String ownerId}) async {
    final snapshot = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('invoices')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return InvoiceModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<String> createInvoice({
    required String ownerId,
    required String customerId,
    required double amount,
    required DateTime dueDate,
  }) async {
    final doc = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('invoices')
        .add({
          'customer_id': customerId,
          'amount': amount,
          'status': 'unpaid',
          'due_date': Timestamp.fromDate(dueDate),
          'created_at': FieldValue.serverTimestamp(),
        });

    return doc.id;
  }

  Future<void> updateInvoiceAfterPayment({
    required String ownerId,
    required String invoiceId,
    required double remainingAmount,
    required String status,
  }) async {
    try {
      await _firestore
          .collection('shop_owners')
          .doc(ownerId)
          .collection('invoices')
          .doc(invoiceId)
          .update({'amount': remainingAmount, 'status': status});
      print("✅ Invoice $invoiceId updated successfully");
    } catch (e) {
      throw Exception("خطأ في تحديث الفاتورة: $e");
    }
  }
}
