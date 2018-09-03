import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';

import './views/video_cell.dart';

const String APP_ID = 'ca-app-pub-4642980268605791~9598994286';
const String AD_UNIT_ID = 'ca-app-pub-4642980268605791/8164339717';

MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  birthday: new DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  // gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = new BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: AD_UNIT_ID,
  size: AdSize.banner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = new InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);

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

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: APP_ID);
    // refreshList();
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['title'],
              style: Theme.of(context).textTheme.headline
            )
          )
        ]
      )
    );
  }

  @override
    Widget build (BuildContext context) {
      myBanner
        // typically this happens well before the ad is shown
        ..load()
        ..show(
          // Positions the banner ad 0 pixels from the bottom of the screen
          anchorOffset: -20.0,
          // Banner Position
          anchorType: AnchorType.bottom,
        );

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
          body: StreamBuilder(
            stream: Firestore.instance.collection('items').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index])
              );
            }
          )
          // body: RefreshIndicator(
          //   key: refreshKey,
          //   child: (refreshKey.currentState == null ?
          //     new Center(child: new CircularProgressIndicator()) :
          //     ListView.builder(
          //       itemCount: this.videos?.length,
          //       itemBuilder: (context, i) {
          //         final video = this.videos[i];
          //         return new FlatButton(
          //           child: new VideoCell(video),
          //           onPressed: () {
          //             print("Video cell tappe: $i");
          //             Navigator.push(context,
          //               new MaterialPageRoute(
          //                 builder: (context) => new DetailPage()
          //              )
          //             );
          //           }
          //        );
          //      }
          //     )
          //   ),
          //   onRefresh: refreshList
          // )
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