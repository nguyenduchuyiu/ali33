// ignore_for_file: use_build_context_synchronously

import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/add_address.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/error_builder.dart';
import 'package:flutter/material.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  int selected = -1;
  bool isLoading = false;

  late Future<List<String>> addess;
  late UserModel? userModel;
  void getAddresses() {
    addess = ApiService().getAllAddresses();
  }

  Future<void> getCurrentUser() async {
    userModel = await ApiService().getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getAddresses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a delivery address"),
        leading: BackButton(onPressed: () => Navigator.pop(context, false)),
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done))],
      ),
      body: FutureBuilder<List<String>>(
          future: addess,
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return loadingAnimation();
            } else if (snapshots.hasError) {
              return buildErrorWidget(context, () => getAddresses());
            }
            if (snapshots.data!.isEmpty) {
              return buildErrorWidget(
                  context, () => getAddresses(), "No Address Found! Add One");
            }
            return ListView(
              primary: false,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    bool res = await Navigator.push(context, SlideLeftRoute(widget: HomeScreen(selectedPage: 1,)));
                        // context, SlideLeftRoute(widget: const AddAddressScreen()));//Huy test
                    if (res) getAddresses();
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add a New Address",
                              style: Theme.of(context).textTheme.displayMedium),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: snapshots.data!.length,
                    primary: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      String deliveryAddress = snapshots.data![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: index,
                                  groupValue: selected,
                                  onChanged: (int? val) {
                                    setState(() {
                                      selected = val!;
                                    });
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userModel!.proprietorName,
                                      style:
                                          Theme.of(context).textTheme.displayLarge,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Text(
                                        deliveryAddress,
                                        maxLines: 4,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "Phone number: 9382038283",
                                      style:
                                          Theme.of(context).textTheme.displaySmall,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            selected == index
                                ? Row(
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          elevation: 2,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        onPressed: () async {
                                          if (selected != -1) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            bool res = await ApiService()
                                                .deleteAddress(snapshots.data![selected]);
                                            setState(() {
                                              isLoading = false;
                                              selected = -1;
                                              getAddresses();
                                            });

                                            if (res) {
                                              Navigator.pop(context, true);
                                            }
                                          }
                                        },
                                        child: const Text("Remove"),
                                      ),
                                      const SizedBox(width: 20),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          elevation: 2,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        onPressed: () async {
                                          if (selected != -1) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            bool res = await ApiService()
                                                .setDefaultAddress(
                                                    snapshots.data![selected]);
                                            setState(() {
                                              isLoading = false;
                                              selected = -1;
                                              getAddresses();
                                            });
                                            if (res) {
                                              Navigator.pop(context, true);
                                            }
                                          }
                                        },
                                        child: const Text("Set Address"),
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      );
                    }),
              ],
            );
          }),
    );
  }
}
