import 'package:flutter/material.dart';
import 'package:untitled2/login.dart';
import 'package:untitled2/main.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
          const Text(
            'Login Successfull',
            style: TextStyle(fontSize: 35),
          ),
          ElevatedButton(
            onPressed: () {
              auth.signOut();
              if (auth.currentUser == null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
              }
            },
            child: const Text('Sign out'),
          ),
        ]),
      ),
    );
  }
}
