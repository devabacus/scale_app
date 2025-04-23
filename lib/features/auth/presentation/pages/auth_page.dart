import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Нужен для типа User

// Импортируем провайдер состояния
import '../../data/providers/auth_state_provider.dart';
// Импортируем разделенные виджеты
import '../widgets/sign_in_form.dart'; // Измененный путь и имя
import '../widgets/profile_display.dart'; // Измененный путь и имя

/// Главный виджет страницы аутентификации.
/// Использует Riverpod для отслеживания состояния аутентификации
/// и отображает либо форму входа/регистрации, либо экран профиля.
class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      body: authState.when(
        data: (user) {
          // Если пользователь вошел, показываем профиль
          if (user != null) {
            // Используем новый виджет ProfileDisplay
            return ProfileDisplay(user: user);
          }
          // Если пользователь не вошел, показываем форму входа
          else {
            // Используем новый виджет SignInForm
            return const SignInForm();
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
        print("AuthPage: Caught global auth state error: $error. Displaying SignInForm.");
          return const SignInForm();

        },
      ),
    );
  }
}