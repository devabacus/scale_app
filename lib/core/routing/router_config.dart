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
    final listenable = ValueNotifier<int>(0);
  ref.listen(authStateNotifierProvider, (_, next) {
    if (!next.isLoading) {
      listenable.value++;
    }
  });


  return GoRouter(
    // observers: [TalkerRouteObserver(log.talker)],
    initialLocation: AuthRoutes.authPath,
    refreshListenable: listenable, // Говорим роутеру слушать изменения
    routes: [
      ...getAuthRoutes(), // Маршруты аутентификации
      ...getHomeRoutes(), // Маршруты главного экрана
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authStateNotifierProvider);
      final location =
          state.uri.toString(); // Или state.matchedLocation / state.location
      final isAuth = authState.hasValue && authState.value != null;
      final isAuthRoute =
          location ==
          AuthRoutes.authPath; // Или сравнение с state.matchedLocation

      if (authState.isLoading) {
        return null;
      }
      if (authState.hasError) {
        return null; 
      }

      if (!isAuth && !isAuthRoute) {
        return AuthRoutes.authPath;
      }

      if (isAuth && isAuthRoute) {
        return HomeRoutes.homePath; // <-- Должен вернуть это значение
      }
      return null;
    },
  );
}
