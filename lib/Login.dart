import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_posting_app/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String msg = '';
  var data;
  var user = TextEditingController();
  var pass = TextEditingController();
  var res = '';

  verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post('http://news.raushanjha.in/flutterapi/login.php', body: {
      "username": user.text,
      "password": pass.text,
    });
    data = json.decode(response.body);
    print(data);

    print(data.runtimeType);
    setState(() {
      res = response.body;
    });
    if (data == false) {
      setState(() {
        msg = 'Incorrect username or password';
      });            
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
    else {
      prefs.setBool('loggedin', true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));         
    }
  }
  Future checkLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('loggedin') ?? false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));  
    }

  }
  @override
  void initState() {
    checkLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Padding(padding: EdgeInsets.all(40),)
            // Text(
            //   'Admin login',
            //   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.left,
            // ),
            // Text(msg),
            Padding(padding: EdgeInsets.all(2)),
            Text(
              'Sign in to continue',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(20)),
            TextField(
              controller: user,
              decoration: InputDecoration(
                hintText: 'Username',
                icon: Icon(Icons.person, color: Colors.blue,),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: pass,
              decoration: InputDecoration(
                hintText: 'Password',
                icon: Icon(Icons.lock, color: Colors.blue, ),
              ),
              obscureText: true,
            ),
            Padding(padding: EdgeInsets.all(10)),
            MaterialButton(
              onPressed: () {
                verify();
                
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));                  
                
              },
              color: Colors.blue,
              child: Text(
                'Log in',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20)
              ),
              padding: EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}