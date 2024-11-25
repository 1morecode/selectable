import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selectable/helper/alerts.dart';
import 'package:selectable/main.dart';
import 'package:selectable/model/restaurant.dart';

import '../../helper/global_data.dart';
import '../../helper/shared_preferences_helper.dart';
import '../../model/booking.dart';
import '../../model/table.dart';

class ARestaurantProvider extends ChangeNotifier {
  // Firebase Firestore instance to interact with the database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to hold all restaurants and a current restaurant to be selected
  List<Restaurant> _restaurants = [];
  Restaurant? _currentRestaurant;

  // Getter to fetch the list of restaurants
  List<Restaurant> get restaurants => _restaurants;

  // Getter to fetch the current selected restaurant
  Restaurant? get currentRestaurant => _currentRestaurant;

  // Method to update the current selected restaurant
  updateCurrentRestaurant(Restaurant? restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();  // Notify listeners after updating the current restaurant
  }

  // Fetch all restaurants from Firestore
  Future<void> fetchRestaurants() async {
    if (restaurants.isNotEmpty) {
      return; // If restaurants are already fetched, don't fetch again
    }

    try {
      // Fetch restaurants from Firestore based on the logged-in user's UID
      final restaurantCollection = await _firestore
          .collection('restaurants')
          .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Map the fetched documents to a list of Restaurant objects
      _restaurants = restaurantCollection.docs.map((doc) {
        return Restaurant.fromJson(doc.data(), doc.id);
      }).toList();

      notifyListeners();  // Notify listeners when restaurants are fetched
    } catch (e) {
      print('Failed to fetch restaurants: $e');
      throw Exception("Failed to fetch restaurants from Firestore");
    }
  }

  // Fetch a single restaurant by its ID
  Future<Restaurant?> fetchRestaurant(id) async {
    try {
      final doc = await _firestore.collection('restaurants').doc(id).get();

      if (doc.exists && doc.data() != null) {
        // If the restaurant exists, update the current restaurant
        updateCurrentRestaurant(Restaurant.fromJson(doc.data()!, doc.id));
        notifyListeners();  // Notify listeners when the current restaurant is fetched
        return currentRestaurant;
      }
    } catch (e) {
      print('Failed to fetch restaurant: $e');
    }
    return null;
  }

  // Table-related fields and methods
  TextEditingController tableNumberController = TextEditingController();
  TextEditingController tableTypeController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  bool isTableAvailable = true;
  List<RestaurantTable> _tables = [];

  // Getter to fetch the list of tables for the current restaurant
  List<RestaurantTable> get tables => _tables;

  // Method to update table availability
  updateIsTableAvailable(bool status) {
    isTableAvailable = status;
    notifyListeners();  // Notify listeners when the table availability status is updated
  }

  // Fetch all tables for a specific restaurant from Firestore
  Future<void> fetchTables(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection('tables')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      // Map the fetched documents to a list of RestaurantTable objects
      _tables = snapshot.docs
          .map((doc) => RestaurantTable.fromJson(doc.data(), doc.id))
          .toList();
      logger.e(_tables.length);  // Log the number of tables fetched

      notifyListeners();  // Notify listeners when tables are fetched
    } catch (e) {
      print('Failed to fetch tables: $e');
      _tables = [];  // Reset the tables list on failure
      throw Exception("Failed to fetch tables from Firestore");
    }
  }

  // Add a new table to Firestore
  Future<bool> addTable(String restaurantId) async {
    try {
      if (isTableValid()) {
        // Query to check if the table number already exists for the restaurant
        final querySnapshot = await _firestore
            .collection('tables')
            .where('restaurantId', isEqualTo: restaurantId)
            .where('tableNumber', isEqualTo: tableNumberController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If the table number already exists, show an error alert
          errorAlert(
              text:
              'Table number ${tableNumberController.text} already exists for this restaurant.');
        } else {
          // Add a new table document to Firestore
          await _firestore.collection('tables').add({
            "restaurantId": restaurantId,
            "tableNumber": tableNumberController.text,
            "tableType": tableTypeController.text,
            "capacity": int.parse(capacityController.text),
            "location": locationController.text,
            "advance_price": int.parse(advanceController.text),
            "isAvailable": isTableAvailable,
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "availability": {}
          });
          successAlert(text: "Table Added Successfully");
          fetchTables(restaurantId);  // Fetch updated list of tables
          clearForm();  // Clear the form inputs
          notifyListeners();  // Notify listeners after adding a table
          return true;
        }
      }
    } catch (e) {
      errorAlert(text: "Failed to add table!");
      logger.e(e);  // Log error if adding table fails
    }
    return false;
  }

  // Update an existing table in Firestore
  Future<bool> updateTable(RestaurantTable table) async {
    try {
      if (isTableValid()) {
        // Check if the table number already exists for this restaurant
        final querySnapshot = await _firestore
            .collection('tables')
            .where('restaurantId', isEqualTo: table.restaurantId)
            .where('tableNumber', isEqualTo: tableNumberController.text)
            .get();

        bool tableNumberExists =
        querySnapshot.docs.any((doc) => doc.id != table.id);

        if (tableNumberExists) {
          errorAlert(
            text:
            'Table number ${tableNumberController.text} already exists for this restaurant.',
          );
        } else {
          // Update the table document in Firestore
          await _firestore.collection('tables').doc(table.id).update({
            "restaurantId": table.restaurantId,
            "tableNumber": tableNumberController.text,
            "tableType": tableTypeController.text,
            "capacity": int.parse(capacityController.text),
            "location": locationController.text,
            "advance_price": int.parse(advanceController.text),
            "isAvailable": isTableAvailable,
            "updatedAt": DateTime.now().toIso8601String(),
          });
          successAlert(text: "Table Updated Successfully");
          fetchTables(table.restaurantId);  // Fetch updated list of tables
          clearForm();  // Clear the form inputs
          notifyListeners();  // Notify listeners after updating a table
          return true;
        }
      }
    } catch (e) {
      errorAlert(text: "Failed to update table!");
      logger.e(e);  // Log error if updating table fails
    }
    return false;
  }

  // Initialize table form with existing table data for editing
  initTable(RestaurantTable table) {
    tableNumberController.text = table.tableNumber;
    tableTypeController.text = table.tableType;
    locationController.text = table.location;
    advanceController.text = table.advancePrice.toString();
    capacityController.text = table.capacity.toString();
    isTableAvailable = table.isAvailable;
    notifyListeners();  // Notify listeners after initializing the form
  }

  // Validate the table form inputs before adding or updating a table
  isTableValid() {
    if (tableNumberController.text.isEmpty) {
      errorAlert(text: "Enter table number");
      return false;
    }
    if (tableTypeController.text.isEmpty) {
      errorAlert(text: "Select table type");
      return false;
    }
    if (capacityController.text.isEmpty) {
      errorAlert(text: "Select table capacity");
      return false;
    }
    if (locationController.text.isEmpty) {
      errorAlert(text: "Enter Table Location");
      return false;
    }
    if (advanceController.text.isEmpty) {
      errorAlert(text: "Enter Advance Price");
      return false;
    }
    return true;
  }

  // Clear the table form inputs after adding or updating a table
  void clearForm() {
    tableNumberController.clear();
    tableTypeController.clear();
    capacityController.clear();
    locationController.clear();
    isTableAvailable = true;  // Reset availability to true by default
    notifyListeners();  // Notify listeners after clearing the form
  }

  /// Booking table-related properties and methods.
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  List<String> daysList = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];
  List<String> slotsList = [];
  String? selectedDay;
  String? selectedSlot;
  RestaurantTable? selectedTable;
  List<Booking> bookings = [];
  Availability? availability;

  /// Handles date selection for booking.
  onSelectDate(DateTime date) {
    if (selectedDate != date) {
      dateController.text = GlobalData.format.format(date);
      selectedDate = date;

      // Map date to the corresponding day of the week.
      selectedDay = daysList[date.weekday - 1];

      // Fetch availability slots for the selected day.
      slotsList = List<String>.from(availability!.availability[selectedDay] ?? []);

      // Filter slots to exclude past times if the selected date is today.
      if (DateFormat('yyyy-MM-dd').format(selectedDate!) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        DateTime now = DateTime.now();
        String currentTime = DateFormat('HH:mm').format(now);

        slotsList = slotsList.where((slot) {
          String startTime = slot.split('-').first;
          return startTime.compareTo(currentTime) > 0;
        }).toList();
      }

      // Reset selections and notify listeners.
      selectedSlot = null;
      selectedTable = null;
      notifyListeners();
    }
  }

  /// Handles time slot selection.
  onSelectSlot(String slot) {
    if (selectedSlot != slot) {
      selectedSlot = slot;
      selectedTable = null;
      notifyListeners();
      fetchBookings(); // Fetch bookings for the selected slot.
    }
  }

  /// Handles table selection.
  onSelectTable(RestaurantTable table) {
    selectedTable = table;
    notifyListeners();
  }

  /// Fetches bookings for the selected restaurant, date, and slot.
  fetchBookings() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('restaurantId', isEqualTo: currentRestaurant!.id)
          .where('date',
          isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate!))
          .where('timeSlot', isEqualTo: selectedSlot)
          .get();

      bookings = querySnapshot.docs.map((doc) {
        return Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching bookings: $e');
      bookings = [];
    }
  }

  /// Checks if a specific table is already booked.
  bool isTableBooked(String tableId) {
    return bookings.any((booking) => booking.tableId == tableId);
  }

  /// Clears all booking-related data.
  clearTableData() {
    dateController.clear();
    availability = null;
    selectedDate = null;
    slotsList.clear();
    selectedDay = null;
    selectedSlot = null;
    selectedTable = null;
    bookings.clear();
    notifyListeners();
  }

}
