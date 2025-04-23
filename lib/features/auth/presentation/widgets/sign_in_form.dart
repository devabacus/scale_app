// lib/features/auth/presentation/widgets/sign_in_form.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

// Импортируем провайдер состояния и утилиту для ошибок
import '../../data/providers/auth_state_provider.dart';
import '../utils/error_handler.dart'; // <-- Импортируем хелпер

/// Виджет, отображающий форму для входа и регистрации пользователя.
/// Использует хуки для управления состоянием и контроллерами.
class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    Future<void> signIn() async {
      if (!formKey.currentState!.validate()) return;
      isLoading.value = true;
      errorMessage.value = null;

      try {
        await ref.read(authStateNotifierProvider.notifier).signInWithEmailAndPassword(
              emailController.text.trim(),
              passwordController.text.trim(),
            );
        // Примечание: Навигация теперь обрабатывается GoRouter'ом
      } on FirebaseAuthException catch (e) {
        // Используем хелпер для получения сообщения об ошибке
        errorMessage.value = mapFirebaseAuthExceptionToMessage(e); // <-- Используем хелпер
      } catch (e) {
        // Обработка других возможных ошибок
        errorMessage.value = 'Произошла непредвиденная ошибка: $e';
        print('SignIn Error: $e');
      } finally {
        if (context.mounted) { // Проверка mounted остается важной
          isLoading.value = false;
        }
      }
    }

    Future<void> register() async {
      if (!formKey.currentState!.validate()) return;
      isLoading.value = true;
      errorMessage.value = null;

      try {
        await ref.read(authStateNotifierProvider.notifier).signUpWithEmailAndPassword(
              emailController.text.trim(),
              passwordController.text.trim(),
            );
         // Примечание: Навигация теперь обрабатывается GoRouter'ом
      } on FirebaseAuthException catch (e) {
         // Используем хелпер для получения сообщения об ошибке
        errorMessage.value = mapFirebaseAuthExceptionToMessage(e); // <-- Используем хелпер
      } catch (e) {
        // Обработка других возможных ошибок
        errorMessage.value = 'Произошла непредвиденная ошибка: $e';
        print('SignUp Error: $e');
      } finally {
        if (context.mounted) { // Проверка mounted остается важной
           isLoading.value = false;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Почта'),
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Пожалуйста, введите email';
                if (!value.contains('@') || !value.contains('.')) return 'Введите корректный email адрес';
                return null;
              },
            ),
            
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Пожалуйста, введите пароль';
                if (value.length < 6) return 'Пароль должен быть не менее 6 символов';
                // Сюда можно добавить более строгую валидацию пароля при необходимости
                return null;
              },
            ),
            AppGap.l(),
            if (errorMessage.value != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errorMessage.value!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            if (isLoading.value)
              const CircularProgressIndicator()
            else ...[
              ElevatedButton(
                onPressed: isLoading.value ? null : signIn, // Блокируем кнопку во время загрузки
                child: const Text('Войти'),
              ),
              AppGap.m(),
              TextButton( // Можно использовать TextButton для менее акцентного действия
                onPressed: isLoading.value ? null : register, // Блокируем кнопку во время загрузки
                child: const Text('Регистрация'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}