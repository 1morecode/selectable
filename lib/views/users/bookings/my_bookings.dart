//
// Created by 1 More Code on 21/11/24.
//

import 'package:flutter/material.dart';
import 'package:selectable/views/users/bookings/bookings_page.dart';

class MyBookings extends StatelessWidget {
  const MyBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
      ),
      body: const BookingsPage(),
    );
  }
}
