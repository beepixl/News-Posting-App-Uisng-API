import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:news_posting_app/CategoryAdd.dart';
import 'package:news_posting_app/Profile.dart';

import 'Article.dart';
import 'NewsAdd.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  var data, categoryData;
  var url = 'http://news.raushanjha.in/flutterapi/news';
  var categoryUrl = 'http://news.raushanjha.in/flutterapi/category';

  Future<String> getJsonData() async {
    var response = await http.get(Uri.encodeFull(url));
    var catresponse = await http.get(Uri.encodeFull(categoryUrl));
    setState(() {
      data = json.decode(response.body);
      categoryData = json.decode(catresponse.body);
    });

      print(data);
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
  }

  Widget Categories() {
    if (categoryData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    else {
        return SafeArea(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20),),
            Text('Categories', style: TextStyle(fontSize: 30)),
            Padding(padding: EdgeInsets.all(5),),
            Expanded(
              child: ListView.builder(
                itemCount: categoryData.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 14, left: 20, right: 20),
                    child: Card(
                      child: ListTile(
                        leading: Image.network(categoryData[index]['category_image'], height: 100, width: 100,),
                        title: Text('      ' + categoryData[index]['category_name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    )
                  );
                }
              ),
            ),
          ],
        ),
      );
    }
    
  }

  News() {
    if (data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    return SafeArea(
    child: Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8),),
        Text('News', style: TextStyle(fontSize: 33)),
        Padding(padding: EdgeInsets.all(5),),        
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: data[index]['news_image'] == null ? Image.asset('assets/no_image.jpeg') : Image.network(data[index]['news_image'], fit: BoxFit.cover,)            
                    ),
                    Container(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Padding(padding: EdgeInsets.all(100),),
                          Text(data[index]['news_title'], style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Date: ' + data[index]['news_date'], style: TextStyle(fontSize: 15, color: Colors.white,))
                        ],
                      ),
                    )
                  ],
                ),
                onTap: (){
                  if (data[index]['news_description'] != null) {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => Article(data[index]))
                    );
                  }
                },
              );
              
            }
  ),
        ),
      ],
    ),
    );
  }

  initState() {
    getJsonData();
    super.initState();
  }
  
  bodySelector() {
    switch (_currentIndex) {
      case 0:
        return Categories();
        break;
      case 1:
        return News();
        break;
      case 2:
        return Profile(changeBrightness);
        break;
      default:
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? Categories() : News(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Manage Category'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.line_style),
            title: Text('Manage News'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        showUnselectedLabels: true,        
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int i) {
          // categorySelector(i);
          setState(() {
            _currentIndex = i;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 0) {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => CategoryAdd())
            );
          } else {
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => NewsAdd(categoryData))
            );            
          }
        },
        child: _currentIndex == 0 ? Icon(Icons.playlist_add) : Icon(Icons.note_add),
      ),
    );
  }
}