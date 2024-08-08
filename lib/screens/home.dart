import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/frame.dart';
import 'package:flutter_application_1/components/navigation_bar.dart';
import 'package:flutter_application_1/screens/menu.dart';
import 'package:flutter_application_1/screens/map.dart';
import 'package:flutter_application_1/screens/banner1.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Menu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 35,
              ),
            ),
          ],
          flexibleSpace: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: Image.asset('assets/firstlogo.png'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Banner1(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Frame()));
                        },
                        child: SizedBox(
                            height: 60,
                            width: 50,
                            child: Image.asset('assets/bob.png'))),
                    TextButton(
                        onPressed: () {},
                        child: SizedBox(
                            height: 60,
                            width: 50,
                            child: Image.asset('assets/display.png'))),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Map()));
                        },
                        child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.asset('assets/cafe1.png'))),
                    TextButton(
                        onPressed: () {},
                        child: SizedBox(
                            height: 70,
                            width: 60,
                            child: Image.asset('assets/play.png'))),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Map()));
                        },
                        child: SizedBox(
                            height: 70,
                            width: 40,
                            child: Image.asset('assets/park.png'))),
                    TextButton(
                        onPressed: () {},
                        child: SizedBox(
                            height: 60,
                            width: 50,
                            child: Image.asset('assets/all.png'))),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
