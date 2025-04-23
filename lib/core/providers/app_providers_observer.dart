// Можно создать файл в core/providers/app_provider_observer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}
''');
  }

//   @override
//   void didAddProvider(
//     ProviderBase<Object?> provider,
//     Object? value,
//     ProviderContainer container,
//   ) {
//     debugPrint('''
// {
//   "provider": "${provider.name ?? provider.runtimeType}",
//   "value": "$value"
// }
// ''');
//   }

//   @override
//   void didDisposeProvider(
//     ProviderBase<Object?> provider,
//     ProviderContainer container,
//   ) {
//     debugPrint('''
// {
//   "provider": "${provider.name ?? provider.runtimeType}",
//   "action": "disposed"
// }
// ''');
  // }
}