//
// Created by 1 More Code on 09/11/24.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/model/restaurant.dart';
import 'package:selectable/provider/admin/a_restaurant_provider.dart';
import 'package:selectable/views/admin/restaurants/details/components/bookings.dart';
import 'package:selectable/views/admin/restaurants/details/components/details.dart';
import 'package:selectable/views/admin/restaurants/details/components/tables.dart';

class ARestaurantDetails extends StatefulWidget {
  final String id;
  final String title;

  const ARestaurantDetails({super.key, required this.id, required this.title});

  @override
  State<ARestaurantDetails> createState() => _ARestaurantDetailsState();
}

class _ARestaurantDetailsState extends State<ARestaurantDetails> {
  late Future<Restaurant?> restFuture;
  int selectedTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var restProvider = Provider.of<ARestaurantProvider>(context, listen: false);
    restFuture = restProvider.fetchRestaurant(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<ARestaurantProvider>(
      builder: (context, restaurantProvider, child) => Scaffold(
        appBar: AppBar(
          title: Hero(tag: widget.id, child: Text(widget.title)),
          centerTitle: false,
          bottom: PreferredSize(
              preferredSize: Size(size.width, 50),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: CupertinoSlidingSegmentedControl(
                  groupValue: selectedTab,
                  children: const {
                    0: Text("Details", style: TextStyle(fontSize: 16),),
                    1: Text("Tables", style: TextStyle(fontSize: 16),),
                    2: Text("Orders", style: TextStyle(fontSize: 16),),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTab = value;
                      });
                    }
                  },
                ),
              )),
        ),
        body: IndexedStack(
          index: selectedTab,
          children: [
            ADetails(id: widget.id),
            ARestaurantTables(restaurantId: widget.id),
            ARestaurantBookings(id: widget.id)
          ],
        ),
      ),
    );
  }
}
