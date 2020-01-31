import 'package:flutter/material.dart';
// import 'package:share/share.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';


class Article extends StatefulWidget {
  var details;
  Article(this.details);
  @override
  _ArticleState createState() => _ArticleState(details);
}

class _ArticleState extends State<Article> {
  var details;
  _ArticleState(this.details);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(1),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 225,
                      width: double.infinity,
                      child: details['news_image'] == null ? Text('No Image Available', style: TextStyle(fontSize: 25)) : Image.network(details['news_image'], fit: BoxFit.cover,),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(5)),
                          Text('${details['news_title']}', style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
                          Padding(padding: EdgeInsets.all(5)),
                          // Text('Source: ${details['source']['name']}', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          Text('📅 ${details['news_date']}', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          Divider(thickness: 1, color: Colors.blue,),
                          Padding(padding: EdgeInsets.all(5)),
                          Html(data: details['news_description']),
                          Padding(padding: EdgeInsets.all(5)),
                          // GestureDetector(
                          //   child: Text('more', style: TextStyle(color: Colors.teal, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          //   onTap: (() => launch(details['url'])),
                          // ),
                          Padding(padding: EdgeInsets.all(15)),
                        ],
                      ),
                    )
                    
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: GestureDetector(
                  child: Icon(Icons.arrow_back, size: 30, color: Colors.blue,),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10),),
                        RaisedButton(
                          onPressed: () {setState(() {
                            // Share.share('${details['title']}\n${details['url']}');
                          });},
                          child: Icon(Icons.share, color: Colors.white,),
                          color: Colors.blue,
                          shape: CircleBorder(),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(100),)
                  ],
                ),
              )
            ]
             
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {setState(() {
      //     Share.share('${details['title']}\n${details['url']}');
      //   });},
      //   child: Icon(Icons.share, color: Colors.white),      
      // ),
    );
  }
}