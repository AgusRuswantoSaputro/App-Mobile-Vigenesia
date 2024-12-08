import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  

class _MainScreensState extends State<MainScreens> with SingleTickerProviderStateMixin{
  String baseurl = url;
      // ganti dengan ip address kamu / tempat kamu menyimpan backend
  String? id;
  var dio = Dio();
  List<MotivasiModel> ass = [];
  //TextEditingController titleController = TextEditingController();

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
    var response = await dio.get('$baseurl/api/Get_motivasi/?iduser=${widget.iduser}');

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

      Future<List<MotivasiModel>> getDataG() async {
    var response = await dio.get('$baseurl/api/Get_motivasi'); // Ngambil by ALL USER
    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers = getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
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
    listproduk.clear();
    Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      getData();
    });
  }

  late final TabController _tabController;
  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getData();
    getDataG();
    _getData();
  }

    @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //String? trigger;
  //String? triggeruser;

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){_showAlertDialog(context);},
          elevation: 0,
          //hoverElevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          label: const Text('Buat',style: TextStyle(fontWeight: FontWeight.bold),),
          icon: const Icon(Icons.add,size: 30),
        ),
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk  Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // <-- Berfungsi untuk  atur nilai X jadi tengah
                  children: <Widget>[
                    Row(   
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child:Text(
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
                            }
                            ),

                         ]
                          ),
                    const SizedBox(height: 10),
                    SizedBox(height: 50,
                      child: TabBar(controller: _tabController,
                        tabAlignment: TabAlignment.center,
                        indicatorWeight: 4.0,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 60,vertical: 10),
                        dividerColor: Colors.transparent,
                        indicatorColor: const Color.fromARGB(255, 255, 0, 0),  
                        unselectedLabelColor: const Color.fromRGBO(255, 203, 59, 1),
                        labelColor: const Color.fromARGB(255, 255, 0, 0),         
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          tabs: const [Text("Global"),
                                 Text("User"),
                                 ],onTap: (tabs){setState(() {
                                   _getData();
                                 });},),
                                ),
                    const SizedBox(height: 10),
                    SizedBox(height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                      SingleChildScrollView(
                      child: FutureBuilder(
                      future: getDataG(),
                      builder: (BuildContext context,
                        AsyncSnapshot<List<MotivasiModel>> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                for (var item in snapshot.data!)
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width / 5,
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
                                                                          "Berhasil Delete & Refresh klik Global atau User",
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
                                                    },),
                                                ],),
                                            ],
                                            ),
                                        ),
                                      ],),
                                  ),
                            ),
                            )],
                            ); 
                          } else if (snapshot.hasData &&
                              snapshot.data!.isEmpty) {
                            return const Text("No Data");
                          } else {
                            return const SizedBox(
                                        height: 100, 
                                          width: 100,
                                        child:Center(
                                          child: CircularProgressIndicator.adaptive(),), 
                                          );
                          }}),
                        ),

                            SingleChildScrollView(
                              child:FutureBuilder(
                              future: getData(),
                              builder: (BuildContext context,
                                AsyncSnapshot<List<MotivasiModel>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        for (var item in snapshot.data!)
                                          SizedBox(
                                            height: MediaQuery.of(context).size.width / 5,
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
                                                                                  "Berhasil Delete & Refresh klik Global atau User",
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
                                                            },)
                                                        ],),
                                                    ],),
                                                ),
                                              ],),
                                          ),
                                    ))],
                                    );
                                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                                    return const Text("No Data");
                                  } else {
                                    return const SizedBox(
                                        height: 100, 
                                          width: 100,
                                        child:Center(
                                          child: CircularProgressIndicator.adaptive(),), 
                                          );
                                  }}),
                                ),
                          ],
                          ),
                          ),                 
                    const SizedBox(height: 5),  
            ]
            ),        
            ),         
          ),
        ),
      ),
        ),
        ); 
  });
}
void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buat Motivasi'),
          content: FormBuilderTextField(
                      controller: isiController,
                      name: "isi_motivasi",
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        labelText: 'Isi Motivasi',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
          actions: <Widget> [            
                    SizedBox(
                    width: MediaQuery.of(context).size.width / 3.2,
                    child: TextButton(
                      onPressed: () {Navigator.of(context).pop();},                   
                      child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,height: 2.2),),
                      ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.2,
                      child: FilledButton.tonal(
                          onPressed: () async {
                            await sendMotivasi(isiController.text.toString())
                                .then((value) => { Navigator.of(context).pop(),
                                      if (value != null)
                                        {
                                          Flushbar(
                                            message: "Berhasil Submit & Refresh klik Global atau User",
                                            duration: const Duration(seconds: 2),
                                            backgroundColor: Colors.greenAccent,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                          ).show(context)
                                        }
                                    });
                                     print("Sukses");}, 
                          child: const Text("Submit",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,height: 2.2))),
                        ),
                  ],
        );
      },
    );
    _getData();
  }
}
