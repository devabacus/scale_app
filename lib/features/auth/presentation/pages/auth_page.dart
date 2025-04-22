import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatelessWidget {
 const AuthPage({super.key});

 @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: StreamBuilder<User?>(
     stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
       return const Center(child: CircularProgressIndicator());
      }
    
      final user = snapshot.data;
      if (user == null) {
       return const SignInScreen();
      } else {
       return ProfileScreen(user: user);
      }
     },
    ),
  );
 }
}

class SignInScreen extends StatefulWidget {
 const SignInScreen({super.key});

 @override
 State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();
 String? errorMessage;

 @override
 Widget build(BuildContext context) {
  return Padding(
   padding: const EdgeInsets.all(16),
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     TextField(
      controller: emailController,
      decoration: const InputDecoration(labelText: 'Почта'),
     ),
     TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Пароль'),
     ),
     const SizedBox(height: 16),
     if (errorMessage != null)
      Text(
       errorMessage!,
       style: const TextStyle(color: Colors.red),
      ),
     const SizedBox(height: 16),
     ElevatedButton(
      onPressed: _signIn,
      child: const Text('Sign In'),
     ),
     ElevatedButton(
      onPressed: _register,
      child: const Text('Register'),
     ),
    ],
   ),
  );
 }

 Future<void> _signIn() async {
  try {
   await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
   );
   // Clear error message on successful sign-in
   setState(() {
    errorMessage = null;
   });
  } on FirebaseAuthException catch (e) {
   setState(() {
    errorMessage = e.message;
   });
  }
 }

 Future<void> _register() async {
  try {
   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
   );
   // Clear error message on successful registration
   setState(() {
    errorMessage = null;
   });
  } on FirebaseAuthException catch (e) {
   setState(() {
    errorMessage = e.message;
   });
  }
 }
}

class ProfileScreen extends StatelessWidget {
 final User user;

 const ProfileScreen({super.key, required this.user});

 @override
 Widget build(BuildContext context) {
  return Center(
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Text('Signed in as: ${user.email ?? 'Anonymous'}'),
     const SizedBox(height: 16),
     ElevatedButton(
      onPressed: () async {
       await FirebaseAuth.instance.signOut();
      },
      child: const Text('Sign Out'),
     ),
    ],
   ),
  );
 }
}