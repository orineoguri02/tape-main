import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/favoriate.dart';
import 'package:flutter_application_1/screens/home.dart'; // Make sure this path is correct

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/거누.png'),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('거누'),
                Text('gunnu@handong.ac.kr'),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('계정'),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('찜한 장소'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Favorite()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shield),
            title: Text('개인정보 보호'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('알림'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('문의하기'),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('버전'),
            trailing: Text('5.7.1'),
          ),
          ListTile(
            title: Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
