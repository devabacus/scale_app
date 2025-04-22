
import '../../presentation/pages/auth_page.dart';
import 'auth_routes_constants.dart';

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


List<RouteBase> getAuthRoutes() {
  return [
    GoRoute(
      name: AuthRoutes.auth,
      path: AuthRoutes.authPath,
      builder: (BuildContext context, state) => AuthPage(),
    ),
  ];
}


