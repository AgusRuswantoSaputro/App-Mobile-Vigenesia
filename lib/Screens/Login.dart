import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    title:
    'First App';
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.home),
        title: Text('Visi Generasi Indonesia'),
      ),
      body: SingleChildScrollView(
          child: Container(
              color: Colors.redAccent,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login Area-Security System',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ))),
    );
  }
}