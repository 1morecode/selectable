//
// Created by 1 More Code on 17/11/24.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/enum.dart';
import 'package:selectable/model/booking.dart';
import 'package:selectable/provider/booking_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/alerts.dart';
import '../../../../helper/global_data.dart';
import '../../../../provider/admin/a_booking_provider.dart';
import '../../../widgets/custom_border_container.dart';

class ABookingButton extends StatelessWidget {
  final Booking booking;

  const ABookingButton({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<ABookingProvider>(
      builder: (context, bookingProvider, child) => DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: const Icon(Icons.more_vert),
          items: [
            ...((booking.status != BookingStatus.pending.name &&
                        booking.status != BookingStatus.confirmed.name)
                    ? ['User Details']
                    : (booking.status == BookingStatus.pending.name)
                        ? ['Accept Booking', 'Decline Booking', 'User Details']
                        : ['Complete Booking', 'User Details'])
                .map(
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
            if (value == 'User Details') {
              showUserDetails(context, booking);
            }
            if (value == 'Accept Booking') {
              customCupertinoAlert(
                  title: Text(
                    "Alert",
                    style: TextStyle(color: colorScheme.error),
                  ),
                  content: "Do you really want to confirm this booking?",
                  confirmButtonText: 'Confirm',
                  onPressed: () {
                    bookingProvider.updateBooking(
                        {"status": BookingStatus.confirmed.name}, booking.id);
                  });
            }
            if (value == 'Decline Booking') {
              customCupertinoAlert(
                  title: Text(
                    "Warning",
                    style: TextStyle(color: colorScheme.error),
                  ),
                  content: "Do you really want to decline this booking?",
                  confirmButtonText: 'Decline',
                  onPressed: () {
                    bookingProvider.updateBooking(
                        {"status": BookingStatus.declined.name}, booking.id);
                  });
            }
            if (value == 'Complete Booking') {
              customCupertinoAlert(
                  title: Text(
                    "Alert",
                    style: TextStyle(color: colorScheme.error),
                  ),
                  content: "Do you really want to complete this booking?",
                  confirmButtonText: 'Complete',
                  onPressed: () {
                    bookingProvider.updateBooking(
                        {"status": BookingStatus.completed.name}, booking.id);
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

  void showUserDetails(BuildContext context, Booking booking) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      elevation: 1,
      isScrollControlled: true,
      backgroundColor: colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Consumer<ABookingProvider>(
            builder: (context, bookingProvider, child) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User Details",
                        style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: const EdgeInsets.all(5),
                        minSize: 35,
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.onSurface,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: bookingProvider.getUserDetails(booking.userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        Map<String, dynamic> user = snapshot.data!;
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: colorScheme.onPrimary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: colorScheme.onSurface, width: 4),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            user['photoUrl']))),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                user['name'],
                                style: TextStyle(
                                    color: colorScheme.onSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                user['email'],
                                style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomBorderedContainer(
                                  child: ListTile(
                                onTap: () {
                                  final Uri emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: user['email'],
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject':
                                          'Example Subject & Symbols are allowed!',
                                    }),
                                  );
                                  launchUrl(emailLaunchUri);
                                },
                                trailing: Icon(
                                  CupertinoIcons.mail,
                                  color: colorScheme.onSecondary,
                                ),
                                title: Text(
                                  user['email'],
                                  style: TextStyle(
                                      color: colorScheme.secondaryContainer,
                                      fontSize: 16),
                                ),
                                leading: Text(
                                  "Email: ",
                                  style: TextStyle(
                                      color: colorScheme.onSecondary,
                                      fontSize: 16),
                                ),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              if (user['phone'] != null &&
                                  user['phone'].toString().isNotEmpty)
                                CustomBorderedContainer(
                                    child: ListTile(
                                  onTap: () {
                                    launchUrl(
                                        Uri.parse('tel:${user['phone']}'));
                                  },
                                  trailing: Icon(
                                    CupertinoIcons.phone,
                                    color: colorScheme.onSecondary,
                                  ),
                                  title: Text(
                                    user['phone'],
                                    style: TextStyle(
                                        color: colorScheme.secondaryContainer,
                                        fontSize: 16),
                                  ),
                                  leading: Text(
                                    "Phone: ",
                                    style: TextStyle(
                                        color: colorScheme.onSecondary,
                                        fontSize: 16),
                                  ),
                                )),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
