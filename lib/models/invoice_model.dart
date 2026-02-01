import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel {
  final String id;
  final String customerId;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DateTime dueDate;

  InvoiceModel({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.dueDate,
  });

  factory InvoiceModel.fromMap(String id, Map<String, dynamic> data) {
    final createdAtRaw = data['created_at'];
    final dueDateRaw = data['due_date'];

    return InvoiceModel(
      id: id,
      customerId: data['customer_id'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      status: data['status'] ?? 'unpaid',

      createdAt: createdAtRaw is Timestamp
          ? createdAtRaw.toDate()
          : DateTime.now(),

      dueDate: dueDateRaw is Timestamp ? dueDateRaw.toDate() : DateTime.now(),
    );
  }

  InvoiceModel copyWith({String? status, double? amount}) {
    return InvoiceModel(
      id: this.id,
      customerId: this.customerId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: this.createdAt,
      dueDate: this.dueDate,
    );
  }
}
