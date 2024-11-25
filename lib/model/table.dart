// Created by 1 More Code on 10/11/24.

import 'package:flutter/material.dart';

// This class represents a restaurant table with details about its availability, location, capacity, and pricing.
class RestaurantTable {
  final String id; // Unique identifier for the table
  final String restaurantId; // The restaurant ID that the table belongs to
  final String tableNumber; // The table number (e.g., Table 1, Table 2)
  final String tableType; // Type of the table (e.g., indoor, outdoor, booth)
  final int capacity; // The number of people the table can accommodate
  final int advancePrice; // The advance price for reserving the table
  final String location; // The location of the table within the restaurant (e.g., near the window)
  final bool isAvailable; // Indicates if the table is available for booking
  final DateTime createdAt; // Timestamp when the table was created
  final DateTime updatedAt; // Timestamp when the table details were last updated
  final Map<String, dynamic> availability; // Availability schedule for the table (e.g., days and times it’s available)

  // Constructor to initialize all properties of the RestaurantTable
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

  // Converts a RestaurantTable object to a JSON map for Firebase storage
  // This method serializes the object to be saved in a database
  Map<String, dynamic> toJson() => {
    'id': id, // Unique identifier for the table
    'restaurantId': restaurantId, // The restaurant ID the table belongs to
    'tableNumber': tableNumber, // The table number (e.g., Table 1)
    'tableType': tableType, // The type of the table (e.g., booth, window)
    'capacity': capacity, // The table’s capacity (number of people it can seat)
    'advancePrice': advancePrice, // The advance price for reserving the table
    'location': location, // The location of the table inside the restaurant
    'isAvailable': isAvailable, // Availability status of the table (true/false)
    'createdAt': createdAt.toIso8601String(), // Creation timestamp in ISO8601 format
    'updatedAt': updatedAt.toIso8601String(), // Last updated timestamp in ISO8601 format
    'availability': availability, // Availability map containing days and time slots
  };

  // Factory constructor to create a RestaurantTable object from a JSON map
  // This method is used to convert data from a JSON source (e.g., Firebase or REST API) into a Dart object
  factory RestaurantTable.fromJson(Map<String, dynamic> json, String id) {
    return RestaurantTable(
      id: id, // ID of the table
      restaurantId: json['restaurantId'], // Restaurant ID associated with the table
      tableNumber: json['tableNumber'], // Table number (e.g., "Table 1")
      tableType: json['tableType'], // Table type (e.g., "booth")
      capacity: json['capacity'], // Capacity of the table
      advancePrice: json['advance_price'], // Advance price for the table
      location: json['location'], // Location of the table inside the restaurant
      isAvailable: json['isAvailable'], // Whether the table is available or not
      createdAt: DateTime.parse(json['createdAt']), // Parse the creation timestamp
      updatedAt: DateTime.parse(json['updatedAt']), // Parse the last updated timestamp
      availability: Map<String, dynamic>.from(json['availability'] ?? {}), // Availability map for the table, default to empty if not available
    );
  }
}
