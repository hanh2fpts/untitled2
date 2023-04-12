import 'package:flutter/material.dart';
import 'package:untitled2/login.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/overview.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //print('${auth.currentUser?.uid}');
    return MaterialApp(debugShowCheckedModeBanner: false, home: auth.currentUser?.phoneNumber == '+84327995213' ? const Overview() : const Login());
  }
}
