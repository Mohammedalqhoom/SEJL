import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sdad_app/models/customer_model.dart';

class CustomersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CustomerModel>> getCustomers({required String ownerId}) async {
    final snapshot = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('customers')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CustomerModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<String> addCustomer({
    required String ownerId,
    required String name,
    required String phone,
  }) async {
    final doc = await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('customers')
        .add({
          'name': name,
          'phone': phone,
          'total_debt': 0.0,
          'created_at': FieldValue.serverTimestamp(),
        });

    return doc.id;
  }

  Future<void> incrementCustomerDebt({
    required String ownerId,
    required String customerId,
    required double amount,
  }) async {
    await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('customers')
        .doc(customerId)
        .update({'total_debt': FieldValue.increment(amount)});
  }

  Future<void> decrementCustomerDebt({
    required String ownerId,
    required String customerId,
    required double amount,
  }) async {
    await _firestore
        .collection('shop_owners')
        .doc(ownerId)
        .collection('customers')
        .doc(customerId)
        .update({'total_debt': FieldValue.increment(-amount)});
  }

  Future<void> updateCustomerDebt({
    required String ownerId,
    required String customerId,
    required double amountChange,
  }) async {
    try {
      await _firestore
          .collection('shop_owners')
          .doc(ownerId)
          .collection('customers')
          .doc(customerId)
          .update({'totalDebt': FieldValue.increment(amountChange)});
      print(" Customer debt updated successfully");
    } catch (e) {
      throw Exception("خطأ في تحديث دين العميل: $e");
    }
  }
}
