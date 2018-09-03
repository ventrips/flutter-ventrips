import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './views/video_cell.dart';

void main() => runApp(new VentripsApp());

class VentripsApp extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return new VentripsState();
    } 
}
class VentripsState extends State<VentripsApp> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List videos = [];

  Future refreshList() async {
    var url = 'https://api.letsbuildthatapp.com/youtube/home_feed';
    http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: {
        "Accept": "application/json"
        // ,"key": "value"
      }
    );

    // Turn off loading indicator
    setState(() {
      this.videos = json.decode(response.body)["videos"];
    });

    return null;
  }

  scanBarCode() {
    print("Scan Bar Code");
  }

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
    Widget build (BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("VENTRIPS"),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.camera_alt),
                onPressed: scanBarCode
              )
            ]
          ),
          body: RefreshIndicator(
            key: refreshKey,
            child: (refreshKey.currentState == null ?
              new Center(child: new CircularProgressIndicator()) :
              ListView.builder(
                itemCount: this.videos?.length,
                itemBuilder: (context, i) {
                  final video = this.videos[i];
                  return new FlatButton(
                    child: new VideoCell(video),
                    onPressed: () {
                      print("Video cell tappe: $i");
                      Navigator.push(context,
                        new MaterialPageRoute(
                          builder: (context) => new DetailPage()
                       )
                      );
                    }
                 );
               }
              )
            ),
            onRefresh: refreshList
          )
        )
      );
    }
}

class DetailPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Detail Page")
        ),
        body: new Center(
          child: new Text("Detail Body")
        )
      );
    }
}