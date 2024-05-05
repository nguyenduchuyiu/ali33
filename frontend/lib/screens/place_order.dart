import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/models/order_model.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:flutter/material.dart';

class PlaceOrderScreen extends StatefulWidget {
  List<OrderModel> ordersList;
  List<CartItem> cartItems;
  final int subTotal;
  PlaceOrderScreen(
      {Key? key,
      required this.ordersList,
      required this.cartItems,
      required this.subTotal})
      : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Now"),
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text("Address", style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 10),
              Row(
                children: [
                  Image.asset("images/map.png",
                      width: size.width * 0.4, fit: BoxFit.contain),
                  SizedBox(width: 20),
                  SizedBox(
                    width: size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sai Teja D",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Text(
                          "41/D, jubliee hills Road no 5 Hyderabad, Telangana, 500033 India",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Text("Payment Method",
                  style: Theme.of(context).textTheme.headline1),
              SizedBox(height: size.height * 0.01),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width,
                  // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Row(children: [
                    Radio(value: 0, groupValue: 0, onChanged: (val) {}),
                    SizedBox(
                      width: size.width * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pay On Delivery / Cash On Delivery",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(
                              "you can pay money directly when order reaches you.")
                        ],
                      ),
                    )
                  ]),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text("Payment Details",
                  style: Theme.of(context).textTheme.headline1),
              SizedBox(height: size.height * 0.01),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shipping Cost",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "$dollarSymbol 40",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            dollarSymbol + widget.subTotal.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(thickness: 2),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            dollarSymbol + (widget.subTotal + 40).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (isLoading) loadingAnimation()
        ],
      ),
      bottomNavigationBar: nextButton(
        "Place Order",
        isLoading
            ? () => null
            : () async {
                setState(() {
                  isLoading = true;
                });

                await ApiService().placeOrder(widget.ordersList);
                await ApiService().removeFromCart(widget.cartItems);
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context, true);
              },
      ),
    );
  }
}
