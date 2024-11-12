//
// Created by 1 More Code on 09/11/24.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/provider/admin/a_restaurant_provider.dart';
import 'package:selectable/views/admin/restaurants/components/a_restaurant_item.dart';

class ARestaurants extends StatelessWidget {
  const ARestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ARestaurantProvider>(
      builder: (context, value, child) => value.restaurants.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: value.restaurants.length,
              itemBuilder: (context, index) =>
                  ARestaurantItem(restaurant: value.restaurants[index]),
            ),
    );
  }
}
