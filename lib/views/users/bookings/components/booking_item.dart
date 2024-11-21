//
// Created by 1 More Code on 17/11/24.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/enum.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/model/booking.dart';
import 'package:selectable/provider/booking_provider.dart';
import 'package:selectable/views/users/bookings/components/booking_cancel_button.dart';
import 'package:selectable/views/users/restaurant/restaurant_detail.dart';
import 'package:selectable/views/widgets/custom_chip.dart';

import '../../../widgets/custom_border_container.dart';

class BookingItem extends StatelessWidget {
  final Booking booking;

  const BookingItem({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) => CustomBorderedContainer(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetails(
                              id: booking.restaurantId,
                              title: booking.restaurantName),
                        ));
                  },
                  child: Text(
                    booking.restaurantName,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondary),
                  ),
                )),
                CustomChip(
                  text: booking.status.toUpperCase(),
                  style: TextStyle(
                      color: getStatusColor(booking.status),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                    child: Text("Table No.: ${booking.tableNumber}",
                        style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.secondaryContainer,
                            fontWeight: FontWeight.w500))),
                Text("Capacity: ${booking.tableCapacity.toString()}",
                    style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.secondaryContainer,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                    child: Text("Booking: ${booking.date}",
                        style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.secondaryContainer,
                            fontWeight: FontWeight.w500))),
                Text("Slot: ${booking.timeSlot}",
                    style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.secondaryContainer,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            Divider(
              height: 10,
              thickness: 1,
              color: colorScheme.onSurface,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                        "Created: ${GlobalData.normal.format(DateTime.fromMillisecondsSinceEpoch(booking.createdAt))}",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.secondaryContainer,
                            fontWeight: FontWeight.normal))),
                if (booking.status == BookingStatus.pending.name)
                  BookingCancelButton(
                    booking: booking,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
