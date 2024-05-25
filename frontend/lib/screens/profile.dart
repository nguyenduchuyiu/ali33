// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/login.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/services/theme_provider_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool isFirstTime;
  UserModel userModel;
  ProfileScreen({required this.isFirstTime, required this.userModel, Key? key})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?>? user;
  final ImagePicker _picker = ImagePicker();
  late AppThemeNotifier appThemeNotifier;
  @override
  void didChangeDependencies() {
    appThemeNotifier = Provider.of<AppThemeNotifier>(context);
    super.didChangeDependencies();
  }

  XFile? _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();

  bool _isLoading = false;
  // getCurrentUser() async {
  //   // user = ApiService().getCurrentUser();
  //   setState(() {});
  // }

  Future<void> _pickGalleryPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    _image = image!;
    setState(() {});
  }

  Future<void> _pickCameraPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    _image = image!;
    setState(() {});
  }

  Future chooseFrom() async {
    return showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Option",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => Navigator.pop(context, "gallery"),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pick from Gallery"),
                    Icon(Icons.photo)
                  ],
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => Navigator.pop(context, "camera"),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pick from Gallery"),
                    Icon(Icons.camera_alt),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future imagefileChoice(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Options for Photo Picking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Text('Choose from Gallery')),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, "gallery");
                    },
                    icon: const Icon(
                      Icons.photo_library,
                      // color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Take a Picture'),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, "camera");
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      // color: Colors.black54,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void setUser() {
    _shopNameController.text = widget.userModel.shopName;
    _dobController.text = widget.userModel.dob.toString().split(" ")[0];
    _emailController.text = widget.userModel.emailId;
    _phoneController.text = widget.userModel.phoneNo;
    _ownerNameController.text = widget.userModel.proprietorName;
    _gstController.text = widget.userModel.gst;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2025));
    if (selected != null && selected != widget.userModel.dob) {
      setState(() {
        // selectedDate = selected;
        _dobController.text = selected.toUtc().toString().split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    // getCurrentUser();
    setUser();
    // print(widget.user);
    // _emailController.text = widget.user["email"];
    // _nameController.text = widget.user["name"];
    super.initState();
  }

  Future _deleteAccountDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              // title: Text("Log out of The Leaflet?",style: Theme.of(context).textTheme.headlineSmall ,),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure? You want to Delete your Account",
                    style: Theme.of(context).textTheme.headlineSmall ,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text("You will loose all your categories, bookmarks."),
                  const SizedBox(height: 30),
                  // Container(
                  //   height: 1,
                  //   width: double.infinity,
                  //   color: Colors.black,
                  // ),
                  // SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite - 10, 48), backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite - 10, 48), backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       OutlinedButton(
                  //           onPressed: () => Navigator.pop(context, false),
                  //           child: Text(
                  //             "Cancle",
                  //             style: TextStyle(color: Colors.blue),
                  //           )),
                  //       Container(
                  //         height: 40,
                  //         width: 1,
                  //         color: Colors.black,
                  //       ),
                  //       OutlinedButton(
                  //         onPressed: () => Navigator.pop(context, true),
                  //         child: Text(
                  //           "Yes",
                  //           style: TextStyle(color: kPrimarColor),
                  //         ),
                  //       ),
                  //     ]),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isFirstTime ? "Complete Profile" : "Edit Profile",
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.blueGrey,
            ),
          ),
          // titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.done,
                color: Colors.blueGrey,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  widget.userModel.shopName = _shopNameController.text;
                  widget.userModel.dob = DateTime.parse(_dobController.text);
                  widget.userModel.emailId = _emailController.text;
                  widget.userModel.phoneNo = _phoneController.text;
                  widget.userModel.proprietorName = _ownerNameController.text;
                  widget.userModel.gst = _gstController.text;
                  setState(() {
                    _isLoading = true;
                  });
                  FocusScope.of(context).unfocus();
                  String url = "";
                  if (_image != null) {
                    url = await ApiService()
                        .uploadProfilePhoto(File(_image!.path));
                  }
                  print("url $url");
                  widget.userModel.profilePic = url;
                  bool res = false;
                  if (widget.isFirstTime) {
                    // res = await ApiService().register(widget.userModel);
                  } else {
                    res = await ApiService().updateProfile(widget.userModel);
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  if (res) Navigator.pop(context);

                  // if (result == 'updated') {
                  //   toastMessage("Profile Updated");
                  //   Future.delayed(const Duration(seconds: 1), () {
                  //     Navigator.pop(context, "updated");
                  //   });
                  // }
                } else {
                  // toastMessage("*fields can't be empty");
                }
              },
            ),
          ],
        ),
        body:
            //  FutureBuilder(
            //   future: user,
            //   builder: (BuildContext context,
            //       AsyncSnapshot<Map<String, dynamic>?> snapshots) {
            //     if (snapshots.connectionState == ConnectionState.waiting) {
            //       return Container(
            //         child: const Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     } else if (snapshots.hasError) {
            //       return Container(
            //         child: const Center(
            //           child: Text("Something went wrong"),
            //         ),
            //       );
            //     }
            //     if (snapshots.data!.isEmpty) {
            //       return Container(
            //         child: const Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     }
            //     _emailController.text = snapshots.data!["email"];
            //     _nameController.text = snapshots.data!["name"];
            Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        // color: Colors.red,
                        child: Stack(
                          children: [
                            widget.userModel.profilePic.isNotEmpty &&
                                    _image == null
                                ? buildCircularProfilePhoto(
                                    widget.userModel.profilePic,
                                    appThemeNotifier.darkTheme,
                                    size.height * 0.2,
                                    size.width * 0.3,
                                  )
                                : _image != null
                                    ? SizedBox(
                                        height: size.height * 0.2,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              FileImage(File(_image!.path)),
                                          radius: size.height * 0.3,
                                        ),
                                      )
                                    : buildPlaceholderPhoto(
                                        appThemeNotifier.darkTheme,
                                        size.height * 0.2,
                                        size.width * 0.3,
                                      ),
                            Positioned(
                              left: size.width * 0.55,
                              bottom: 5,
                              child: InkWell(
                                onTap: () async {
                                  String? res = await imagefileChoice(context);
                                  if (res == "gallery") {
                                    _pickGalleryPhoto();
                                  } else if (res == 'camera') {
                                    _pickCameraPhoto();
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 3,
                                          spreadRadius: 1,
                                        )
                                      ]),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      buildHeadLine("Nickname"),
                      buildFormField(
                        _shopNameController,
                        (String? val) {
                          if (val!.isEmpty) {
                            return "Nickname can't be empty";
                          } else {
                            return null;
                          }
                        },
                        "Name",
                      ),

                      const SizedBox(height: 20),
                      buildHeadLine("Birth Day"),
                      TextFormField(
                        controller: _dobController,
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        validator: (String? val) {
                          if (val!.isEmpty) {
                            return "Birth day can't be empty";
                          } else if (DateTime.now().year -
                                  DateTime.parse(val).year <
                              18) {
                            return "18 years below can't register";
                          } else {
                            print(DateTime.parse(val).year);
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          // fillColor: Colors.grey[300],
                          hintText: 'Date of Birth*',
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
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(5),
                          //   borderSide: const BorderSide(
                          //     color: Colors.black,
                          //     width: 2,
                          //   ),
                          // ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildHeadLine("User Name"),
                      buildFormField(_ownerNameController, (val) {
                        if (val!.isEmpty) {
                          return "User name can't be empty";
                        } else {
                          return null;
                        }
                      }, "User Name"),
                      const SizedBox(height: 20),
                      buildHeadLine("GST Number"),
                      buildFormField(_gstController, (val) {
                        if (val!.isEmpty) {
                          return "GST number can't be empty";
                        } else {
                          return null;
                        }
                      }, "Valid GST Number"),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Email",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          GestureDetector(
                            child: const Icon(Icons.edit),
                            onTap: () async {
                              String res = await Navigator.push(
                                context,
                                SlideLeftRoute(
                                    widget: const LoginScreen(isEditing : false)),
                              );
                              if (res != "") {
                                _emailController.text = res;
                              }
                            },
                          )
                        ],
                      ),
                      TextFormField(
                        controller: _emailController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Email Id*',
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
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(5),
                          //   borderSide: const BorderSide(
                          //     color: Colors.black,
                          //     width: 2,
                          //   ),
                          // ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            // borderSide: BorderSide()
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Phone",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          GestureDetector(
                              child: const Icon(Icons.edit),
                              onTap: () async {
                                String res = await Navigator.push(
                                  context,
                                  SlideLeftRoute(
                                      widget: const LoginScreen(isEditing : false)),
                                );
                                if (res != "") {
                                  _phoneController.text = res;
                                }
                              })
                        ],
                      ),
                      TextFormField(
                        controller: _phoneController,
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          // fillColor: Colors.grey[300],
                          hintText: 'Phone Number*',
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
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(5),
                          //   // borderSide: const BorderSide(
                          //   //   color: Colors.black,
                          //   //   width: 2,
                          //   // ),
                          // ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            // borderSide: BorderSide()
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading) loadingAnimation()
          ],
        )
        //     },
        //   ),
        );
  }

  Widget buildHeadLine(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .displayMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget buildFormField(TextEditingController textEditingController,
      String? Function(String? val) validator, String hint) {
    return TextFormField(
      controller: textEditingController,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        // fillColor: Colors.grey[300],
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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

        // disabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5),
        //   // borderSide: const BorderSide(
        //   //   color: Colors.black,
        //   //   width: 2,
        //   // ),
        // ),

        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5),
        // ),
      ),
    );
  }
}


// nextButton("Update", () {
//           UserModel userModel = UserModel.fromJson({
//             "name": 'teja',
//             "emailId": "ashok@gamil.com",
//             "orders": [],
//             "deliveryAddress": [{"point": "dfjak", "address": "jfakljfalk"}],
//             "cartItems": [],
//             "deviceToken": "djflkaja",
//             "dob": 1298782,
//             "profilePic": "dkjfkal",
//             "userType": "customer",
//             "phoneNo": "",
//           });
//           ApiService().post_request(userModel);
//         })