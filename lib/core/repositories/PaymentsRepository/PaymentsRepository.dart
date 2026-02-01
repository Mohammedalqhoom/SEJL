import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdad_app/models/paymentModel.dart';

class PaymentsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. جلب قائمة الدفعات الخاصة بصاحب المحل
  Future<List<PaymentModel>> getPayments({required String ownerId}) async {
    final snapshot = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('payments')
        .orderBy('payment_date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return PaymentModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<String> createPayment({
    required String ownerId,
    required String invoiceId,
    required double amount,
    required String method,
    required DateTime paymentDate,
  }) async {
    // إنشاء كائن الدفعة
    final paymentData = {
      'invoice_id': invoiceId,
      'owner_id': ownerId,
      'amount': amount,
      'method': method,
      'payment_date': Timestamp.fromDate(
        paymentDate,
      ), // تحويل DateTime إلى Timestamp للفايربيز
      'created_at': FieldValue.serverTimestamp(), //
    };
    final doc = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('payments')
        .add(paymentData);

    return doc.id;
  }

  // 3. جلب الدفعات الخاصة بفاتورة معينة فقط (اختياري ومفيد)
  Future<List<PaymentModel>> getPaymentsByInvoice({
    required String ownerId,
    required String invoiceId,
  }) async {
    final snapshot = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('payments')
        .where('invoice_id', isEqualTo: invoiceId)
        .get();

    return snapshot.docs.map((doc) {
      return PaymentModel.fromMap(doc.id, doc.data());
    }).toList();
  }
}
