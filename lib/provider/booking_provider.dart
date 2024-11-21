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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Booking> bookings = [];

  clearBookings() {
    bookings.clear();
    notifyListeners();
  }

  fetchBookings() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings') // Replace with your collection name
          .where('userId', isEqualTo: PreferencesHelper.getUser()['uid'])
          .get();

      // Convert each document to a Booking object
      bookings = querySnapshot.docs.map((doc) {
        return Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      logger.e("Bookings List: ${bookings.length}");
      notifyListeners();
    } catch (e) {
      print('Error fetching bookings: $e');
    }
    notifyListeners();
  }

  updateBooking(Map<String, dynamic> data, String id) async {
    try {
      await _firestore
          .collection('bookings').doc(id).update(data);
      successAlert(text: "Updated Successfully");
      fetchBookings();
    } catch (e) {
      successAlert(text: "Failed to Update");
    }
    notifyListeners();
  }

  List<Booking> getListByStatus(String status) {
    try {
      // If 'all' is passed as status, return the entire bookings list
      List<Booking> filteredBookings = status == 'all'
          ? bookings
          : bookings.where((booking) {
        return booking.status == status;  // Assuming 'status' is a field in the Booking object
      }).toList();

      // Sort the filtered bookings by 'createdAt' field in descending order
      filteredBookings.sort((a, b) {
        // Assuming 'createdAt' is a DateTime object. If it's a timestamp or a different format, adjust accordingly.
        return b.createdAt.compareTo(a.createdAt); // Sort by descending order (latest first)
      });

      return filteredBookings;
    } catch (e) {
      print('Error filtering and sorting bookings by status: $e');
      return [];
    }
  }

}