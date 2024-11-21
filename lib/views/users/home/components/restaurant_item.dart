//
// Created by 1 More Code on 09/11/24.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/model/restaurant.dart';
import 'package:selectable/provider/restaurant_provider.dart';
import 'package:selectable/views/widgets/custom_border_container.dart';
import 'package:selectable/views/widgets/custom_chip.dart';

import '../../restaurant/restaurant_detail.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) => CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: CustomBorderedContainer(
              margin: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    height: size.width * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(restaurant.thumbnail),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                  color: colorScheme.onSecondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              restaurant.description,
                              style: TextStyle(
                                  color: colorScheme.onSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                        CustomChip(
                          text: "Rating: ${restaurant.rating}",
                          style: TextStyle(color: colorScheme.secondaryContainer, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_location,
                          size: 16,
                          color: colorScheme.secondaryContainer,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text(
                          "${restaurant.location.address}, ${restaurant.location.city}, ${restaurant.location.state}",
                          style: TextStyle(
                              color: colorScheme.secondaryContainer,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ))
                      ],
                    ),
                  )
                ],
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
