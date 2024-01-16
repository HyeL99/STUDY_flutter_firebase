import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './home.dart';
import './LoginPhone.dart';
import './firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

/*
  ----------------------------------------
    * Wrap with blah 커맨드 open 방법 *
    ctrl + .

    * 템플릿 생성 단축키 *
    stf + tab
  ----------------------------------------
*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase - auth:phone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPhonePage()
      },
    );
  }
}