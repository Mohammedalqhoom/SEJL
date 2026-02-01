import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/core/theme/app_colors.dart';
import 'package:sdad_app/core/widgets/app_input_field.dart'; // كلاس الحقول الخاص بك
import 'package:sdad_app/controllers/payments_controller.dart';
import 'package:sdad_app/models/invoice_model.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key, required this.invoice});
  final InvoiceModel invoice;
  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final PaymentsController controller = Get.put(PaymentsController());

  double _amount = 0;
  String _method = 'نقدًا (Cash)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("إضافة دفعة جديدة"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),

              _buildInvoiceSummary(),
              const SizedBox(height: 30),

              AppInputField(
                label: "المبلغ المدفوع",
                icon: Icons.money_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "يرجى إدخال المبلغ";
                  if (double.tryParse(value) == null) return "أدخل رقم صحيح";
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 20),

              _buildMethodDropdown(),
              const SizedBox(height: 40),

              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ملخص الفاتورة
  Widget _buildInvoiceSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text("رقم الفاتورة", style: TextStyle(color: Colors.white70)),
          Text(
            widget.invoice.id,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoTile("المبلغ الكلي", "${widget.invoice.amount}"),
              _infoTile("الحالة", widget.invoice.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.blueLight, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _method,
          dropdownColor: AppColors.blue,
          style: const TextStyle(color: Colors.white),
          items: ["نقدًا (Cash)", "تحويل بنكي (Bank)"].map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: (val) => setState(() => _method = val!),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient, // تدرج الزر الخاص بك
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            controller.confirmPaymentProcess(
              customerId: widget.invoice.customerId,
              invoiceId: widget.invoice.id,
              paymentAmount: _amount,
              method: _method,
            );
          }
        },

        child: const Text(
          "تأكيد العملية",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
