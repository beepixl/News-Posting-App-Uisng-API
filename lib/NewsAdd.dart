import 'package:flutter/material.dart';
import 'package:flutter_calendar/calendar_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';


class NewsAdd extends StatefulWidget {
  var categories;
  NewsAdd(this.categories);
  @override
  _NewsAddState createState() => _NewsAddState(categories);
}

class _NewsAddState extends State<NewsAdd> {  
  var categories;
  _NewsAddState(this.categories);
  var title = TextEditingController();
  var description =TextEditingController();
  var richDescription;
  FocusNode _focusNode;
  var date = DateTime.now();
  var catId;
  var msg = '';
  
  getId() {
    for (var item in categories) {
      if (catSelected == item['category_name']) {
        setState(() {
        catId = item['cid'];          
      });
        return;
      }
    }
  }

  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }


  sendData() async {
    getId();
    final response = await http.post('http://news.raushanjha.in/flutterapi/insertnews.php', body: {
      "news_title": title.text,
      "news_description": description.text,  
      "news_date": date.toString(),
      "cat_id": catId
    });
    print(response.body);
    if (response.body == 'news added') {
      setState(() {msg = 'News Added';});
    } else {
      setState(() {msg = 'Failed to add the news';});
    }
  }

  List catArr = ['Select Category'];
  var catSelected = 'Select Category';
  File _image;

  initState() {
    // catSelected = catArr[0];
    for (var i = 0; i < categories.length; i++) {
      setState(() {
        catArr.add(categories[i]['category_name']) ;        
      });
    }
    final document = _loadDocument();
    richDescription = ZefyrController(document);
    _focusNode = FocusNode();
    super.initState();
  }
  
  Future galleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image; 
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add News'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(2)),
              Image.network('http://news.raushanjha.in/assets/images/ic_launcher.png', height: 100, width: 100,),
              Padding(padding: EdgeInsets.all(20)),
              TextField(
                controller: title,
                decoration: InputDecoration(                  
                  hintText: 'News title',
                  icon: Icon(Icons.text_fields, color: Colors.blue,),
                  labelText: 'Title',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1))
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Card(
                child: Calendar(
                  initialCalendarDateOverride: date, 
                  onDateSelected: (newDate) {
                    setState(() {
                      date = newDate;
                    });
                    print(date);
                  },
                )
              ),
              Padding(padding: EdgeInsets.all(10)),
              Card(
                child: DropdownButton<String>(
                  // focusColor: Colors.white,
                  value: catSelected,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  onChanged: (String newValue) {
                    setState(() {
                      catSelected = newValue;
                    });
                  },
                  items: catArr
                    .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black, fontSize: 20),),
                      );
                    })
                    .toList(),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              GestureDetector(
                child: Container(
                  color: Colors.grey[200],
                  height: 300,
                  width: double.infinity,
                  child: _image != null ? Image.file(_image, fit: BoxFit.cover,) : Icon(Icons.add_a_photo),
                ),
                onTap: galleryImage,
              ), 
              Padding(padding: EdgeInsets.all(10)),
              // ZefyrEditor(
              //   controller: richDescription,
              //   focusNode: _focusNode,
              //   padding: EdgeInsets.all(10),
              // ),
              TextField(
                controller: description,
                decoration: InputDecoration(
                  hintText: 'Description',
                  icon: Icon(Icons.filter_list, color: Colors.blue,),
                  labelText: 'Description',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1))
                ),
                minLines: 5,
                maxLines: 50,
              ),
              Padding(padding: EdgeInsets.all(10)),
              MaterialButton(
                onPressed: () {
                  sendData();
                  print(catId);
                },
                color: Colors.blue,
                child: Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20)
                ),
                padding: EdgeInsets.all(10),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Text(msg)
            ],
          ),
        ),
      ),
    );
  }
}