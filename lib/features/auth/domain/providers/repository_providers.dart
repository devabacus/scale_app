import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scale_app/features/auth/data/repositories/auth_repository.dart';
import 'package:scale_app/features/auth/data/repositories/firebase_auth_repository.dart';

part 'repository_providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  ref.keepAlive();
  return FirebaseAuth.instance;
}

@riverpod
AuthRepository authRepository(Ref ref) {
  ref.keepAlive();
  final firebaseAuthInstance = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(firebaseAuthInstance);
}