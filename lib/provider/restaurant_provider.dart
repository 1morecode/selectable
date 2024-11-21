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

class RestaurantProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Restaurant> _restaurants = [];
  Restaurant? _currentRestaurant;

  List<Restaurant> get restaurants => _restaurants;

  Restaurant? get currentRestaurant => _currentRestaurant;

  updateCurrentRestaurant(Restaurant? restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();
  }

  Future<void> fetchRestaurants() async {
    if (restaurants.isNotEmpty) {
      return;
    }

    try {
      // Fetch the restaurants collection from Firestore
      final restaurantCollection =
          await _firestore.collection('restaurants').get();

      // Map the data into a list of restaurant objects
      _restaurants = restaurantCollection.docs.map((doc) {
        return Restaurant.fromJson(doc.data(), doc.id);
      }).toList();

      notifyListeners(); // Notify listeners when restaurants are fetched
    } catch (e) {
      print('Failed to fetch restaurants: $e');
      throw Exception("Failed to fetch restaurants from Firestore");
    }
  }

  // Fetch Single Restaurant
  Future<Restaurant?> fetchRestaurant(id) async {
    try {
      // Fetch the restaurants collection from Firestore
      final doc = await _firestore.collection('restaurants').doc(id).get();

      // Map the data into a list of restaurant objects
      if (doc.exists && doc.data() != null) {
        updateCurrentRestaurant(Restaurant.fromJson(doc.data()!, doc.id));
        notifyListeners();
        return currentRestaurant;
      }
    } catch (e) {
      print('Failed to fetch restaurants: $e');
      // throw Exception("Failed to fetch restaurants from Firestore");
    }
    return null;
  }

  // Book Table
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

  onSelectDate(DateTime date) {
    if (selectedDate != date) {
      dateController.text = GlobalData.format.format(date);
      selectedDate = date;

      // Get the day of the week from the date
      selectedDay = daysList[date.weekday - 1];

      // Get a copy of the slots for the selected day to avoid modifying the original list
      slotsList = List<String>.from(availability!.availability[selectedDay] ?? []);

      // Filter slots if the selected date is today
      if (DateFormat('yyyy-MM-dd').format(selectedDate!) == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        DateTime now = DateTime.now();
        String currentTime = DateFormat('HH:mm').format(now);

        // Only keep future slots
        slotsList = slotsList.where((slot) {
          String startTime = slot.split('-').first;
          return startTime.compareTo(currentTime) > 0;
        }).toList();
      }

      // Logging to help debug
      logger.i(availability!.availability[selectedDay]);
      logger.i(selectedDay);

      // Reset selections
      selectedSlot = null;
      selectedTable = null;

      // Notify listeners to update the UI
      notifyListeners();
    }
  }


  onSelectSlot(String slot) {
    if (selectedSlot != slot) {
      selectedSlot = slot;
      selectedTable = null;
      notifyListeners();
      fetchBookings();
    }
  }

  onSelectTable(RestaurantTable table) {
    selectedTable = table;
    notifyListeners();
  }

  fetchTables(String id) async {
    try {
      // Fetch the restaurants collection from Firestore
      final tableCollection = await _firestore
          .collection('tables')
          .where('restaurantId', isEqualTo: id)
          .where('isAvailable', isEqualTo: true)
          .get();

      // Map the data into a list of restaurant objects
      tableList = tableCollection.docs.map((doc) {
        return RestaurantTable.fromJson(doc.data(), doc.id);
      }).toList();

      logger.e(tableList);

      notifyListeners(); // Notify listeners when restaurants are fetched
    } catch (e) {
      print('Failed to fetch table: $e');
      throw Exception("Failed to fetch tables from Firestore");
    }
  }

// Function to fetch bookings based on filters
  fetchBookings() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings') // Replace with your collection name
          .where('restaurantId', isEqualTo: currentRestaurant!.id)
          .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate!))
          .where('timeSlot', isEqualTo: selectedSlot)
          .get();

      // Convert each document to a Booking object
      bookings = querySnapshot.docs.map((doc) {
        return Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      logger.e("Bookings List: ${bookings.length}");
      notifyListeners();
    } catch (e) {
      print('Error fetching bookings: $e');
      bookings = [];
    }
  }

  bool isTableBooked(String tableId) {
    return bookings.any((booking) => booking.tableId == tableId);
  }

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
      // Reference to the Firestore 'bookings' collection
      CollectionReference bookings =
          FirebaseFirestore.instance.collection('bookings');

      // Add a new document to the 'bookings' collection with the booking data
      bookings.add(data).then(
        (value) {
          successAlert(text: "Table Booked Successfully");
          print("Table Booked successfully");
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(globalContext()).pop();
            Navigator.of(globalContext()).pop();
          },);
        },
      );
    } catch (e) {
      errorAlert(text: "Failed to save booking:");
      print("Failed to save booking: $e");
    }
  }

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
