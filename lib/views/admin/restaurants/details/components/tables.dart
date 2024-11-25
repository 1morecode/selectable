//
// Created by 1 More Code on 09/11/24.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/model/booking.dart';
import 'package:selectable/model/table.dart';
import 'package:selectable/provider/admin/a_booking_provider.dart';
import 'package:selectable/views/admin/bookings/components/a_booking_item.dart';
import 'package:selectable/views/widgets/custom_border_container.dart';
import 'package:selectable/views/widgets/custom_chip.dart';

import '../../../../../provider/admin/a_restaurant_provider.dart';
import '../../../../widgets/custom_widgets.dart';

class ARestaurantTables extends StatefulWidget {
  final String restaurantId;

  const ARestaurantTables({super.key, required this.restaurantId});

  @override
  State<ARestaurantTables> createState() => _ARestaurantTablesState();
}

class _ARestaurantTablesState extends State<ARestaurantTables> {
  @override
  void initState() {
    super.initState();
    var restProvider = Provider.of<ARestaurantProvider>(context, listen: false);
    restProvider.fetchTables(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<ARestaurantProvider>(
      builder: (context, restProvider, child) => Scaffold(
        body: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            RestaurantTable table = restProvider.tables[index];
            return SizedBox(
              width: size.width,
              child: CustomBorderedContainer(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            "Table No.: ${table.tableNumber}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                          CustomChip(
                            text: "Capacity: ${table.capacity}",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Type.: ${table.tableType}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: colorScheme.secondaryContainer),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Location Type.: ${table.location}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: colorScheme.secondaryContainer),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomChip(
                            style: TextStyle(color: table.isAvailable ? colorScheme.secondary
                                    : colorScheme.secondaryContainer, fontSize: 14),
                            text: table.isAvailable ? "Enabled" : "Disabled",
                          ),
                          const Spacer(),
                          CupertinoButton(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                            onPressed: () {
                              showTableList(context, table);
                            },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            minSize: 25,
                            child: const Text("Bookings"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CupertinoButton(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                            onPressed: () {
                              restProvider.initTable(table);
                              showTableForm(context, "update", table);
                            },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            minSize: 25,
                            child: const Text("Edit"),
                          )
                        ],
                      ),
                    ],
                  )),
            );
          },
          itemCount: restProvider.tables.length,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(CupertinoIcons.add_circled),
          onPressed: () {
            showTableForm(context, "add", null);
          },
        ),
      ),
    );
  }

  void showTableForm(
      BuildContext context, String type, RestaurantTable? table) {
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
          heightFactor: 0.8,
          child: Consumer<ARestaurantProvider>(
            builder: (context, restaurantProvider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          restaurantProvider.clearForm();
                          Navigator.of(context).pop();
                        },
                        padding: const EdgeInsets.all(5),
                        minSize: 35,
                        child: const Text("Cancel"),
                      ),
                      Text(
                        "Add Table",
                        style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          if (type == 'update' && table != null) {
                            restaurantProvider.updateTable(table).then(
                              (value) {
                                if (value) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          } else {
                            restaurantProvider
                                .addTable(widget.restaurantId)
                                .then(
                              (value) {
                                if (value) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }
                        },
                        padding: const EdgeInsets.all(5),
                        minSize: 35,
                        child: Text(
                            type == 'update' ? "Update Table" : "Add Table"),
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
                    child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    getFieldTitle("Table Number *", context),
                    CupertinoTextField(
                      controller: restaurantProvider.tableNumberController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      placeholder: "Table Number",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    getFieldTitle("Table Type *", context),
                    CupertinoTextField(
                      controller: restaurantProvider.tableTypeController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      placeholder: "Table Type",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    getFieldTitle("Table Capacity *", context),
                    CupertinoTextField(
                      controller: restaurantProvider.capacityController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      placeholder: "Table Capacity",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    getFieldTitle("Table Location *", context),
                    CupertinoTextField(
                      controller: restaurantProvider.locationController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      placeholder: "Table Location",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    getFieldTitle("Advance Price *", context),
                    CupertinoTextField(
                      controller: restaurantProvider.advanceController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      placeholder: "Advance Price",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: getFieldTitle("Is Enabled", context),
                        ),
                        CupertinoSwitch(
                          value: restaurantProvider.isTableAvailable,
                          onChanged: (value) =>
                              restaurantProvider.updateIsTableAvailable(value),
                        )
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  void showTableList(
      BuildContext context, RestaurantTable? table) {
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
          child: Consumer<ABookingProvider>(
            builder: (context, bookingProvider, child) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bookings",
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
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: bookingProvider.getListByTable(table!.id, bookingProvider.bookings).length,
                  itemBuilder: (context, index) {
                    Booking booking = bookingProvider.getListByTable(table.id, bookingProvider.bookings)[index];
                    return ABookingItem(booking: booking);
                  },
                ),)
              ],
            ),
          ),
        );
      },
    );
  }
}
