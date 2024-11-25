//
// Created by 1 More Code on 09/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/alerts.dart';
import '../../helper/shared_preferences_helper.dart';
import '../../main.dart';
import '../../model/booking.dart';

/// A provider for handling bookings related to a restaurant or user.
class ABookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance for database interaction
  List<Booking> bookings = []; // List to store booking objects
  String? restId; // Restaurant ID for filtering bookings

  /// Clears the current booking list and sets the restaurant ID for filtering.
  clearBooking(String? rId) {
    bookings.clear(); // Clears the list of bookings
    restId = rId; // Sets the restaurant ID
    notifyListeners(); // Notify listeners about the change
  }

  /// Fetches bookings from Firestore either by restaurant ID or owner ID.
  fetchBookings() async {
    try {
      late QuerySnapshot querySnapshot;
      // Fetch bookings based on restaurant ID or owner ID
      if(restId != null) {
        querySnapshot = await _firestore
            .collection('bookings') // Query the bookings collection
            .where('restaurantId', isEqualTo: restId) // Filter by restaurant ID
            .get();
      }else{
        querySnapshot = await _firestore
            .collection('bookings') // Query the bookings collection
            .where('ownerId', isEqualTo: PreferencesHelper.getUser()['uid']) // Filter by owner ID from preferences
            .get();
      }

      // Convert each document to a Booking object
      bookings = querySnapshot.docs.map((doc) {
        return Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id); // Create Booking object from Firestore document
      }).toList();
      notifyListeners(); // Notify listeners about the updated bookings list
      logger.e("Bookings List: ${bookings.length}"); // Log the length of the bookings list
    } catch (e) {
      print('Error fetching bookings: $e'); // Error handling
    }
    notifyListeners(); // Notify listeners in case of an error as well
  }

  /// Updates the booking data in Firestore by its ID.
  updateBooking(Map<String, dynamic> data, String id) async {
    try {
      await _firestore
          .collection('bookings') // Reference the bookings collection
          .doc(id) // Document ID to update
          .update(data); // Update the booking data
      successAlert(text: "Updated Successfully"); // Show success alert
      logger.e("Booking Updated"); // Log the booking update
      fetchBookings(); // Re-fetch bookings after update
    } catch (e) {
      successAlert(text: "Failed to Update"); // Show error alert
      print('Error updating booking: $e'); // Error handling
    }
    notifyListeners(); // Notify listeners about the update
  }

  /// Filters the bookings list by status and sorts them by creation date.
  List<Booking> getListByStatus(String status, List<Booking> bookingList) {
    try {
      // If 'all' is passed as status, return the entire bookings list
      List<Booking> filteredBookings = status == 'all'
          ? bookingList
          : bookingList.where((booking) {
        return booking.status == status;  // Filter by status
      }).toList();

      // Sort the filtered bookings by 'createdAt' field in descending order
      filteredBookings.sort((a, b) {
        // Assuming 'createdAt' is a DateTime object
        return b.createdAt.compareTo(a.createdAt); // Sort by descending order (latest first)
      });

      return filteredBookings; // Return the filtered and sorted bookings list
    } catch (e) {
      print('Error filtering and sorting bookings by status: $e'); // Error handling
      return [];
    }
  }

  /// Filters the bookings list by table ID and sorts by date and time.
  List<Booking> getListByTable(String tableId, List<Booking> bookingList) {
    try {
      List<Booking> filteredBookings = bookingList.where((booking) {
        return booking.tableId == tableId;  // Filter by table ID
      }).toList();

      // Sort by date (descending) and then by timeSlot (ascending)
      filteredBookings.sort((a, b) {
        // Compare by date first
        int dateComparison = b.date.compareTo(a.date); // Descending by date
        if (dateComparison != 0) {
          return dateComparison;
        }

        // Parse and compare timeSlot start times
        DateTime startTimeA = _parseTimeSlot(a.timeSlot);
        DateTime startTimeB = _parseTimeSlot(b.timeSlot);
        return startTimeA.compareTo(startTimeB); // Ascending by timeSlot
      });

      logger.e("Filtered and Sorted Bookings List: ${filteredBookings.length}"); // Log the length of the filtered and sorted list
      return filteredBookings; // Return the filtered and sorted bookings list
    } catch (e) {
      print('Error filtering and sorting bookings by status: $e'); // Error handling
      return [];
    }
  }

  /// Helper method to parse the timeSlot string into a DateTime object.
  DateTime _parseTimeSlot(String timeSlot) {
    // Extract the start time (before the '-') from the timeSlot
    String startTime = timeSlot.split('-').first;

    // Parse the time into a DateTime object (using today's date for consistency)
    List<String> parts = startTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return DateTime(2000, 1, 1, hour, minute); // Arbitrary date, only time matters
  }

  /// Fetches user details from Firestore by user ID.
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users') // Reference the users collection
          .doc(uid) // User document ID
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data() as Map<String, dynamic>; // Return user data as a map
      }
      notifyListeners(); // Notify listeners if no user found
    } catch (e) {
      logger.e(e); // Log any errors
    }
    return null; // Return null if user not found
  }
}
