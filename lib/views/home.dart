import 'package:ventrips/mocks/data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ventrips/shared/products.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //app bar
    final appBar = AppBar(
      elevation: .5,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
      ),
      title: Text('Design Books'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
    );

    // create book tile hero
    createTile(Book book) => Hero(
      tag: book.title,
      child: Material(
        elevation: 15.0,
        shadowColor: Colors.yellow.shade900,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, 'detail/${book.title}');
          },
          child: Image(
            image: AssetImage(book.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    // create book grid tiles
    final grid = CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverGrid.count(
            childAspectRatio: 2 / 3,
            crossAxisCount: 3,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            children: books.map((book) => createTile(book)).toList(),
          ),
        )
      ],
    );

    // createTile(DocumentSnapshot document) => Hero(
    //   tag: document['name'],
    //   child: Material(
    //     elevation: 15.0,
    //     shadowColor: Colors.yellow.shade900,
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.pushNamed(context, "detail/${document['name']}");
    //       //  launchURL(document['url']);
    //       },
    //       child: Image.network(
    //         document["imageUrl"],
    //         fit: BoxFit.contain
    //       ),
    //     ),
    //   ),
    // );

    // final stream = StreamBuilder(
    //   stream: Firestore.instance.collection('products').snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) return const Text('Loading...');
    //     return ListView.builder(
    //       itemExtent: 80.0,
    //       itemCount: snapshot.data.documents.length,
    //       itemBuilder: (context, index) =>
    //         createTile(snapshot.data.documents[index])
    //     );
    //   }
    // );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar,
      body: grid,
    );
  }
}
