import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/controllers/add_invoice_controller.dart';
import 'package:sdad_app/controllers/customers_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/app_input_field.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final invoiceController = Get.find<AddInvoiceController>();

  final customersController = Get.find<CustomersController>();

  String? selectedCustomerId;
  String amountText = '';
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // ================= AppBar =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'إضافة فاتورة',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      // ================= Body =================
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ================= اختيار العميل =================
                    Obx(() {
                      if (customersController.customers.isEmpty) {
                        return const Text(
                          'لا يوجد عملاء',
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        dropdownColor: Colors.deepPurple,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          label: 'العميل',
                          icon: Icons.person,
                        ),
                        items: customersController.customers.map((c) {
                          return DropdownMenuItem<String>(
                            value: c.id,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedCustomerId = value;
                        },
                        validator: (value) {
                          if (value == null) return 'اختر العميل';
                          return null;
                        },
                      );
                    }),

                    const SizedBox(height: 16),

                    // ================= المبلغ =================
                    AppInputField(
                      label: 'المبلغ',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'المبلغ مطلوب';
                        }
                        if (double.tryParse(value) == null) {
                          return 'أدخل رقم صحيح';
                        }
                        return null;
                      },
                      onSaved: (value) => amountText = value!,
                    ),

                    const SizedBox(height: 16),

                    // ================= تاريخ الاستحقاق =================
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (picked != null) {
                          setState(() {
                            dueDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              dueDate == null
                                  ? 'تاريخ الاستحقاق'
                                  : 'تاريخ الاستحقاق: ${dueDate!.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= زر الحفظ =================
                    Obx(() {
                      if (invoiceController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            if (dueDate == null) {
                              Get.snackbar(
                                'خطأ',
                                'اختر تاريخ الاستحقاق',
                                colorText: Colors.white,
                              );
                              return;
                            }

                            _formKey.currentState!.save();

                            await invoiceController.addInvoice(
                              customerId: selectedCustomerId!,
                              amount: double.parse(amountText),
                              dueDate: dueDate!,
                            );
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text(
                                'حفظ الفاتورة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ================= رسالة الخطأ =================
                    Obx(() {
                      if (invoiceController.error.value != null) {
                        return Text(
                          invoiceController.error.value!,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // نفس ديكور الإدخال المستخدم في كل الشاشات
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
