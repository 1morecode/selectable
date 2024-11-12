//
// Created by 1 More Code on 09/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/main.dart';
import 'package:selectable/model/table.dart';

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
  TextEditingController dateController = TextEditingController();

  onSelectDate(DateTime date, Restaurant rest) {
    if (selectedDate != date) {
      dateController.text = GlobalData.format.format(date);
      selectedDate = date;
      logger.e(daysList.length);
      logger.e(date.weekday);
      selectedDay = daysList[date.weekday - 1];
      slotsList = rest.availability.availability[selectedDay] ?? [];
      logger.i(selectedDay);
      selectedSlot = null;
      notifyListeners();
    }
  }

  onSelectSlot(String slot) {
    if (selectedSlot != slot) {
      selectedSlot = slot;
      notifyListeners();
    }
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

  clearTableData() {
    dateController.clear();
    selectedDate = null;
    slotsList.clear();
    selectedDay = null;
    selectedSlot = null;
    tableList.clear();
    notifyListeners();
  }
}
