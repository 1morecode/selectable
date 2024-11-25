//
// Created by 1 More Code on 09/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selectable/helper/alerts.dart';
import 'package:selectable/helper/enum.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/helper/shared_preferences_helper.dart';
import 'package:selectable/main.dart';
import 'package:selectable/model/table.dart';

import '../model/booking.dart';
import '../model/restaurant.dart';

/// Provider to manage restaurant-related operations.
class RestaurantProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// List of all restaurants.
  List<Restaurant> _restaurants = [];
  Restaurant? _currentRestaurant; // Currently selected restaurant.

  /// Getters for accessing private variables.
  List<Restaurant> get restaurants => _restaurants;
  Restaurant? get currentRestaurant => _currentRestaurant;

  /// Updates the currently selected restaurant and notifies listeners.
  updateCurrentRestaurant(Restaurant? restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();
  }

  /// Fetches all restaurants from Firestore.
  Future<void> fetchRestaurants() async {
    // Avoid unnecessary re-fetching.
    if (restaurants.isNotEmpty) {
      return;
    }

    try {
      // Fetch restaurant documents.
      final restaurantCollection =
      await _firestore.collection('restaurants').get();

      // Convert documents to Restaurant objects.
      _restaurants = restaurantCollection.docs.map((doc) {
        return Restaurant.fromJson(doc.data(), doc.id);
      }).toList();

      notifyListeners(); // Notify listeners about the update.
    } catch (e) {
      print('Failed to fetch restaurants: $e');
      throw Exception("Failed to fetch restaurants from Firestore");
    }
  }

  /// Fetches a single restaurant by its ID.
  Future<Restaurant?> fetchRestaurant(id) async {
    try {
      final doc = await _firestore.collection('restaurants').doc(id).get();
      if (doc.exists && doc.data() != null) {
        updateCurrentRestaurant(Restaurant.fromJson(doc.data()!, doc.id));
        notifyListeners();
        return currentRestaurant;
      }
    } catch (e) {
      print('Failed to fetch restaurant: $e');
    }
    return null;
  }

  /// Booking table-related properties and methods.
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
  List<RestaurantTable> tableList = [];
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

  /// Fetches available tables for a specific restaurant.
  fetchTables(String id) async {
    try {
      final tableCollection = await _firestore
          .collection('tables')
          .where('restaurantId', isEqualTo: id)
          .where('isAvailable', isEqualTo: true)
          .get();

      tableList = tableCollection.docs.map((doc) {
        return RestaurantTable.fromJson(doc.data(), doc.id);
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Failed to fetch tables: $e');
      throw Exception("Failed to fetch tables from Firestore");
    }
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

  /// Submits a new booking to Firestore.
  checkout() {
    var data = {
      'restaurantId': currentRestaurant!.id,
      'restaurantName': currentRestaurant!.name,
      'tableId': selectedTable!.id,
      'tableNumber': selectedTable!.tableNumber,
      'tableCapacity': selectedTable!.capacity,
      'userId': PreferencesHelper.getUser()['uid'],
      'ownerId': currentRestaurant!.ownerId,
      'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'timeSlot': selectedSlot,
      'status': BookingStatus.pending.name,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'paid_amount': selectedTable!.advancePrice,
      'email': PreferencesHelper.getUser()['email'],
      'phone': phoneController.text,
      'name': nameController.text
    };

    try {
      CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');

      bookings.add(data).then((value) {
        successAlert(text: "Table Booked Successfully");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(globalContext()).pop();
          Navigator.of(globalContext()).pop();
        });
      });
    } catch (e) {
      errorAlert(text: "Failed to save booking:");
    }
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
    tableList.clear();
    bookings.clear();
    nameController.clear();
    phoneController.clear();
    notifyListeners();
  }
}
