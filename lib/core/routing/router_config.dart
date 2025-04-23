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
  // Слушаем изменения состояния аутентификации
    final listenable = ValueNotifier<int>(0);
  ref.listen(authStateNotifierProvider, (_, next) {
    // Добавим лог сюда:
    print(">>> ref.listen triggered. State isLoading: ${next.isLoading}, Has Value: ${next.hasValue}");

    if (!next.isLoading) {
      // И сюда:
      print(">>> State finished loading/error. Updating listenable.value");
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
          print('>>> authState.value in redirect: ${authState.value}');
      final isAuth = authState.hasValue && authState.value != null;
      final isAuthRoute =
          location ==
          AuthRoutes.authPath; // Или сравнение с state.matchedLocation

      // Добавляем подробные логи
      print('--- Redirect Check ---');
      print('Current Location: $location (matched: ${state.matchedLocation})');
      print(
        'Auth State: ${authState.runtimeType}, Has Value: ${authState.hasValue}, Is Loading: ${authState.isLoading}, Has Error: ${authState.hasError}',
      );
      print('Is Authenticated (isAuth): $isAuth');
      print('Is Auth Route (isAuthRoute): $isAuthRoute');

      if (authState.isLoading) {
        // Убрал || authState.hasError для чистоты лога при успехе
        print('Redirect Result: null (authState is loading)');
        return null;
      }
      if (authState.hasError) {
        print('Redirect Result: null (authState has error)');
        return null; // Может быть стоит редиректить на страницу ошибки? Но пока оставим так.
      }

      if (!isAuth && !isAuthRoute) {
        print(
          'Redirect Result: ${AuthRoutes.authPath} (User not auth, not on auth route)',
        );
        return AuthRoutes.authPath;
      }

      if (isAuth && isAuthRoute) {
        print(
          'Redirect Result: ${HomeRoutes.homePath} (User is auth, on auth route)',
        );
        return HomeRoutes.homePath; // <-- Должен вернуть это значение
      }

      print('Redirect Result: null (No redirect condition met)');
      return null;
    },
  );
}
