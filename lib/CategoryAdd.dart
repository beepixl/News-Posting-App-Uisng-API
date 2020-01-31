import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CategoryAdd extends StatefulWidget {
  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  var category = TextEditingController();  
  File _image;
  var msg = '';
  
  Future galleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image; 
    });
  }


  sendData() async {
    final response = await http.post('http://news.raushanjha.in/flutterapi/insertcategory.php', body: {
      "name": category.text,
    });
    print(response.body);
    if (response.body == 'category added') {
      setState(() {msg = 'Category Added';});
    } else {
      setState(() {msg = 'Failed to add the category';});
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Padding(padding: EdgeInsets.all(2)),
              Image.network('http://news.raushanjha.in/assets/images/ic_launcher.png', height: 100, width: 100,),
              // Padding(padding: EdgeInsets.all(40),)
              // Text(
              //   'Admin login',
              //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              //   textAlign: TextAlign.left,
              // ),
              // Text(msg),
              Padding(padding: EdgeInsets.all(2)),
              // Text(
              //   'Sign in to continue',
              //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              // ),
              Padding(padding: EdgeInsets.all(20)),
              TextField(
                controller: category,
                decoration: InputDecoration(
                  hintText: 'Category name',
                  icon: Icon(Icons.category, color: Colors.blue,),
                  labelText: 'Category name',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1))
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
              MaterialButton(
                onPressed: () {sendData();},
                color: Colors.blue,
                child: Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20)
                ),
                padding: EdgeInsets.all(10),
              ),
              Text(msg)
            ],
          ),
        ),
      ),
    );
  }
}