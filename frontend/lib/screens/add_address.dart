// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ali33/models/user_model.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  Position? _currentPosition;

  getCurrentUser() async {
    UserModel? user = await ApiService().getCurrentUser();
    _phoneController.text = user!.phoneNo;
    _nameController.text = user.proprietorName;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toastMessage(
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        toastMessage("Please give the permission to access location");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      toastMessage("Location Permission is denied can't move forward");
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    print("perm $hasPermission");

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print("pos $position");
      _currentPosition = position;
      setState(() {});
      _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint("error $e");
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        print("address ${place.name}");
        _addressController.text =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    getCurrentUser();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Address"),
      ),
      bottomNavigationBar: nextButton(
        "Save Address",
        () async {
          setState(() {
            isLoading = true;
          });
          bool res = await ApiService().addAddress(
            DeliveryAddress(
                point: "${_currentPosition!.latitude} ${_currentPosition!.longitude}",
                address: "${_houseNoController.text},${_addressController.text}"),
          );
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, true);
        },
      ),
      body: _currentPosition == null
          ? loadingAnimation()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    // height: size.height,
                    // width: size.width,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              width: size.width,
                              // child: GoogleMap(
                              //     compassEnabled: true,
                              //     initialCameraPosition: CameraPosition(
                              //       zoom: 5,
                              //       target: LatLng(17.3850, 78.4867),
                              //       // target: LatLng(
                              //       //   _currentPosition!.latitude,
                              //       //   _currentPosition!.longitude,
                              //       // ),
                              //     )),
                            ),
                            // Positioned(
                            //   right: 20,
                            //   top: 10,
                            //   child: IconButton(
                            //       onPressed: () async {
                            //         String address = await Navigator.push(
                            //             context,
                            //             SlideLeftRoute(
                            //                 widget: MapScreen(
                            //                     currentPosition:
                            //                         _currentPosition!)));
                            //         if (address.isNotEmpty)
                            //           _addressController.text = address;
                            //       },
                            //       icon: Icon(
                            //         Icons.fullscreen,
                            //         size: 44,
                            //       )),
                            // )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 5,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.home,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Card(
                              elevation: 2,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(Icons.work),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Card(
                              elevation: 2,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(Icons.location_on),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text("Contact Person Name",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Name *',
                            hintStyle: const TextStyle(fontFamily: "Jost"),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Phone No",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Phone NO. *',
                            hintStyle: const TextStyle(fontFamily: "Jost"),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Flat,House No.",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _houseNoController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Flat / House NO *',
                            hintStyle: const TextStyle(fontFamily: "Jost"),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Area, Street, Sector, Village, City",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Address *',
                            hintStyle: const TextStyle(fontFamily: "Jost"),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading) loadingAnimation()
              ],
            ),
    );
  }
}
