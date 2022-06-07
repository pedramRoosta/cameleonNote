import 'package:cameleon_note/app.dart';
import 'package:cameleon_note/firebase_options.dart';
import 'package:cameleon_note/setup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  runApp(locateService<App>());
}
