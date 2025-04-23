import '../../features/home/presentation/routing/home_routes_constants.dart';
import 'package:flutter/material.dart'; // Добавь этот импорт
import '../../features/auth/presentation/routing/auth_routes_constants.dart';
import '../../features/auth/presentation/routing/auth_router_config.dart';
import '../../features/home/presentation/routing/home_router_config.dart';
import '../../features/home/presentation/routing/home_routes_constants.dart'; // Добавь этот импорт
import '../../features/auth/data/providers/auth_state_provider.dart'; // Добавь этот импорт

// ignore_for_file: unused_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mlogger/mlogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import './routes_constants.dart';


part 'router_config.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // Слушаем изменения состояния аутентификации
  final listenable = ValueNotifier<int>(0); // Используем простой ValueNotifier
  ref.listen(authStateNotifierProvider, (_, next) {
    // Уведомляем GoRouter об изменении состояния, когда оно завершится (data, error)
    if (!next.isLoading) {
      listenable.value++; // Просто изменяем значение, чтобы триггернуть refresh
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
      final authState = ref.read(authStateNotifierProvider); // Читаем текущее состояние
      final location = state.uri.toString(); // Текущий путь

      // Во время загрузки состояния аутентификации ничего не делаем
      if (authState.isLoading || authState.hasError) {
        return null;
      }

      final isAuth = authState.valueOrNull != null; // Пользователь аутентифицирован?

      final isAuthRoute = location == AuthRoutes.authPath; // Находится ли пользователь на странице /auth?

      // Если пользователь НЕ аутентифицирован И НЕ находится на странице /auth -> редирект на /auth
      if (!isAuth && !isAuthRoute) {
        return AuthRoutes.authPath; //
      }

      // Если пользователь аутентифицирован И находится на странице /auth -> редирект на /home
      if (isAuth && isAuthRoute) {
        return HomeRoutes.homePath; //
      }

      // Во всех остальных случаях остаемся на текущем месте
      return null;
    },
  );
}