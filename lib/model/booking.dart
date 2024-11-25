// Created by 1 More Code on 13/11/24.

// This class represents a booking object with its relevant details.
class Booking {
  final String id; // Unique identifier for the booking
  final String restaurantId; // ID of the restaurant where the booking is made
  final String restaurantName; // Name of the restaurant
  final String tableId; // ID of the table booked
  final String tableNumber; // Table number in the restaurant
  final int tableCapacity; // The number of people the table can accommodate
  final String userId; // ID of the user who made the booking
  final String ownerId; // ID of the restaurant owner
  final String date; // The date of the booking
  final String timeSlot; // The time slot for the booking
  final String status; // Status of the booking (e.g., confirmed, cancelled, etc.)
  final int createdAt; // Timestamp of when the booking was created
  final int updatedAt; // Timestamp of when the booking was last updated
  final double paidAmount; // Amount paid for the booking
  final String email; // User's email address
  final String phone; // User's phone number
  final String name; // User's name

  // Constructor to initialize all fields
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

  // Factory method to create a Booking object from JSON data
  factory Booking.fromJson(Map<String, dynamic> json, String id) {
    return Booking(
      id: id, // Assign the provided ID
      restaurantName: json['restaurantName'], // Extract restaurant name
      restaurantId: json['restaurantId'], // Extract restaurant ID
      tableId: json['tableId'], // Extract table ID
      tableNumber: json['tableNumber'], // Extract table number
      tableCapacity: json['tableCapacity'], // Extract table capacity
      userId: json['userId'], // Extract user ID
      ownerId: json['ownerId'], // Extract owner ID
      date: json['date'], // Extract booking date
      timeSlot: json['timeSlot'], // Extract time slot
      status: json['status'], // Extract booking status
      createdAt: json['createdAt'], // Extract creation timestamp
      updatedAt: json['updatedAt'], // Extract update timestamp
      paidAmount: (json['paid_amount'] as num).toDouble(), // Extract and convert paid amount
      email: json['email'], // Extract user's email
      phone: json['phone'], // Extract user's phone number
      name: json['name'], // Extract user's name
    );
  }

  // Method to convert a Booking object back into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include booking ID
      'restaurantId': restaurantId, // Include restaurant ID
      'restaurantName': restaurantName, // Include restaurant name
      'tableId': tableId, // Include table ID
      'tableNumber': tableNumber, // Include table number
      'tableCapacity': tableCapacity, // Include table capacity
      'userId': userId, // Include user ID
      'ownerId': ownerId, // Include owner ID
      'date': date, // Include booking date
      'timeSlot': timeSlot, // Include time slot
      'status': status, // Include booking status
      'createdAt': createdAt, // Include creation timestamp
      'updatedAt': updatedAt, // Include update timestamp
      'paid_amount': paidAmount, // Include paid amount
      'email': email, // Include user's email
      'phone': phone, // Include user's phone number
      'name': name, // Include user's name
    };
  }
}
