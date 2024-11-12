//
// Created by 1 More Code on 10/11/24.
//

import 'package:flutter/material.dart';

class RestaurantTable {
  final String id;
  final String restaurantId;
  final String tableNumber;
  final String tableType;
  final int capacity;
  final int advancePrice;
  final String location;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> availability;

  RestaurantTable({
    required this.id,
    required this.restaurantId,
    required this.tableNumber,
    required this.tableType,
    required this.capacity,
    required this.advancePrice,
    required this.location,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.availability,
  });

  // Converts a Table object to JSON format for Firebase storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurantId': restaurantId,
    'tableNumber': tableNumber,
    'tableType': tableType,
    'capacity': capacity,
    'advancePrice': advancePrice,
    'location': location,
    'isAvailable': isAvailable,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'availability': availability,
  };

  // Factory constructor to create a Table object from JSON data
  factory RestaurantTable.fromJson(Map<String, dynamic> json, String id) {
    return RestaurantTable(
      id: id,
      restaurantId: json['restaurantId'],
      tableNumber: json['tableNumber'],
      tableType: json['tableType'],
      capacity: json['capacity'],
      advancePrice: json['advance_price'],
      location: json['location'],
      isAvailable: json['isAvailable'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      availability: Map<String, dynamic>.from(json['availability'] ?? {}),
    );
  }
}
