import 'package:ali33/models/order_item_model.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

class OrderTrackScreen extends StatefulWidget {
  final OrderCombinedModel orderCombinedModel;
  const OrderTrackScreen({Key? key, required this.orderCombinedModel})
      : super(key: key);

  @override
  State<OrderTrackScreen> createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends State<OrderTrackScreen> {
  String getTitel(int i) {
    switch (i) {
      case 0:
        return "Order Placed";
      case 1:
        return "Payment Confirmed";
      case 2:
        return "Order Processed";
      case 3:
        return "Ready to Pickup";
      default:
        return "Order Placed";
    }
  }

  IconData getIcon(int i) {
    switch (i) {
      case 0:
        return Icons.receipt;
      case 1:
        return Icons.payment;
      case 2:
        return Icons.person;
      case 3:
        return Icons.card_travel;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              widget.orderCombinedModel.orderDetails.orderedDate
                  .toLocal()
                  .toString()
                  .split(" ")[0],
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text("Order ID: ${widget.orderCombinedModel.orderDetails.key}",
                style: Theme.of(context).textTheme.displayLarge),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.6,
                  width: size.width * 0.2,
                  child: IconStepper(
                    direction: Axis.vertical,
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    stepColor: Colors.green,
                    activeStepBorderColor: Colors.grey,
                    activeStepBorderWidth: 0.0,
                    activeStepBorderPadding: 0.0,
                    lineColor: Colors.green,
                    lineLength: size.height * 0.1,
                    lineDotRadius: 2.0,
                    stepRadius: 16.0,
                    icons:
                        // List<Icon>.from(widget.orderCombinedModel.orderDetails.deliveryStages.map((e) =>  Icon(Icons.check, color: Colors.white)))
                        [
                      widget.orderCombinedModel.orderDetails.deliveryStages.isNotEmpty
                          ? const Icon(Icons.check, color: Colors.white)
                          : const Icon(Icons.radio_button_checked,
                              color: Colors.green),
                      widget.orderCombinedModel.orderDetails.deliveryStages
                                  .length >
                              1
                          ? const Icon(Icons.check, color: Colors.white)
                          : const Icon(Icons.radio_button_checked,
                              color: Colors.green),
                      widget.orderCombinedModel.orderDetails.deliveryStages
                                  .length >
                              2
                          ? const Icon(Icons.check, color: Colors.white)
                          : const Icon(Icons.radio_button_checked,
                              color: Colors.green),
                      widget.orderCombinedModel.orderDetails.deliveryStages
                                  .length >
                              3
                          ? const Icon(Icons.check, color: Colors.white)
                          : const Icon(Icons.radio_button_checked,
                              color: Colors.green),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget
                        .orderCombinedModel.orderDetails.deliveryStages.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              leading: Icon(
                                getIcon(index),
                                size: 40.0,
                                // color: kPrimaryColor,
                              ),
                              title: Text(
                                getTitel(index),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${widget.orderCombinedModel.orderDetails.deliveryStages[index]}",
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ),
                          // Text(
                          //   "trackOrderList[index]",
                          //   style: TextStyle(fontSize: 16.0),
                          // ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 0),
                width: size.width,
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.home, size: 60),
                    SizedBox(
                      width: size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sai Teja Dande",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(
                            width: size.width * 0.7,
                            child: Text(
                              widget.orderCombinedModel.orderDetails
                                  .deliveryAddress.address,
                              maxLines: 4,
                              style: Theme.of(context).textTheme.headlineMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "Phone number: 4181984929052",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
