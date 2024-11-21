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

class DottedBorder extends CustomPainter {
  //number of stories
  final int dotCount;
  final Color? color;

  //length of the space arc (empty one)
  final int spaceLength;

  //start of the arc painting in degree(0-360)
  double startOfArcInDegree = 0;

  DottedBorder({
    required this.dotCount,
    this.spaceLength = 10,
    this.color,
  });

  //drawArc deals with rads, easier for me to use degrees
  //so this takes a degree and change it to rad
  double inRads(double degree) {
    return (degree * pi) / 180;
  }

  @override
  bool shouldRepaint(DottedBorder oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //circle angle is 360, remove all space arcs between the main story arc (the number of spaces(stories) times the  space length
    //then subtract the number from 360 to get ALL arcs length
    //then divide the ALL arcs length by number of Arc (number of stories) to get the exact length of one arc
    double arcLength = (360 - (dotCount * spaceLength)) / dotCount;

    //be careful here when arc is a negative number
    //that happens when the number of spaces is more than 360
    //feel free to use what logic you want to take care of that
    //note that numberOfStories should be limited too here
    if (arcLength <= 0) {
      arcLength = 360 / spaceLength - 1;
    }

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    //looping for number of stories to draw every story arc
    for (int i = 0; i < dotCount; i++) {
      //printing the arc
      canvas.drawArc(
          rect,
          inRads(startOfArcInDegree),
          //be careful here is:  "double sweepAngle", not "end"
          inRads(arcLength),
          false,
          Paint()
            //here you can compare your SEEN story index with the arc index to make it grey
            ..color = color ?? Colors.orangeAccent
            ..strokeWidth = 8.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);

      //the logic of spaces between the arcs is to start the next arc after jumping the length of space
      startOfArcInDegree += arcLength + spaceLength;
    }
  }
}
