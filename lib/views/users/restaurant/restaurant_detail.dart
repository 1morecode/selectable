//
// Created by 1 More Code on 09/11/24.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/views/users/restaurant/book_table.dart';

import '../../../model/restaurant.dart';
import '../../../provider/restaurant_provider.dart';
import '../../widgets/custom_chip.dart';
import '../../widgets/small_heading.dart';

class RestaurantDetails extends StatefulWidget {
  final String id;
  final String title;

  const RestaurantDetails({super.key, required this.id, required this.title});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  int current = 0;
  Restaurant? restaurant;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        fetchRestaurant();
      },
    );
  }

  fetchRestaurant() async {
    var restProvider = Provider.of<RestaurantProvider>(context, listen: false);
    Restaurant? res = await restProvider.fetchRestaurant(widget.id);
    setState(() {
      restaurant = res;
    });
  }

  List<String> weekdayOrder = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: false,
        ),
        body: restaurant == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            aspectRatio: 3 / 2,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                current = index;
                              });
                            }),
                        carouselController: _controller,
                        items: restaurant!.images.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(i),
                                      fit: BoxFit.cover),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            restaurant!.images.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomChip(
                          text: "Rating: ${restaurant!.rating}",
                          style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          restaurant!.name,
                          style: TextStyle(
                              color: colorScheme.onSecondary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          restaurant!.description,
                          style: TextStyle(
                              color: colorScheme.onSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.share_location,
                              size: 16,
                              color: colorScheme.primaryContainer,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Text(
                              "${restaurant!.location.address}, ${restaurant!.location.city}, ${restaurant!.location.state}",
                              style: TextStyle(
                                  color: colorScheme.primaryContainer,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SmallHeading(text: "Amenities"),
                        Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: List.generate(
                            restaurant!.amenities.length,
                            (index) =>
                                CustomChip(text: restaurant!.amenities[index]),
                          ),
                        ),
                        const SmallHeading(text: "Opening Hours"),
                        CustomChip(text: restaurant!.openingHours),
                        const SmallHeading(text: "Slots Availability"),
                        ...(restaurant!.availability.availability.entries
                                .toList()
                              ..sort((a, b) => weekdayOrder
                                  .indexOf(a.key)
                                  .compareTo(weekdayOrder.indexOf(b.key))))
                            .map((entry) {
                          String day = entry.key;
                          List<String> slots = entry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day[0].toUpperCase() + day.substring(1),
                                  // Capitalize day name
                                  style: TextStyle(
                                    color: colorScheme.onSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 5,
                                  children: slots
                                      .map((slot) => CustomChip(text: slot))
                                      .toList(),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: restaurant != null
              ? () {
                  restaurantProvider.clearTableData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookTable(restaurant: restaurant!),
                      )).then(
                    (value) {
                      restaurantProvider.clearTableData();
                    },
                  );
                }
              : null,
          label: const Text("Book Table"),
          icon: const Icon(Icons.table_bar_outlined),
        ),
      ),
    );
  }
}