import 'package:flutter/material.dart';
import 'package:vallidator/services/auth_service.dart';

/* 
  * This function checks if the user is logged in and has the correct permission
  * to access the route. If the user is not logged in, they are redirected to
  * the login screen. 
  * 

  * @param context The context of the current screen
  * @param route The route to redirect to if the user is logged in
  */
void rerouteWithPermission(BuildContext context, {required String route}) {
  AuthService authService = AuthService();
  authService.getPermission().then((String perm) {
      if (perm != "") {
        print("User is logged in with permission: $perm");
        Navigator.pushReplacementNamed(context, route, arguments: perm);
      }
    }).catchError((error) {
      print('User not logged in');
    });
}