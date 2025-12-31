import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/providers/carts/cart-provider.dart';
import 'package:sugudeni/repositories/devlivery/develivery-repository.dart';
import 'package:sugudeni/utils/constants/colors.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/customWidgets/shimmer-widgets.dart';
import '../../../utils/routes/routes-name.dart';


void showDeliverySlots(BuildContext context,bool isComFromOrderAgain) {
  // String? selectedSlot;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      List<String> slots = _generateTimeSlots();

      return Consumer<CartProvider>(
          builder: (context,provider,child){
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
               Text(
                 AppLocalizations.of(context)!.selectdeliveryslots,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                  future: DeliveryRepository.getAllDeliverySlot(context),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) => const ListItemShimmer(height: 50),
                      );
                    }
                    if(snapshot.hasError){
                      return Center(
                        child: Text(
                          'Error loading delivery slots: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    var data=snapshot.data;
                    if(data == null || data.deliverySlots.isEmpty){
                      return const Center(
                        child: Text('No delivery slots available'),
                      );
                    }
                return  GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.deliverySlots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two slots per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3.2, // Adjust slot size
                  ),
                  itemBuilder: (context, index) {
                    String slot = slots[index];
                    bool isSelected = slot == provider.selectedSlot;
                    var slotsData=data.deliverySlots[index];
                    return GestureDetector(
                      onTap: () {
                        provider.setDeliveryId(slotsData.id, slotsData);
                      isComFromOrderAgain==true? null: Navigator.pushNamed(context, RoutesNames.customerCheckoutView);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? primaryColor : whiteColor,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${slotsData.startTime}-${slotsData.endTime}",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? whiteColor : blackColor,
                              ),
                            ),
                            Text(slotsData.title,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? whiteColor : blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),


            ],
          ),
        );
      });
    },
  );
}

List<String> _generateTimeSlots() {
  List<String> slots = [];
  for (int hour = 0; hour < 24; hour += 2) {
    String start = _formatTime(hour);
    String end = _formatTime(hour + 2);
    slots.add("$start - $end");
  }
  return slots;
}

String _formatTime(int hour) {
  return hour.toString().padLeft(2, '0') + ":00";
}