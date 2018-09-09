import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventrips/views/detail.dart';

class Products extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget createProduct(BuildContext context, DocumentSnapshot document) {

    return ListTile(
      title: Row(
        children: [
          new Image.network(document["imageUrl"], fit: BoxFit.contain),
          new Expanded(
            child: Text(document['name'])
          )
        ]
      ),
      onTap: () {
        // launchURL(document['url']);
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => Detail(document)
        );
        Navigator.of(context).push(route);
      }
    );
  }


  // create book tile hero
  createTile(BuildContext context, DocumentSnapshot document) => Hero(
    tag: document['name'],
    child: Material(
      elevation: 15.0,
      shadowColor: Colors.yellow.shade900,
      child: InkWell(
        onTap: () {
          // launchURL(document['url']);
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => Detail(document)
          );
          Navigator.of(context).push(route);
        },
        child: Image.network(document["imageUrl"], fit: BoxFit.cover),
        ),
      ),
  );

  @override
  Widget build(BuildContext context) {
    final stream = StreamBuilder(
      stream: Firestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2 / 3,
                  crossAxisCount: 3,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                ),
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    child: createTile(context, snapshot.data.documents[index]),
                  );
                }, childCount: snapshot.data.documents.length),
              ),
            )
          ]
        );
        // return ListView.builder(
        //   itemExtent: 80.0,
        //   itemCount: snapshot.data.documents.length,
        //   itemBuilder: (context, index) =>
        //     createTile(context, snapshot.data.documents[index])
        // );
      }
    );

    return stream;
  }
}
