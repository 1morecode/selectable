//
// Created by 1 More Code on 09/11/24.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/model/restaurant.dart';
import 'package:selectable/views/widgets/custom_border_container.dart';

import '../../../../provider/restaurant_provider.dart';
import '../../restaurant/restaurant_detail.dart';

class RestaurantSliderItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantSliderItem({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) => CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: CustomBorderedContainer(
              margin: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(restaurant.thumbnail),
                      fit: BoxFit.cover),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.black54),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    restaurant.description,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              )),
                          Chip(
                            label: Text("Rating: ${restaurant.rating}", style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),),
                            backgroundColor: colorScheme.onSurface,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                          )
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.share_location,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Text(
                                "${restaurant.location.address}, ${restaurant.location.city}, ${restaurant.location.state}",
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              )),
          onPressed: () {
            restaurantProvider.updateCurrentRestaurant(restaurant);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetails(
                    id: restaurant.id,
                    title: restaurant.name,
                  ),
                )).then(
                  (value) {
                restaurantProvider.updateCurrentRestaurant(null);
              },
            );
          }),
    );
  }
}
