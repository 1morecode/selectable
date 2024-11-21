//
// Created by 1 More Code on 09/11/24.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/booking_provider.dart';
import 'package:selectable/views/users/bookings/components/booking_item.dart';

import '../../../model/booking.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var restProvider = Provider.of<BookingProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        restProvider.fetchBookings();
      },
    );
  }

  List<String> tabsList = [
    'All',
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
    'Declined'
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) => DefaultTabController(
          length: tabsList.length,
          child: Column(
            children: [
              TabBar(
                tabs: List.generate(
                  tabsList.length,
                  (index) => Tab(
                    text: tabsList[index],
                  ),
                ),
                isScrollable: true,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                unselectedLabelColor: colorScheme.secondaryContainer,
                labelColor: colorScheme.onSecondary,
                indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.start,
                dividerColor: colorScheme.onSurface,
              ),
              Expanded(
                  child: TabBarView(
                      children: List.generate(
                tabsList.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListView.builder(
                    itemCount: bookingProvider
                        .getListByStatus(tabsList[index].toLowerCase())
                        .length,
                    itemBuilder: (context, ii) {
                      Booking booking = bookingProvider
                          .getListByStatus(tabsList[index].toLowerCase())[ii];
                      return BookingItem(booking: booking);
                    },
                  ),
                ),
              )))
            ],
          )),
    );
  }
}
