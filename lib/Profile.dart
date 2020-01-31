import 'dart:io';

import 'package:flutter/material.dart';

Widget Profile(dark) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          radius: 100,
          // child: Image.asset('assets/flutter.png'),
          // backgroundColor: Colors.red,
          backgroundImage: NetworkImage('https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
        ),
        accountName: Text('Samansh'),
        accountEmail: Text('abc@xyz.com'),
      ),
      ListTile(
        leading: Icon(Icons.cancel),
        title: Text('Quit', style: TextStyle(fontSize: 17),),
        onTap: () => exit(0),
      ),
      ListTile(
        leading: Icon(Icons.brightness_medium),
        title: Text('Theme', style: TextStyle(fontSize: 17),),
        onTap: () {
          dark();
        },
      )
    ],
  );
}