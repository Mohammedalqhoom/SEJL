import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/core/repositories/customers_repository.dart';
import 'package:sdad_app/models/customer_model.dart';

class AddCustomerController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomersRepository _firestore = CustomersRepository();
  final isLoading = false.obs;
  final error = RxnString();

  Future<void> addCustomer({
    required String name,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final user = _auth.currentUser;
      if (user == null) {
        throw 'المستخدم لم يسجل دخول';
      }

      final ownerId = user.uid;
      final add = await _firestore.addCustomer(
        ownerId: ownerId,
        name: name,
        phone: phone,
      );

      final newCustomer = CustomerModel(
        id: add,
        name: name,
        phone: phone,
        totalDebt: 0,
        createdAt: DateTime.now(),
      );

      Get.find<CustomersController>().addCustomerLocally(newCustomer);

      Get.back(); // يرجع بعد  الإضافة
    } catch (e) {
      print('AddCustomer Error: $e');
      error.value = 'فشل إضافة العميل';
    } finally {
      isLoading.value = false;
    }
  }
}
