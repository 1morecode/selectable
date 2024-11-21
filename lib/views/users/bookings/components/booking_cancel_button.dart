//
// Created by 1 More Code on 17/11/24.
//

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/enum.dart';
import 'package:selectable/model/booking.dart';
import 'package:selectable/provider/booking_provider.dart';

import '../../../../helper/alerts.dart';

class BookingCancelButton extends StatelessWidget {
  final Booking booking;

  const BookingCancelButton({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) => DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: const Icon(Icons.more_vert),
          items: [
            ...['Cancel Booking'].map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
            )
          ],
          onChanged: (value) {
            if (value == 'Cancel Booking') {
              customCupertinoAlert(
                  title: Text(
                    "Warning",
                    style: TextStyle(color: colorScheme.error),
                  ),
                  content: "Do you really want to cancel this booking?",
                  onPressed: () {
                    bookingProvider.updateBooking(
                        {"status": BookingStatus.cancelled.name}, booking.id);
                  });
            }
          },
          dropdownStyleData: DropdownStyleData(
            width: 200,
            elevation: 1,
            padding: const EdgeInsets.symmetric(vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: colorScheme.onPrimary,
            ),
            offset: const Offset(-180, 0),
          ),
          menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.only(left: 16, right: 16), height: 40),
        ),
      ),
    );
  }
}
