//
// Created by 1 More Code on 12/11/24.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/model/restaurant.dart';
import 'package:selectable/views/widgets/custom_chip.dart';

import '../../../provider/restaurant_provider.dart';
import '../../widgets/custom_widgets.dart';

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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              getFieldTitle("Select Date *", context),
              CupertinoTextField(
                controller: restaurantProvider.dateController,
                readOnly: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                placeholder: "Select Date",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                suffix: IconButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        initialDate: restaurantProvider.selectedDate,
                        barrierDismissible: true,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: colorScheme.primary, // Header background color
                                onPrimary: colorScheme.onPrimary, // Header text color
                                onSurface: colorScheme.onSecondary, // Body text color
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        restaurantProvider.onSelectDate(
                            date, widget.restaurant);
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
                        restaurantProvider
                            .onSelectSlot(restaurantProvider.slotsList[index]);
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
              if (restaurantProvider.selectedDate != null &&
                  restaurantProvider.selectedSlot != null)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: restaurantProvider.tableList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/logo.png'),
                      Text(
                        restaurantProvider.tableList[index].tableNumber,
                        style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
