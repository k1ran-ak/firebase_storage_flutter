import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_flutter/firebase_options.dart';
import 'package:firebase_storage_flutter/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Firebase Storage',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: HomeApp(),
  ));
}
