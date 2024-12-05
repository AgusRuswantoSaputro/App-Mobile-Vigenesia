import 'dart:convert';
import '/main.dart';
import '/../Constant/const.dart';
import 'package:provider/provider.dart';
import '/../Models/Motivasi_Model.dart';
import '/../Screens/EditPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Login.dart';
import 'package:another_flushbar/flushbar.dart';

class MainScreens extends StatefulWidget {
  final String? nama;
  final String? iduser;

const MainScreens({super.key, this.nama, this.iduser});

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
      // ganti dengan ip address kamu / tempat kamu menyimpan backend
  String? id;
  var dio = Dio();
  List<MotivasiModel> ass = [];
  TextEditingController titleController = TextEditingController();

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.iduser,
    };
    print("test${widget.iduser}");
    try {
      final response = await dio.post(
        "$baseurl/api/dev/POSTmotivasi/",
        data: body,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            contentType: Headers.formUrlEncodedContentType),
      ); // Formatnya Harus Form Data
      print("Respon -> ${response.data} + ${response.statusCode}");

      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  List<MotivasiModel> listproduk = [];

  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get('$baseurl/api/Get_motivasi/');

    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };
    var response = await dio.delete('$baseurl/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {"Content-type": "application/json"}));

    print(" ${response.data}");

    var resbody = jsonDecode(response.data);
    return resbody;
  }

  Future<void> _getData() async {
    setState(() {
      getData();
    });
  }

  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    _getData();
  }

  String? trigger;
  String? triggeruser;

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
        // <-- Berfungsi Untuk  Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // <-- Berfungsi untuk  atur nilai X jadi tengah
                  children: [
                    Row(   
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child:
                        Text(
                          "Hallo ${widget.nama}",
                          style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis),
                        )),
                        //Spacer(),
                        IconButton(
                          icon: const Icon(Icons.brightness_6),
                          onPressed: () {
                          ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                          if (themeNotifier.themeMode == ThemeMode.light) {
                              themeNotifier.setTheme(ThemeMode.dark);
                          } else {
                          themeNotifier.setTheme(ThemeMode.light);
                          }},
                          ),
                        IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Login()));
                            }),
                          ],
                          ),
                    const SizedBox(height: 40), // <-- Kasih Jarak Tinggi : 50px
                    FormBuilderTextField(
                      controller: isiController,
                      name: "isi_motivasi",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: 'Isi Motivasi Disini',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.2,
                      child: FilledButton.tonal(
                          onPressed: () async {
                            await sendMotivasi(isiController.text.toString())
                                .then((value) => {
                                      if (value != null)
                                        {
                                          Flushbar(
                                            message: "Berhasil Submit",
                                            duration: const Duration(seconds: 2),
                                            backgroundColor: Colors.greenAccent,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                          ).show(context)
                                        }
                                    });

                            _getData();
                            print("Sukses");
                          },
                          child: const Text("Submit",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,height: 2.2))),
                    ),

                    const SizedBox(height: 30,),

                    TextButton(
                      child: const Icon(Icons.refresh),
                      onPressed: () {
                        _getData();
                      },
                    ),
                    FutureBuilder(
                      future: getData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<MotivasiModel>> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                for (var item in snapshot.data!)
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width / 7.0,
                                    width: MediaQuery.of(context).size.width ,
                                    child: Card(
                                      elevation: 0,
                                      child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(child :
                                              Text(item.isiMotivasi.toString(),
                                                    style: const TextStyle(fontSize:14),
                                                    overflow:TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,)),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.settings),
                                                    onPressed: () {
                                                      String id;
                                                      String isiMotivasi;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext context) =>
                                                                EditPage(
                                                                    id: item.id,
                                                                    isi_motivasi:item.isiMotivasi),
                                                          ));
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete),
                                                    onPressed: () {
                                                      deletePost(item.id!)
                                                          .then((value) => {
                                                                if (value !=null)
                                                                  {
                                                                    Flushbar(
                                                                      message:
                                                                          "Berhasil Delete",
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              2),
                                                                      backgroundColor:
                                                                           const Color.fromARGB(255, 255, 117, 82),
                                                                      flushbarPosition:
                                                                          FlushbarPosition
                                                                              .TOP,
                                                                    ).show(
                                                                        context)
                                                                  }
                                                              });
                                                      _getData();

                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ))],
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            return const Text("No Data");
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                  ]),
            ),
          ),
        ),
      ),
    ));
  });
}
}