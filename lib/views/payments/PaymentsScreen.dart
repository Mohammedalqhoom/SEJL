import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdad_app/controllers/payments_controller.dart';
import 'package:sdad_app/core/theme/app_colors.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'سجل المدفوعات المستلمة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
        ),
      ),
      body: Column(
        children: [
          //   كإجمالي التحصيل
          _buildTotalSummary(controller),

          // 2. قائمة الدفعات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.purple),
                );
              }

              if (controller.paymentsList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text("لا توجد دفعات مسجلة حتى الآن"),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: controller.paymentsList.length,
                itemBuilder: (context, index) {
                  final payment = controller.paymentsList[index];
                  return _buildPaymentCard(payment);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // تصميم الملخص العلوي بتدرج أرجواني
  Widget _buildTotalSummary(PaymentsController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradient, //
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "إجمالي التحصيلات",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              "${controller.totalCollectedPayments.toStringAsFixed(2)} ر.ي",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // كارت الدفعة
  Widget _buildPaymentCard(dynamic payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          right: BorderSide(color: AppColors.purple, width: 5), // خط جانبي بلون
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.blue.withOpacity(0.1),
          child: const Icon(Icons.receipt_long, color: AppColors.blue),
        ),
        title: Text(
          "رقم الفاتورة: #${payment.invoiceId.substring(0, 6)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "طريقة الدفع: ${payment.method}",
              style: const TextStyle(color: AppColors.blueLight),
            ),
            Text(
              DateFormat('yyyy-MM-dd | hh:mm a').format(payment.paymentDate),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${payment.amount}",
              style: const TextStyle(
                color: Color(0xFF27AE60), //
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text(
              "ر.ي",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
