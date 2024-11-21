import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/admin/a_booking_provider.dart';
import 'package:selectable/views/admin/bookings/components/a_booking_item.dart';

class ABookings extends StatefulWidget {
  const ABookings({super.key});

  @override
  State<ABookings> createState() => _ABookingsState();
}

class _ABookingsState extends State<ABookings> {
  @override
  void initState() {
    super.initState();
    var bookingProvider = Provider.of<ABookingProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookingProvider.clearBooking(null);
      bookingProvider.fetchBookings();
    });
  }

  final List<String> tabsList = [
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
    return Consumer<ABookingProvider>(
      builder: (context, bookingProvider, child) => DefaultTabController(
        length: tabsList.length,
        child: Column(
          children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              tabs: tabsList.map((status) => Tab(text: status)).toList(),
              isScrollable: true,
              unselectedLabelColor: colorScheme.secondaryContainer,
              labelColor: colorScheme.onSecondary,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: colorScheme.onSurface,
            ),
            Expanded(
              child: TabBarView(
                children: tabsList.map((status) {
                  // Filtered list for the current tab
                  final filteredBookings = bookingProvider
                      .getListByStatus(status.toLowerCase(), bookingProvider.bookings);

                  if (filteredBookings.isEmpty) {
                    return Center(
                      child: Text(
                        "No bookings available",
                        style: TextStyle(color: colorScheme.onBackground),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: ListView.builder(
                      itemCount: bookingProvider
                          .getListByStatus(status.toLowerCase(), bookingProvider.bookings).length,
                      itemBuilder: (context, index) {
                        final booking = bookingProvider
                            .getListByStatus(status.toLowerCase(), bookingProvider.bookings)[index];
                        return ABookingItem(booking: booking);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
