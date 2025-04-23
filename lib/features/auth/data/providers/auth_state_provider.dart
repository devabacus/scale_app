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
    final authRepository = ref.watch(authRepositoryProvider);
    _authStateSubscription?.cancel();
    final stream = authRepository.authStateChanges();
    _authStateSubscription = stream.listen(
      (user) {
        state = AsyncData(user);
      },
      onError: (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });

    try {
      // ждем первое событие или ошибку из потока
      final initialUser = await stream.first;
      return initialUser;
    } catch (e, _) {
      return null;
    }
  }


 Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e, _) {
      rethrow;
    }
  }
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncLoading(); // Устанавливаем загрузку
    try {
      await ref
          .read(authRepositoryProvider)
          .signUpWithEmailAndPassword(email: email, password: password);
    } catch (e, _) {
      rethrow;
    }
  }


  Future<void> signOut() async {
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }

}
