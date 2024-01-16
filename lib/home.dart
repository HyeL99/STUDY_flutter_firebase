import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './LoginPhone.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        if(!user.hasData){
          return const LoginPhonePage();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Firebase - auth:phone'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async => await FirebaseAuth.instance.signOut().then((value) => Navigator.pushNamed(context, '/'))
                )
              ],
            ),
            body: const Center(child: Text("Successfully logged in!")),
          );
        }
      },
    );
  }
}