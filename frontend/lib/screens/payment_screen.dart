import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/models/order_model.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/orders.dart';
import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final List<OrderModel> orders;
  const PaymentScreen(
      {Key? key, required this.cartItems, required this.orders})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;
  // Sample payment methods and card details
  List<Map<String, String>> paymentMethods = [
    {
      'imageUrl': 'images/visa.png',
      'cardNumber': '**** **** **** 1234',
      'expiryDate': '12/25'
    },
    {
      'imageUrl': 'images/mastercard.png',
      'cardNumber': '**** **** **** 5678',
      'expiryDate': '05/24'
    },
  ];
  int _selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Payment methods
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    value: index,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                    title: Row(
                      children: [
                        Image.asset(
                          paymentMethods[index]['imageUrl']!,
                          height: 50,
                          width: 60,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(paymentMethods[index]['cardNumber']!),
                            Text(
                                "Expiry: ${paymentMethods[index]['expiryDate']!}"),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Add new card button
            ElevatedButton(
              onPressed: () {
                // Navigate to add new card screen
              },
              child: const Text("Add New Card"),
            ),
            const SizedBox(height: 32),
            // Pay button
            ElevatedButton(
              onPressed: () async {
                makePayment(context);
                setState(() {
                  isLoading = true;
                });
                // Handle checkout           

                await ApiService().placeOrder(widget.orders);
                await ApiService().removeFromCart(widget.cartItems);

                setState(() {
                  isLoading = false;
                });
                showAliNotification(context, "You're all set! Your film is ready to watch.");

                // Wait for a short duration before navigating
                await Future.delayed(const Duration(seconds: 2));

                // Navigate to OrdersScreen
                Navigator.pushAndRemoveUntil(context, SlideLeftRoute(widget: HomeScreen(selectedPage: 0,)), (route) => false);
                Navigator.pushReplacement(
                    context, SlideLeftRoute(widget: const OrdersScreen()));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Pay"),
            ),
            if (isLoading) loadingAnimation()
          ],
        ),
      ),
    );
  }

  dynamic createPaymentIntent(String amount, String currency) {
    Map<String, dynamic> paymentDetails = {
      'amount': amount,
      'currency': currency
    };
    return ApiService().createPaymentIntentOnServer(paymentDetails); 
  }

  Future<void> makePayment(BuildContext context) async {
    try {
      final paymentIntentData = await createPaymentIntent('100', 'USD') ?? {};

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          style: ThemeMode.light,
          customFlow: false,
          merchantDisplayName: 'Huy',
        )).then((value) {
          displayPaymentSheet(context);
        });

    } catch (e) {
      print("this $e");
    }
  }

  void displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paid successfully!"))
        );
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is: --> $e');
    }
  }
}