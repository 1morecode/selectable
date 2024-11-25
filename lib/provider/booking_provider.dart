//
// Created by 1 More Code on 09/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selectable/helper/alerts.dart';
import 'package:selectable/helper/shared_preferences_helper.dart';
import 'package:selectable/model/booking.dart';

import '../main.dart';

class BookingProvider extends ChangeNotifier {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to store booking data
  List<Booking> bookings = [];

  // Clears all bookings from the list
  void clearBookings() {
    bookings.clear(); // Empty the bookings list
    notifyListeners(); // Notify UI about the change
  }

  // Fetches bookings from Firestore for the current user
  Future<void> fetchBookings() async {
    try {
      // Get user ID from preferences and fetch related bookings
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings') // Replace with your collection name
          .where('userId', isEqualTo: PreferencesHelper.getUser()['uid'])
          .get();

      // Convert Firestore documents to Booking objects
      bookings = querySnapshot.docs.map((doc) {
        return Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Log the size of the bookings list
      logger.e("Bookings List: ${bookings.length}");

      notifyListeners(); // Notify UI about the updated bookings list
    } catch (e) {
      // Handle errors while fetching bookings
      print('Error fetching bookings: $e');
    }
    notifyListeners();
  }

  // Updates a booking in Firestore with the provided data
  Future<void> updateBooking(Map<String, dynamic> data, String id) async {
    try {
      // Update the booking document in Firestore
      await _firestore.collection('bookings').doc(id).update(data);

      // Show success message to the user
      successAlert(text: "Updated Successfully");

      // Refresh the bookings list after the update
      fetchBookings();
    } catch (e) {
      // Show error message if the update fails
      successAlert(text: "Failed to Update");
    }
    notifyListeners(); // Notify UI about potential changes
  }

  // Filters and sorts bookings by status
  List<Booking> getListByStatus(String status) {
    try {
      // If status is 'all', return the entire bookings list
      List<Booking> filteredBookings = status == 'all'
          ? bookings
          : bookings.where((booking) {
        // Filter bookings by the given status
        return booking.status == status; // Assuming 'status' is a field in the Booking object
      }).toList();

      // Sort the filtered bookings by the 'createdAt' field in descending order
      filteredBookings.sort((a, b) {
        // Assuming 'createdAt' is a DateTime object; adjust if it's in a different format
        return b.createdAt.compareTo(a.createdAt); // Sort latest first
      });

      return filteredBookings; // Return the sorted and filtered bookings list
    } catch (e) {
      // Handle errors during filtering or sorting
      print('Error filtering and sorting bookings by status: $e');
      return [];
    }
  }
}
