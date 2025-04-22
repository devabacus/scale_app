
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_navigation_service.dart';

part 'auth_navigation_provider.g.dart';

@riverpod
AuthNavigationService authNavigationService(Ref ref) {
  return AuthNavigationService();
}

