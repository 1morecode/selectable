//
// Created by 1 More Code on 13/11/24.
//

class Booking {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String tableId;
  final String tableNumber;
  final int tableCapacity;
  final String userId;
  final String ownerId;
  final String date;
  final String timeSlot;
  final String status;
  final int createdAt;
  final int updatedAt;
  final double paidAmount;
  final String email;
  final String phone;
  final String name;

  Booking({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.tableId,
    required this.tableNumber,
    required this.tableCapacity,
    required this.userId,
    required this.ownerId,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.paidAmount,
    required this.email,
    required this.phone,
    required this.name,
  });

  // Convert JSON to Booking object
  factory Booking.fromJson(Map<String, dynamic> json, String id) {
    return Booking(
      id: id,
      restaurantName: json['restaurantName'],
      restaurantId: json['restaurantId'],
      tableId: json['tableId'],
      tableNumber: json['tableNumber'],
      tableCapacity: json['tableCapacity'],
      userId: json['userId'],
      ownerId: json['ownerId'],
      date: json['date'],
      timeSlot: json['timeSlot'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      paidAmount: (json['paid_amount'] as num).toDouble(),
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
    );
  }

  // Convert Booking object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'tableId': tableId,
      'tableNumber': tableNumber,
      'tableCapacity': tableCapacity,
      'userId': userId,
      'ownerId': ownerId,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'paid_amount': paidAmount,
      'email': email,
      'phone': phone,
      'name': name,
    };
  }
}
