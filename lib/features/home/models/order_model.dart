import 'dart:convert';

import 'package:flutter/material.dart';

class Order {
  final int id;
  final String receiptNumber;
  final String customerName;
  final int totalPayment;
  final DateTime date;
  final OrderStatus status;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.receiptNumber,
    required this.customerName,
    required this.totalPayment,
    required this.date,
    required this.status,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id_order'],
      receiptNumber: json['no_struk'],
      customerName: json['nama'],
      totalPayment: json['total_bayar']?.toInt() ?? 0,
      date: DateTime.parse(json['tanggal']),
      status: OrderStatus.fromInt(json['status'] ?? -1),
      items: List<OrderItem>.from(
          json['menu']?.map((x) => OrderItem.fromJson(x)) ?? []),
    );
  }

  String get formattedDate =>
      '${date.day.toString().padLeft(2, '0')} ${_monthToString(date.month)} ${date.year}';

  String _monthToString(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Color get statusColor => status.color;
  String get formattedStatus => status.displayName;
}

class OrderItem {
  final int id;
  final String category;
  final List<String> toppings;
  final String name;
  final String image;
  final int quantity;
  final int price;
  final int total;
  final String notes;

  OrderItem({
    required this.id,
    required this.category,
    required this.toppings,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.total,
    required this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    List<String> toppings = [];
    try {
      if (json['topping'] is String) {
        if (json['topping'].isNotEmpty) {
          final decoded = jsonDecode(json['topping']);
          if (decoded is List) {
            toppings = List<String>.from(decoded.map((x) => x.toString()));
          }
        }
      } else if (json['topping'] is List) {
        toppings = List<String>.from(json['topping'].map((x) => x.toString()));
      }
    } catch (e) {
      toppings = [];
    }

    return OrderItem(
      id: json['id_menu'] ?? 0,
      category: json['kategori']?.toString() ?? '',
      toppings: toppings,
      name: json['nama']?.toString() ?? '',
      image: json['foto']?.toString() ?? '',
      quantity: json['jumlah'] is String
          ? int.tryParse(json['jumlah']) ?? 0
          : json['jumlah']?.toInt() ?? 0,
      price: json['harga'] is String
          ? int.tryParse(json['harga']) ?? 0
          : json['harga']?.toInt() ?? 0,
      total: json['total'] is String
          ? int.tryParse(json['total']) ?? 0
          : json['total']?.toInt() ?? 0,
      notes: json['catatan'] is String
          ? json['catatan'].replaceAll('"', '')
          : json['catatan']?.toString() ?? '',
    );
  }
}

enum OrderStatus {
  inQueue(0, 'Dalam Antrian', Colors.blue),
  preparing(1, 'Sedang Disiapkan', Colors.orange),
  readyForPickup(2, 'Bisa Diambil', Colors.greenAccent),
  completed(3, 'Selesai', Colors.green),
  cancelled(4, 'Dibatalkan', Colors.red),
  unknown(-1, 'Unknown', Colors.black);

  final int value;
  final String displayName;
  final Color color;

  const OrderStatus(this.value, this.displayName, this.color);

  factory OrderStatus.fromInt(int value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatus.unknown,
    );
  }
}
