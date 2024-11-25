//
// Created by 1 More Code on 12/11/24.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/model/restaurant.dart';
import 'package:selectable/provider/admin/a_restaurant_provider.dart';
import '../../../../widgets/custom_widgets.dart';

class TableAvailability extends StatefulWidget {
  final Restaurant restaurant;

  const TableAvailability({super.key, required this.restaurant});

  @override
  State<TableAvailability> createState() => _TableAvailabilityState();
}

class _TableAvailabilityState extends State<TableAvailability> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<ARestaurantProvider>(context, listen: false);
    provider.fetchTables(widget.restaurant.id);
    provider.availability = widget.restaurant.availability;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<ARestaurantProvider>(
      builder: (context, restaurantProvider, child) => CupertinoButton(
          color: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minSize: 35,
          onPressed: () {
            restaurantProvider.clearTableData();
            restaurantProvider.availability = widget.restaurant.availability;

            showAvailability(context, widget.restaurant);
          },
          child: const Text("Check Now")),
    );
  }

  void showAvailability(BuildContext context, Restaurant restaurant) {
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
          heightFactor: 0.9,
          child: Consumer<ARestaurantProvider>(
            builder: (context, restaurantProvider, child) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Slot Availability",
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
                        child: const Text("Cancel"),
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
                    child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            getFieldTitle("Select Date *", context),
                            CupertinoTextField(
                              controller: restaurantProvider.dateController,
                              readOnly: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              placeholder: "Select Date",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              suffix: IconButton(
                                  onPressed: () async {
                                    DateTime? date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 90)),
                                      initialDate:
                                          restaurantProvider.selectedDate,
                                      barrierDismissible: true,
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                                primary:
                                                    colorScheme.onSecondary,
                                                surface: colorScheme.onPrimary,
                                                onSurface:
                                                    colorScheme.onSecondary,
                                                onPrimary:
                                                    colorScheme.onPrimary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (date != null) {
                                      restaurantProvider.onSelectDate(date);
                                    }
                                  },
                                  icon: const Icon(CupertinoIcons.calendar)),
                            ),
                            if (restaurantProvider.selectedDate != null &&
                                restaurantProvider.slotsList.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 5),
                                child: getFieldTitle("Select Slot", context),
                              ),
                            if (restaurantProvider.selectedDate != null)
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                  restaurantProvider.slotsList.length,
                                  (index) => CupertinoButton(
                                    onPressed: () {
                                      restaurantProvider.onSelectSlot(
                                          restaurantProvider.slotsList[index]);
                                    },
                                    color: restaurantProvider.selectedSlot ==
                                            restaurantProvider.slotsList[index]
                                        ? colorScheme.onSecondary
                                        : colorScheme.onSurface,
                                    borderRadius: BorderRadius.circular(4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    minSize: 25,
                                    child: Text(
                                      restaurantProvider.slotsList[index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              restaurantProvider.selectedSlot ==
                                                      restaurantProvider
                                                          .slotsList[index]
                                                  ? colorScheme.onPrimary
                                                  : colorScheme.onSecondary),
                                    ),
                                  ),
                                ),
                              ),
                            if (restaurantProvider.selectedDate != null &&
                                restaurantProvider.selectedSlot != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 5),
                                child: getFieldTitle("Select Table", context),
                              ),
                          ],
                        ),
                      ),
                      if (restaurantProvider.selectedDate != null &&
                          restaurantProvider.selectedSlot != null)
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: colorScheme.onSurface, width: 10)),
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/${widget.restaurant.id}.png",
                                width: size.width,
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: restaurantProvider.tables.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) =>
                                    CupertinoButton(
                                  onPressed: restaurantProvider.isTableBooked(
                                          restaurantProvider.tables[index].id)
                                      ? null
                                      : () {
                                          restaurantProvider.onSelectTable(
                                              restaurantProvider.tables[index]);
                                        },
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: restaurantProvider
                                                            .selectedTable !=
                                                        null &&
                                                    restaurantProvider
                                                            .selectedTable!
                                                            .id ==
                                                        restaurantProvider
                                                            .tables[index].id
                                                ? colorScheme.secondaryContainer
                                                : Colors.transparent,
                                            width: 3)),
                                    child: Opacity(
                                      opacity: restaurantProvider.isTableBooked(
                                              restaurantProvider
                                                  .tables[index].id)
                                          ? 0.3
                                          : 1,
                                      child: Image.asset(
                                          width: size.width * 0.3,
                                          fit: BoxFit.contain,
                                          "assets/tables/${restaurantProvider.tables[index].capacity}.png"),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
