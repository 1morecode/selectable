//
// Created by 1 More Code on 09/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selectable/helper/alerts.dart';
import 'package:selectable/main.dart';
import 'package:selectable/model/restaurant.dart';

import '../../model/table.dart';

class ARestaurantProvider extends ChangeNotifier {
  // Restaurant Details ========================
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Restaurant> _restaurants = [];
  Restaurant? _currentRestaurant;

  List<Restaurant> get restaurants => _restaurants;

  Restaurant? get currentRestaurant => _currentRestaurant;

  // Update Current Selected Restaurant
  updateCurrentRestaurant(Restaurant? restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();
  }

  // Fetch All Restaurants
  Future<void> fetchRestaurants() async {
    if (restaurants.isNotEmpty) {
      return;
    }

    try {
      // Fetch the restaurants collection from Firestore
      final restaurantCollection = await _firestore
          .collection('restaurants')
          .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

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

  // Restaurant Tables ========================
  TextEditingController tableNumberController = TextEditingController();
  TextEditingController tableTypeController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isTableAvailable = true;
  List<RestaurantTable> _tables = [];

  List<RestaurantTable> get tables => _tables;

  updateIsTableAvailable(bool status) {
    isTableAvailable = status;
    notifyListeners();
  }

  // Fetch tables from Firebase
  Future<void> fetchTables(String restaurantId) async {
    try {
      // Fetch the restaurants collection from Firestore
      final snapshot = await _firestore
          .collection('tables')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      // Map the data into a list of restaurant objects
      _tables = snapshot.docs
          .map((doc) => RestaurantTable.fromJson(doc.data(), doc.id))
          .toList();
      logger.e(_tables.length);

      notifyListeners(); // Notify listeners when restaurants are fetched
    } catch (e) {
      print('Failed to fetch restaurants: $e');
      _tables = [];
      throw Exception("Failed to fetch restaurants from Firestore");
    }
    notifyListeners();
  }

  // Add a new table to Firebase
  Future<bool> addTable(String restaurantId) async {
    try {
      if (isTableValid()) {
        // Query to check if tableNumber already exists for this restaurant
        final querySnapshot = await _firestore
            .collection('tables')
            .where('restaurantId', isEqualTo: restaurantId)
            .where('tableNumber', isEqualTo: tableNumberController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If the table number exists, show an error or handle it
          errorAlert(
              text:
                  'Table number ${tableNumberController.text} already exists for this restaurant.');
          // Show an alert dialog or snack bar to inform the user
        } else {
          await _firestore.collection('tables').add({
            "restaurantId": restaurantId,
            "tableNumber": tableNumberController.text,
            "tableType": tableTypeController.text,
            "capacity": int.parse(capacityController.text),
            "location": locationController.text,
            "isAvailable": isTableAvailable,
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "availability": {}
          });
          successAlert(text: "Table Added Successfully");
          fetchTables(restaurantId);
          clearForm();
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      errorAlert(text: "Failed to add table!");
      logger.e(e);
    }
    return false;
  }

  // Add a new table to Firebase
  Future<bool> updateTable(RestaurantTable table) async {
    try {
      if (isTableValid()) {
        // Query to check if the tableNumber already exists for this restaurant,
        // excluding the current table ID.
        final querySnapshot = await _firestore
            .collection('tables')
            .where('restaurantId', isEqualTo: table.restaurantId)
            .where('tableNumber', isEqualTo: tableNumberController.text)
            .get();

        // Check if any other document has the same tableNumber for this restaurant
        bool tableNumberExists =
            querySnapshot.docs.any((doc) => doc.id != table.id);

        if (tableNumberExists) {
          errorAlert(
            text:
                'Table number ${tableNumberController.text} already exists for this restaurant.',
          );
        } else {
          await _firestore.collection('tables').doc(table.id).update({
            "restaurantId": table.restaurantId,
            "tableNumber": tableNumberController.text,
            "tableType": tableTypeController.text,
            "capacity": int.parse(capacityController.text),
            "location": locationController.text,
            "isAvailable": isTableAvailable,
            "updatedAt": DateTime.now().toIso8601String(), // Update timestamp
          });
          successAlert(text: "Table Updated Successfully");
          fetchTables(table.restaurantId);
          clearForm();
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      errorAlert(text: "Failed to update table!");
      logger.e(e);
    }
    return false;
  }

  initTable(RestaurantTable table) {
    tableNumberController.text = table.tableNumber;
    tableTypeController.text = table.tableType;
    locationController.text = table.location;
    capacityController.text = table.capacity.toString();
    isTableAvailable = table.isAvailable;
    notifyListeners();
  }

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
    return true;
  }

  void clearForm() {
    tableNumberController.clear();
    tableTypeController.clear();
    capacityController.clear();
    locationController.clear();
    isTableAvailable = true;
    notifyListeners();
  }
}
