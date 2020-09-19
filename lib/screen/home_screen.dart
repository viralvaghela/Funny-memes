import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "https://meme-api.herokuapp.com/gimme";
  String imgUrl;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getMeme();
  }
  void saveImage() async {
    var response = await http.get(imgUrl);
    var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
    var savedFile = File.fromUri(Uri.file(filePath));
    print(savedFile);
  }
  void getMeme() async {
    var responseData = await http.get(url);
    var jsonData = jsonDecode(responseData.body);

    setState(() {
      imgUrl = jsonData['url'];
      print(imgUrl);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Funny Meme"),
        elevation: 0.0,
      ),
      body: isLoading != true
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Image.network("$imgUrl"),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      getMeme();
                    },
                    child: Text(
                      "Next",
                    ),
                  ),
                  FloatingActionButton(onPressed: (){saveImage();})
                ],
              
              ),
              
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Share.share(imgUrl,subject: "Check out this funnt meme");
        },
        child: Icon(Icons.share),
      ),
    );
  }
}
