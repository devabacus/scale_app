import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../home/presentation/routing/home_routes_constants.dart';
import '../../data/providers/auth_state_provider.dart';
import '../utils/error_handler.dart'; 

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
          if (context.mounted) {
          context.goNamed(HomeRoutes.home);  
    }
      } on FirebaseAuthException catch (e, s) {
      final message = mapFirebaseAuthExceptionToMessage(e);
      if (context.mounted) {
        errorMessage.value = message; // Обновляем ошибку
      } else {
      }
    } catch (e, s) {
       if (context.mounted) {
       } else {
         print(">>> SignInForm: Widget disposed before setting error message.");
       }
       print('Stack trace: $s');
    } finally {
      // Проверяем context.mounted ПЕРЕД обновлением isLoading
      if (context.mounted) {
        isLoading.value = false; // Убираем индикатор загрузки
      } else {
        print(">>> SignInForm: Widget disposed before setting isLoading=false in finally.");
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
        errorMessage.value = mapFirebaseAuthExceptionToMessage(e); 
      } catch (e) {
        errorMessage.value = 'Произошла непредвиденная ошибка: $e';
        print('SignUp Error: $e');
      } finally {
        if (context.mounted) {
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
                onPressed: isLoading.value ? null : signIn, 
                child: const Text('Войти'),
              ),
              AppGap.m(),
              TextButton( 
                onPressed: isLoading.value ? null : register, 
                child: const Text('Регистрация'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}