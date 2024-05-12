import 'package:ali33/screens/login.dart';
import 'package:ali33/services/api_service.dart';
import 'package:flutter/material.dart';

import 'package:ali33/models/user_model.dart'; // Import your UserModel class

class UserService {
  late int userKey;

  static Future<UserModel?> authenticateUser(BuildContext context) async {
    ApiService apiService = ApiService();
    UserModel? user = await apiService.getCurrentUser();
    if (user != null) {
      return user; 
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen(isEditing: false,)),
      );
      return null; // Return null since there's no user
    }
  } 
}