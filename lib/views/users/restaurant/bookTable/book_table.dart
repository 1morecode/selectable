//
// Created by 1 More Code on 12/11/24.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/global_data.dart';
import 'package:selectable/model/restaurant.dart';
import 'package:selectable/views/users/restaurant/bookTable/payment_screen.dart';
import 'package:selectable/views/widgets/custom_chip.dart';

import '../../../../provider/restaurant_provider.dart';
import '../../../widgets/custom_widgets.dart';

class BookTable extends StatefulWidget {
  final Restaurant restaurant;

  const BookTable({super.key, required this.restaurant});

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<RestaurantProvider>(context, listen: false);
    provider.fetchTables(widget.restaurant.id);
    provider.availability = widget.restaurant.availability;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurant.name),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
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
                              lastDate:
                                  DateTime.now().add(const Duration(days: 90)),
                              initialDate: restaurantProvider.selectedDate,
                              barrierDismissible: true,
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: colorScheme.onSecondary,
                                        surface: colorScheme.onPrimary,
                                        onSurface: colorScheme.onSecondary,
                                        onPrimary: colorScheme.onPrimary),
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
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
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
                                  color: restaurantProvider.selectedSlot ==
                                          restaurantProvider.slotsList[index]
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSecondary),
                            ),
                          ),
                        ),
                      ),
                    if (restaurantProvider.selectedDate != null &&
                        restaurantProvider.selectedSlot != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: getFieldTitle("Select Table", context),
                      ),
                  ],
                ),
              ),
              if (restaurantProvider.selectedDate != null &&
                  restaurantProvider.selectedSlot != null)
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: colorScheme.onSurface, width: 10)),
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
                        itemCount: restaurantProvider.tableList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) => CupertinoButton(
                          onPressed: restaurantProvider.isTableBooked(
                                  restaurantProvider.tableList[index].id)
                              ? null
                              : () {
                                  restaurantProvider.onSelectTable(
                                      restaurantProvider.tableList[index]);
                                },
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: restaurantProvider.selectedTable !=
                                                null &&
                                            restaurantProvider
                                                    .selectedTable!.id ==
                                                restaurantProvider
                                                    .tableList[index].id
                                        ? colorScheme.secondaryContainer
                                        : Colors.transparent,
                                    width: 3)),
                            child: Opacity(
                              opacity: restaurantProvider.isTableBooked(
                                      restaurantProvider.tableList[index].id)
                                  ? 0.3
                                  : 1,
                              child: Image.asset(
                                  width: size.width * 0.3,
                                  fit: BoxFit.contain,
                                  "assets/tables/${restaurantProvider.tableList[index].capacity}.png"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: restaurantProvider.selectedTable != null
            ? Container(
                height: 80,
                color: colorScheme.onSurface,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Advance: \$${restaurantProvider.selectedTable!.advancePrice}"
                                .toString(),
                            style: TextStyle(
                                color: colorScheme.onSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Amount will be adjusted in your bill.",
                            style: TextStyle(
                                color: colorScheme.onSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentScreen(),
                            ));
                      },
                      color: colorScheme.primary,
                      minSize: 30,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                        "Continue",
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ),
    );
  }
}
