class PaymentModel {
  final String id;
  final String invoiceId;
  final String ownerId;
  final double amount;
  final String method;
  final DateTime paymentDate;

  PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.ownerId,
    required this.amount,
    required this.method,
    required this.paymentDate,
  });

  factory PaymentModel.fromMap(String id, Map<String, dynamic> data) {
    return PaymentModel(
      id: id,
      invoiceId: data['invoice_id'],
      ownerId: data['owner_id'],
      amount: (data['amount'] ?? 0).toDouble(),
      method: data['method'] ?? 'cash',
      paymentDate: data['payment_date']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice_id': invoiceId,
      'owner_id': ownerId,
      'amount': amount,
      'method': method,
      'payment_date': paymentDate,
    };
  }
}
