//
// Created by 1 More Code on 09/11/24.
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/alerts.dart';
import '../../helper/shared_preferences_helper.dart';
import '../../main.dart';
import '../../model/booking.dart';

class ABookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Booking> bookings = [];
  String? restId;

  clearBooking(String? rId) {
    bookings.clear();
    restId = rId;
    notifyListeners();
  }

  fetchBookings() async {
    try {
      late QuerySnapshot querySnapshot;
      if(restId != null) {
        querySnapshot = await _firestore
            .collection('bookings') // Replace with your collection name
            .where('restaurantId', isEqualTo: restId)
            .get();
      }else{
        querySnapshot = await _firestore
            .collection('bookings') // Replace with your collection name
            .where('ownerId', isEqualTo: PreferencesHelper.getUser()['uid'])
            .get();
      }

      // Convert each document to a Booking object
      bookings = querySnapshot.docs.map((doc) {
        return Booking.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
      logger.e("Bookings List: ${bookings.length}");
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
      logger.e("Booking Updated");
      fetchBookings();
    } catch (e) {
      successAlert(text: "Failed to Update");
      print('Error updating booking: $e');
    }
    notifyListeners();
  }

  List<Booking> getListByStatus(String status, List<Booking> bookingList) {
    try {
      // If 'all' is passed as status, return the entire bookings list
      List<Booking> filteredBookings = status == 'all'
          ? bookingList
          : bookingList.where((booking) {
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

  List<Booking> getListByTable(String tableId, List<Booking> bookingList) {
    try {
      List<Booking> filteredBookings = bookingList.where((booking) {
        return booking.tableId == tableId;  // Assuming 'status' is a field in the Booking object
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

      logger.e("Filtered and Sorted Bookings List: ${filteredBookings.length}");
      return filteredBookings;
    } catch (e) {
      print('Error filtering and sorting bookings by status: $e');
      return [];
    }
  }

  DateTime _parseTimeSlot(String timeSlot) {
    // Extract the start time (before the '-') from the timeSlot
    String startTime = timeSlot.split('-').first;

    // Parse the time into a DateTime object (using today's date for consistency)
    List<String> parts = startTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return DateTime(2000, 1, 1, hour, minute); // Arbitrary date, only time matters
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try{
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data() as Map<String, dynamic>;
      }
      notifyListeners();
    }catch(e) {
      logger.e(e);
    }
    return null;
  }


}