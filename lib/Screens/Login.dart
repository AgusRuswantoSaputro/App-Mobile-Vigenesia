import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:dio/dio.dart';
import 'MainScreens.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';
import '/../Constant/const.dart';
import '/../Models/Login_Model.dart';
import '/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? nama;
  String? iduser;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels?> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl =
        url; // ganti dengan ip address kamu / tempat kamu menyimpan backend

    Map<String, dynamic> data = {"email": email, "password": password};

    try {
      final response = await dio.post("$baseurl/api/login/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);

        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
    return null;//<-
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: GlobalThemData.lightThemeData,
      darkTheme: GlobalThemData.darkThemeData,
        home: Scaffold(
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk  Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                
                GradientText(
                  "Boost your mood with Vigenesia!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                  colors: const [ // <- atur warna gradienttext
                  Color.fromARGB(255, 255, 48, 33),
                  Color.fromARGB(255, 255, 223, 43),
                    ],
                  maxLines: 2,
                ),
                const SizedBox(height: 60), // <-- Kasih Jarak Tinggi : 50px
                Center(
                  child: Form(
                    key: _fbKey,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: "email",
                            controller: emailController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                //labelStyle: TextStyle(color: Color.fromARGB(255, 255, 147, 75)),
                                labelText: "Email"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            obscureText:
                                true, // <-- Buat bikin setiap inputan jadi bintang " * "
                            name: "password",
                            controller: passwordController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                //labelStyle: TextStyle(color: Color.fromARGB(255, 255, 147, 75)),
                                labelText: "Password"),
                          ),
                          const SizedBox(height: 30,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Dont Have Account ? ',
                                  //style: TextStyle(color: Color.fromARGB(136, 24, 24, 24)),
                                ),
                                TextSpan(
                                    text: 'Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Register()));
                                      },
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      //color: Color.fromARGB(255, 255, 209, 81),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /3.2,
                            child: FilledButton.tonal(   
                              //style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 255, 0, 0),),),                       
                                onPressed: () async {
                                  await postLogin(emailController.text,
                                          passwordController.text)
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                setState(() {
                                                  var nama = value.data!.nama!;
                                                  var iduser = value.data!.iduser!;
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              MainScreens(
                                                                  nama:nama,
                                                                  iduser: iduser,)));
                                                })
                                              }
                                            else if (value == null)
                                              {
                                                Flushbar(
                                                  message:
                                                      "Check Your Email / Password",
                                                  duration:
                                                      const Duration(seconds: 5),
                                                  backgroundColor:
                                                      const Color.fromARGB(255, 255, 117, 82),
                                                  flushbarPosition:
                                                      FlushbarPosition.TOP,
                                                ).show(context)
                                              }
                                          });
                                },
                                
                            
                                child: const Text("Sign In",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,height: 2.2,color: Color.fromARGB(255, 255, 249, 248))),
                          )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
