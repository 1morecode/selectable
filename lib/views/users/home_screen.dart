//
// Created by 1 More Code on 05/11/24.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/home_provider.dart';
import 'package:selectable/provider/restaurant_provider.dart';
import 'package:selectable/views/users/bookings/bookings_page.dart';
import 'package:selectable/views/users/home/home_page.dart';
import 'package:selectable/views/users/profile/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        var aRestaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
        aRestaurantProvider.fetchRestaurants();
      },
    );
  }

  final List<Widget> _screens = const [HomePage(), BookingsPage(), ProfilePage()];
  final List<String> _screensTitle = const ["Home", "Bookings", "Profile"];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(_screensTitle[homeProvider.selectedIndex]),
        ),
        body: _screens[homeProvider.selectedIndex],
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
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
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
          currentIndex: homeProvider.selectedIndex,
          // selectedItemColor: colorScheme.primaryContainer,
          onTap: homeProvider.onItemTapped,
        ),
      ),
    );
  }
}
