
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/auth_routes_constants.dart';


class AuthNavigationService {
  
  void navigateToAuth(BuildContext context){
      context.goNamed(AuthRoutes.auth);
  }

}

