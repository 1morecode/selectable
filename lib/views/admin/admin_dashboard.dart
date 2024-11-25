//
// Created by 1 More Code on 05/11/24.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/admin/a_restaurant_provider.dart';
import 'package:selectable/views/admin/account/a_account.dart';
import 'package:selectable/views/admin/bookings/a_bookings.dart';
import 'package:selectable/views/admin/restaurants/a_restaurants.dart';

import '../../provider/admin/admin_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        var aRestaurantProvider =
            Provider.of<ARestaurantProvider>(context, listen: false);
        aRestaurantProvider.fetchRestaurants();
      },
    );
  }

  final List<Widget> _screens = const [ARestaurants(), ABookings(), AAccount()];
  final List<String> _screensTitle = const ["Restaurants", "Bookings", "Account"];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(_screensTitle[adminProvider.selectedIndex]),
        ),
        body: _screens[adminProvider.selectedIndex],
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: colorScheme.onPrimary,
          height: 60,
          iconSize: 26,
          border:
              Border(top: BorderSide(color: colorScheme.onSurface, width: 1)),
          activeColor: colorScheme.primary,
          inactiveColor: colorScheme.secondaryContainer,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.rectangle_stack),
              activeIcon: Icon(CupertinoIcons.rectangle_stack_fill),
              label: "Restaurants",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_text),
              activeIcon: Icon(CupertinoIcons.doc_text_fill),
              label: "Bookings",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_crop_circle),
              activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
              label: "Account",
            )
          ],
          currentIndex: adminProvider.selectedIndex,
          // selectedItemColor: colorScheme.primaryContainer,
          onTap: adminProvider.onItemTapped,
        ),
      ),
    );
  }
}
