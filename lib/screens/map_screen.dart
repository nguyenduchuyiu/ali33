// import 'package:online_store/models/place_model.dart';
// import 'package:online_store/services/api_service.dart';
// import 'package:online_store/widgets/basic.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   final Position currentPosition;
//   const MapScreen({Key? key, required this.currentPosition}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//   List<PlaceModel> placeSuggestions = [];
//   bool isTextFieldActive = false;
//   TextEditingController placeController = TextEditingController();
//   Set<Marker> marker = {
//     const Marker(
//       // markerId: MarkerId(argument.latitude.toString()),
//       markerId: MarkerId("singlepointermarker"),
//     ),
//   };
//   Set<Polygon> poly = {
//     const Polygon(
//       polygonId: PolygonId("1234"),
//       fillColor: Colors.black38,
//       strokeWidth: 4,
//       points: [
//         LatLng(18.40263327183774, 77.12845914065838),
//         LatLng(18.834751375254264, 79.93885058909655),
//         LatLng(16.135215174765257, 79.86377522349359),
//         LatLng(16.1017496913932, 76.53709877282381),
//       ],
//     )
//   };
//   bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
//     int intersectCount = 0;
//     for (int j = 0; j < vertices.length - 1; j++) {
//       if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
//         intersectCount++;
//       }
//     }

//     return ((intersectCount % 2) == 1); // odd = inside, even = outside;
//   }

//   bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
//     double aY = vertA.latitude;
//     double bY = vertB.latitude;
//     double aX = vertA.longitude;
//     double bX = vertB.longitude;
//     double pY = tap.latitude;
//     double pX = tap.longitude;

//     if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
//       return false; // a and b can't both be above or below pt.y, and a or
//       // b must be east of pt.x
//     }

//     double m = (aY - bY) / (aX - bX); // Rise over run
//     double bee = (-aX) * m + aY; // y = mx + b
//     double x = (pY - bee) / m; // algebra is neat!

//     return x > pX;
//   }

//   Future<void> _getAddressFromLatLng(LatLng position) async {
//     await placemarkFromCoordinates(position.latitude, position.longitude)
//         .then((List<Placemark> placemarks) {
//       Placemark place = placemarks[0];
//       setState(() {
//         placeController.text =
//             '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // floatingActionButton: FloatingActionButton(onPressed: () {
//       //   mapController.animateCamera(CameraUpdate.newLatLng(
//       //     LatLng(22.5937, 90.9629),
//       //   ));
//       // }),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: GoogleMap(
//               onTap: (argument) => setState(() {
//                 FocusScope.of(context).unfocus();
//                 isTextFieldActive = false;
//                 marker.remove(marker.elementAt(0));
//                 marker.add(Marker(
//                   markerId: MarkerId("singlepointermarker"),
//                   position: argument,
//                 ));

//                 bool res = _checkIfValidMarker(argument, poly.first.points);
//                 if (!res) {
//                   toastMessage(
//                       "currently we are not delivering outside shown area");
//                 } else {
//                   _getAddressFromLatLng(argument);
//                 }
//               }),
//               markers: marker,
//               polygons: poly,
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 zoom: 7.0,
//                 // target: LatLng(widget.currentPosition.latitude,
//                 //     widget.currentPosition.longitude),
//                 target: LatLng(17.3850, 78.4867),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: ListView(
//               primary: true,
//               shrinkWrap: true,
//               children: [
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5)),
//                   child: GestureDetector(
//                     // onTap: () async {
//                     //   await ApiService().searchPlaceOnMap("JublieeHills");
//                     // },
//                     child: Container(
//                       height: 50,
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           Icon(Icons.search_rounded),
//                           SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               controller: placeController,
//                               decoration: InputDecoration(
//                                   hintText: "Search for place",
//                                   border: InputBorder.none),
//                               onTap: () => setState(() {
//                                 isTextFieldActive = true;
//                               }),
//                               onChanged: (String val) async {
//                                 placeSuggestions =
//                                     await ApiService().searchPlaceOnMap(val);
//                                 setState(() {});
//                               },
//                               onSubmitted: (val) => setState(() {
//                                 isTextFieldActive = false;
//                               }),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           IconButton(
//                               onPressed: () => placeController.text = "",
//                               icon: Icon(Icons.clear))
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (isTextFieldActive)
//                   Container(
//                     // height: 300,
//                     color: Colors.white,
//                     child: ListView.builder(
//                       itemCount: placeSuggestions.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                             onTap: () async {
//                               setState(() {
//                                 FocusScope.of(context).unfocus();
//                                 placeController.text =
//                                     placeSuggestions[index].placeDescription;
//                                 isTextFieldActive = false;
//                               });
//                               // making marker
//                               List<Location> locations =
//                                   await locationFromAddress(
//                                       placeSuggestions[index].placeDescription);

//                               marker.remove(marker.elementAt(0));
//                               marker.add(Marker(
//                                 markerId: MarkerId("singlepointermarker"),
//                                 position: LatLng(locations[0].latitude,
//                                     locations[0].longitude),
//                               ));

//                               bool res = _checkIfValidMarker(
//                                   LatLng(locations[0].latitude,
//                                       locations[0].longitude),
//                                   poly.first.points);

//                               if (!res)
//                                 toastMessage(
//                                     "currently we are not delivering outside shown area");
//                             },
//                             title:
//                                 Text(placeSuggestions[index].placeDescription));
//                       },
//                     ),
//                   )
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 10,
//             left: 10,
//             right: 40,
//             child: nextButton("Select Place", () {
//               Navigator.pop(context, placeController.text);
//             }),
//           )
//         ],
//       ),
//     );
//   }
// }
