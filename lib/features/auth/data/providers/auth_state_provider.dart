import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scale_app/features/auth/data/providers/repository_providers.dart';

part 'auth_state_provider.g.dart';

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  StreamSubscription<User?>? _authStateSubscription;

  @override
  FutureOr<User?> build() async {
    ref.keepAlive();
    // получаем репозиторий
    final authRepository = ref.watch(authRepositoryProvider);

    // отменяем предыдущую подписку при перестроении или удалении
    _authStateSubscription?.cancel();

    // слушаем поток изменений состояния аутентификации
    final stream = authRepository.authStateChanges();

    // подписываемся на поток
    stream.listen(
      (user) {
        state = AsyncData(user);
      },
      onError: (error, stackTrace) {
        print('Auth state Stream Error: $Error');
        state = AsyncError(error, stackTrace);
      },
    );

    //Убеждаемся что подписка отменяется при удалении Notifier
    ref.onDispose(() {
      _authStateSubscription?.cancel();
      print("AuthStateNotifier disposed, stream cancelled");
    });

    try {
      // ждем первое событие или ошибку из потока
      final initialUser = await stream.first;
      return initialUser;
    } catch (e, s) {
      // если при получении первого значения возникла ошибка
      print('Error fetching initial auth state: $e');
      state = AsyncError(e, s);
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    });
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signUpWithEmailAndPassword(email: email, password: password);
    });
  }
}
