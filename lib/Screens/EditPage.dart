import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '/../Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import '/main.dart';



class EditPage extends StatefulWidget {
  final String? id;
  final String? isi_motivasi;
  const EditPage({super.key, this.id, this.isi_motivasi});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = url;
      //"http://localhost:8000"; // ganti dengan ip address kamu / tempat kamu menyimpan backend

  var dio = Dio();
  Future<dynamic> putPost(String isiMotivasi, String ids) async {
    Map<String, dynamic> data = {"isi_motivasi": isiMotivasi, "id": ids};
    var response = await dio.put('$baseurl/api/dev/PUTmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    print("---> ${response.data} + ${response.statusCode}");

    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: GlobalThemData.lightThemeData,
      darkTheme: GlobalThemData.darkThemeData,
      home: Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
      ),
      body: SafeArea(
          child: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${widget.isi_motivasi}"),
                const SizedBox(height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: FormBuilderTextField(
                    name: "isi_motivasi",
                    controller: isiMotivasiC,
                    decoration: const InputDecoration(
                      labelText: "Motivasi Baru",
                     border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FilledButton.tonal(
                    onPressed: () {
                      putPost(isiMotivasiC.text, widget.id.toString())
                          .then((value) => {
                                if (value != null)
                                  {
                                    Navigator.pop(context),
                                    Flushbar(
                                      message: "Berhasil Update & Refresh dlu",
                                      duration: const Duration(seconds: 5),
                                      backgroundColor: Colors.green,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    ).show(context)
                                  }
                              });
                    },
                    child: const Text("Submit",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,height: 2.2,color: Color.fromARGB(255, 255, 249, 248)))),
              ],
            ),
          ),
        ),
      )),
    ));
  }
}
