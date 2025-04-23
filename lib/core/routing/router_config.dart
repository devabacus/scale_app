import 'package:flutter/material.dart'; // Добавь этот импорт
// ignore_for_file: unused_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mlogger/mlogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../features/auth/data/providers/auth_state_provider.dart'; // Добавь этот импорт
import '../../features/auth/presentation/routing/auth_router_config.dart';
import '../../features/auth/presentation/routing/auth_routes_constants.dart';
import '../../features/home/presentation/routing/home_router_config.dart';
import '../../features/home/presentation/routing/home_routes_constants.dart';
import './routes_constants.dart';

part 'router_config.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {

  return GoRouter(
    // observers: [TalkerRouteObserver(log.talker)],
    initialLocation: AuthRoutes.authPath,
    routes: [
      ...getAuthRoutes(), // Маршруты аутентификации
      ...getHomeRoutes(), // Маршруты главного экрана
    ],
  );
}