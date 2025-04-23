import 'package:firebase_auth/firebase_auth.dart';

/// Преобразует FirebaseAuthException в понятное сообщение об ошибке.
String mapFirebaseAuthExceptionToMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return 'Пользователь с таким email не найден.';
    case 'wrong-password':
      return 'Неверный пароль.';
    case 'invalid-email':
      return 'Некорректный формат email адреса.';
    case 'email-already-in-use':
      return 'Этот email уже зарегистрирован.';
    case 'weak-password':
      return 'Пароль слишком слабый. Используйте не менее 6 символов.';
    case 'operation-not-allowed':
      return 'Вход с email/паролем не разрешен.';
    case 'network-request-failed':
       return 'Ошибка сети. Проверьте подключение к интернету.';
    
    default:
      print('Необработанная ошибка Firebase Auth: ${e.code} - ${e.message}');
      return 'Произошла неизвестная ошибка. Попробуйте снова.';
  }
}