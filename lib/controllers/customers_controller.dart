import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdad_app/core/repositories/customers_repository.dart';
import 'package:sdad_app/models/customer_model.dart';

class CustomersController extends GetxController {
  final CustomersRepository _repository = CustomersRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final customers = <CustomerModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      error.value = null;

      final id = _auth.currentUser;
      if (id == null) throw "المستخدم لم يسجل دخول";

      final ownerId = id.uid;

      final result = await _repository.getCustomers(ownerId: ownerId);

      customers.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updatedebtCustomer(String idcustomer, double amount) {
    int index = customers.indexWhere((c) => c.id == idcustomer);

    if (index != -1) {
      CustomerModel oldCustomer = customers[index];
      CustomerModel updatedCustomer = oldCustomer.copyWith(
        totalDebt: oldCustomer.totalDebt + amount,
      );

      customers[index] = updatedCustomer;

      customers.refresh();
    }
  }

  String getCstomerNameById(String customerId) {
    final customer = customers.firstWhereOrNull((c) => c.id == customerId);

    return customer?.name ?? 'عميل غير معروف';
  }

  double get totalAllDebts {
    // استخدام fold لجمع كل الديون الموجودة في القائمة
    return customers.fold(0.0, (previousValue, customer) {
      return previousValue + (customer.totalDebt ?? 0.0);
    });
  }

  void addCustomerLocally(CustomerModel customer) {
    customers.insert(0, customer);
  }
}
