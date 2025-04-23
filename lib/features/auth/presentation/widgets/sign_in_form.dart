import 'package:firebase_auth/firebase_auth.dart'; // Для FirebaseAuthException
import 'package:flutter/material.dart';
// Импортируем хуки и хуки для Riverpod
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Импортируем провайдер состояния для вызова методов
import '../../data/providers/auth_state_provider.dart';

/// Виджет, отображающий форму для входа и регистрации пользователя.
/// Использует хуки для управления состоянием и контроллерами.
class SignInForm extends HookConsumerWidget { // Заменяем на HookConsumerWidget
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Используем хуки ---
    // Хук для TextEditingController (автоматически утилизируется)
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // Хук для управления состоянием isLoading (тип bool)
    final isLoading = useState(false);

    // Хук для управления состоянием errorMessage (тип String?)
    final errorMessage = useState<String?>(null);

    // Хук для создания GlobalKey<FormState> (гарантирует, что ключ не пересоздается)
    final formKey = useMemoized(() => GlobalKey<FormState>());
    // -----------------------


    // --- Методы действий ---
    Future<void> signIn() async {
      if (!formKey.currentState!.validate()) return;

      // Обновляем состояние хуков через .value
      isLoading.value = true;
      errorMessage.value = null;

      try {
        await ref.read(authStateNotifierProvider.notifier).signInWithEmailAndPassword(
              emailController.text.trim(),
              passwordController.text.trim(),
            );
      } on FirebaseAuthException catch (e) {
          // Обновляем состояние ошибки через .value
          errorMessage.value = e.message ?? 'Произошла ошибка входа';
      } finally {
        // Проверка на mounted все еще полезна перед обновлением состояния после await
         if (context.mounted) {
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
      } on FirebaseAuthException catch (e) {
          errorMessage.value = e.message ?? 'Произошла ошибка регистрации';
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }
    // -----------------------

    // --- UI виджета ---
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey, // Используем ключ из useMemoized
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController, // Используем контроллер из хука
              decoration: const InputDecoration(labelText: 'Почта'),
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Пожалуйста, введите email';
                if (!value.contains('@') || !value.contains('.')) return 'Введите корректный email адрес';
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordController, // Используем контроллер из хука
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Пожалуйста, введите пароль';
                if (value.length < 6) return 'Пароль должен быть не менее 6 символов';
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Используем .value для доступа к значению состояния из хука
            if (errorMessage.value != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  errorMessage.value!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            // Используем .value для доступа к значению состояния из хука
            if (isLoading.value)
              const CircularProgressIndicator()
            else ...[
              ElevatedButton(
                onPressed: signIn, // Вызываем локальную функцию signIn
                child: const Text('Войти'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: register, // Вызываем локальную функцию register
                style: ElevatedButton.styleFrom( /* Стиль */ ),
                child: const Text('Регистрация'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}