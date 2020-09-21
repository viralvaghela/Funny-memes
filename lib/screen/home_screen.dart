import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esys_flutter_share/esys_flutter_share.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "https://meme-api.herokuapp.com/gimme";
  String imgUrl = "https://i.redd.it/e7upcwi0y8o51.jpg";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //getMeme();
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

  void shareImage() async {
    setState(() {
      isLoading = true;
    });
    var request = await HttpClient().getUrl(Uri.parse(imgUrl));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);

    await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
    setState(() {
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
                    child:
                        imgUrl != null ? Image.network("$imgUrl") : Container(),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.share),
        onPressed: () {
          shareImage();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                getMeme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
