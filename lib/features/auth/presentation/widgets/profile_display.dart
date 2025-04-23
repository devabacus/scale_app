import 'package:firebase_auth/firebase_auth.dart'; // Для типа User
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Импортируем провайдер состояния для вызова signOut
import '../../data/providers/auth_state_provider.dart';

/// Виджет, отображающий информацию об аутентифицированном пользователе
/// и предоставляющий кнопку для выхода.
class ProfileDisplay extends ConsumerWidget {
  final User user;

  const ProfileDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Вы вошли как: ${user.email ?? 'Anonymous'}'),
          // Можно добавить другую информацию о пользователе, если она есть
          // Например: Text('UID: ${user.uid}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Вызываем signOut через notifier
              await ref.read(authStateNotifierProvider.notifier).signOut();
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}