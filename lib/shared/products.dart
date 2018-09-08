import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      onTap: () => launchURL(document['url']),      
    );
  }


  @override
  Widget build(BuildContext context) {
    final stream = StreamBuilder(
      stream: Firestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
            createProduct(context, snapshot.data.documents[index])
        );
      }
    );

    return stream;
  }
}
