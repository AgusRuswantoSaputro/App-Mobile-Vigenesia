import 'package:flutter/material.dart';
import 'Login.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import '/../Constant/const.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Ganti Base URL

  String baseurl = url;
      //"https://429f-175-158-63-74.ngrok-free.app/vigenesia"; // ganti dengan ip address kamu / tempat kamu menyimpan backend

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    var dio = Dio();
    
    dynamic data = {
      "nama": nama,
      "profesi": profesi,
      "email": email,
      "password": password
    };

    try {
      final response = await dio.post("$baseurl/api/registrasi/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeNotifier.themeMode,
      home: Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              //width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Align(
                  alignment: Alignment.topRight,
                child: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                if (themeNotifier.themeMode == ThemeMode.light) {
                    themeNotifier.setTheme(ThemeMode.dark);
                } else {
                    themeNotifier.setTheme(ThemeMode.light);
                    }},),),
                  const SizedBox(height: 40),             
                   GradientText(
                    "Register Your Account",
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    colors: const [ // <- atur warna gradienttext
                  Color.fromARGB(255, 255, 48, 33),
                  Color.fromARGB(255, 255, 223, 43),
                    ],
                  ),
                  const SizedBox(height: 60),
                  SizedBox(width: MediaQuery.of(context).size.width / 1.5,
                  child: FormBuilderTextField(
                    name: "name",
                    controller: nameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: "Nama"),
                  )),
                  const SizedBox(height: 20),
                  SizedBox(width: MediaQuery.of(context).size.width / 1.5,
                  child: FormBuilderTextField(
                    name: "profesi",
                    controller: profesiController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: "Profesi"),
                  )),
                  const SizedBox(height: 20),
                  SizedBox(width: MediaQuery.of(context).size.width / 1.5, height: 50,
                  child: FormBuilderTextField(
                    name: "email",
                    controller: emailController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: "Email"),
                  )),
                  const SizedBox(height: 20),
                  SizedBox(width: MediaQuery.of(context).size.width / 1.5,
                  child: FormBuilderTextField(
                    obscureText: true, // <-- Buat bikin setiap inputan jadi bintang " * "
                    name: "password",
                    controller: passwordController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: "Password"),
                  )),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width /3.2,
                      child: FilledButton.tonal(
                        onPressed: () async {
                          await postRegister(
                                  nameController.text,
                                  profesiController.text,
                                  emailController.text,
                                  passwordController.text)
                              .then((value) => {
                                    if (value != null)
                                      {
                                        setState(() {
                                          Navigator.pop(context);
                                          Flushbar(
                                            message: "Berhasil Registrasi",
                                            duration: const Duration(seconds: 2),
                                            backgroundColor: Colors.greenAccent,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                          ).show(context);
                                        })
                                      }
                                    else if (value == null)
                                      {
                                        Flushbar(
                                          message:
                                              "Check Your Field Before Register",
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: const Color.fromARGB(255, 255, 117, 82),
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context)
                                      }
                                  });
                        },
                        child: const Text("Sign up", 
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,height: 2.2))),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'have an account ? ',
                                  //style: TextStyle(color: Color.fromARGB(136, 24, 24, 24)),
                                ),
                                TextSpan(
                                    text: 'Sign in',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Login()));
                                      },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      //color: Color.fromARGB(255, 255, 209, 81),
                                    )),
                              ],
                            )),
              ],
              ),
            ),
          ),
        ),
      ),
    ));
  });
}
}