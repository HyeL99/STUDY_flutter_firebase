import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPhonePage extends StatefulWidget {
  const LoginPhonePage({super.key});

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  bool _codeSent = false;
  late String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase - auth:phone')),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                inputForm('p'),
                const SizedBox(height: 15),
                _codeSent ? const SizedBox.shrink() : submitButton(),
                const SizedBox(height: 15),
                _codeSent ? inputForm('s') : const SizedBox.shrink(),
                const SizedBox(height: 15),
                _codeSent ? verifyButton() : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField inputForm(String type) {
    return TextFormField(
      controller: type == 'p' ? _phoneController : type == 's' ? _smsCodeController : null,
      autofocus: true,
      validator: (value) {
        if(value!.isEmpty){
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: "Input your ${type == 'p' ? 'phone number' : type == 's' ? 'sms code' : null}.",
        labelText: type == 'p' ? 'Phone Number' : type == 's' ? 'SMS code' : null,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if(_key.currentState!.validate()){
          FirebaseAuth auth = FirebaseAuth.instance;
          print(_phoneController.text.replaceRange(0, 1, '+82 '));
          await auth.verifyPhoneNumber(
            // forceResendingToken: _resendToken,
            phoneNumber: _phoneController.text.replaceRange(0, 1, '+82'),
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential).then((_) => Navigator.pushNamed(context, '/'));
            },
            verificationFailed: (FirebaseAuthException error) {
              if(error.code == 'invalid-phne-number'){
                print('The provided phone number is not valid.');
              } else {
                print('!!Error!! : ${error.code}');
              }
            },
            codeSent: (String verificationId, forceResendingToken) async {
              print('!!!인증 보낸당!!!');
              String smsCode = _smsCodeController.text;
              setState(() {
                _codeSent = true;
                _verificationId = verificationId;
              });
            },
            codeAutoRetrievalTimeout: (verificationId) {
              print('handling code auto retrieval timeout');
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Text('Send SMS Code', style: TextStyle(fontSize: 18),),
      )
    );
  }

  ElevatedButton verifyButton() {
    return ElevatedButton(
      onPressed: () async {
        FirebaseAuth auth = FirebaseAuth.instance;

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _smsCodeController.text
        );

        print('!!보내!! ${_verificationId}, ${_smsCodeController.text}');

        await auth.signInWithCredential(credential).then((value) => Navigator.pushNamed(context, '/'));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Text('Verify', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}