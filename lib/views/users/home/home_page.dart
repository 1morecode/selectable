//
// Created by 1 More Code on 12/11/24.
//

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/provider/restaurant_provider.dart';
import 'package:selectable/views/users/home/components/restaurant_item.dart';
import 'package:selectable/views/users/home/components/restaurant_slider_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RestaurantProvider>(
      builder: (context, value, child) => value.restaurants.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      aspectRatio: 4 / 2,
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {}),
                  // carouselController: _controller,
                  items: value.restaurants.reversed.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return RestaurantSliderItem(restaurant: i);
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Restaurants",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondaryContainer),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  itemCount: value.restaurants.length,
                  itemBuilder: (context, index) =>
                      RestaurantItem(restaurant: value.restaurants[index]),
                ),
              ],
            ),
    );
  }
}
