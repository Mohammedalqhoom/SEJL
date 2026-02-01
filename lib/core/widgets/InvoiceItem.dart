// import 'package:flutter/material.dart';
// import 'package:sdad_app/models/invoice_model.dart';

// class InvoiceItem extends StatelessWidget {
//   final InvoiceModel invoice;
//   final String customerName;

//   const InvoiceItem({
//     super.key,
//     required this.invoice,
//     required this.customerName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = getStatusColor(invoice.status);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // ======= أيقونة =======
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: statusColor.withOpacity(0.15),
//             child: Icon(Icons.receipt_long, color: statusColor),
//           ),

//           const SizedBox(width: 12),

//           // ======= البيانات =======
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   customerName,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'فاتورة #${invoice.id.substring(0, 6)}',
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'الاستحقاق: ${invoice.dueDate.toLocal().toString().split(' ')[0]}',
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),

//           // ======= المبلغ + الحالة =======
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   invoice.status == 'paid'
//                       ? 'مدفوعة'
//                       : invoice.status == 'overdue'
//                       ? 'متأخرة'
//                       : 'غير مدفوعة',
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 '${invoice.amount.toStringAsFixed(0)} ريال',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: statusColor,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Color getStatusColor(String status) {
//     switch (status) {
//       case 'paid':
//         return Colors.green;
//       case 'overdue':
//         return Colors.red;
//       default:
//         return Colors.deepPurple;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdad_app/models/invoice_model.dart';
import 'package:sdad_app/views/payments/addPaymentScreen.dart';

class InvoiceItem extends StatelessWidget {
  final InvoiceModel invoice;
  final String customerName;

  const InvoiceItem({
    super.key,
    required this.invoice,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(invoice.status);

    final bool canAddPayment = invoice.status != 'paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: statusColor.withOpacity(0.15),
            child: Icon(Icons.receipt_long, color: statusColor),
          ),

          const SizedBox(width: 12),

          //  البيانات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'فاتورة #${invoice.id.substring(0, 6)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'الاستحقاق: ${invoice.dueDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          if (canAddPayment)
            IconButton(
              onPressed: () {
                Get.to(() => AddPaymentScreen(invoice: invoice));
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.blueGrey,
              ),
              tooltip: 'إضافة دفعة',
            ),

          const SizedBox(width: 8),

          // المبلغ + الحالة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.status == 'paid'
                      ? 'مدفوعة'
                      : invoice.status == 'overdue'
                      ? 'متأخرة'
                      : 'غير مدفوعة',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${invoice.amount.toStringAsFixed(0)} ريال',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.deepPurple;
    }
  }
}
