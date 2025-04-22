import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './app.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import '../../../../firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
 );
  await dotenv.load(fileName: ".env");
  runApp(
  ProviderScope(
    observers: [
      TalkerRiverpodObserver(),
    ],
    child: App(),
  )
 );
}


