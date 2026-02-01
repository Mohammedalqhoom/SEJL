import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final double totalDebt;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalDebt,
    required this.createdAt,
  });
  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    double? totalDebt,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalDebt: totalDebt ?? this.totalDebt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CustomerModel.fromMap(String id, Map<String, dynamic> data) {
    final timestamp = data['created_at'];

    return CustomerModel(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      totalDebt: (data['total_debt'] ?? 0).toDouble(),
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.now(), // fallback آمن
    );
  }

  ///fairstor -------------> coustomar
  // factory CustomerModel.formMap(String id, Map<String, dynamic> data) {
  //   return CustomerModel(
  //     id: id,
  //     name: data['name'] ?? '',
  //     phone: data['phone'] ?? '',
  //     totalDebt: (data['total_debt'] ?? 0).toDouble(),
  //     createdAt: data['create_at'].toDate() ?? DateTime.now(),
  //   );
  // }
  //coustomar -----> firestor
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'total_debt': totalDebt,
      'created_at': createdAt,
    };
  }
}
