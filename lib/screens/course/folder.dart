import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/navigation_bar.dart';
import 'dart:math';

class Folder extends StatefulWidget {
  const Folder({super.key});

  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내가 만든 코스'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: InkWell(
                    onTap: () {
                      // Add functionality to display random data
                    },
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Center(child: Text('Random Data')),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      // Add functionality to display random data
                    },
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Center(child: Text('Random Data')),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              child: InkWell(
                onTap: () {
                  // Add functionality to add an image
                },
                child: Container(
                  width: 200,
                  height: 300,
                  alignment: Alignment.center,
                  child: Icon(Icons.add, size: 50),
                ),
              ),
            ),
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

class RandomImageDisplay extends StatefulWidget {
  const RandomImageDisplay({super.key});

  @override
  _RandomImageDisplayState createState() => _RandomImageDisplayState();
}

class _RandomImageDisplayState extends State<RandomImageDisplay> {
  final List<String> images = [
    'assets/random/1.jpg',
    'assets/random/2.jpg',
    'assets/random/3.jpg',
    'assets/random/4.jpg',
    'assets/random/5.jpg',
    'assets/random/6.jpg',
    'assets/random/7.jpg',
    'assets/random/8.jpg',
    'assets/random/9.jpg',
    'assets/random/10.jpg',
  ];

  String _randomImage = '';

  @override
  void initState() {
    super.initState();
    _randomImage = _getRandomImage();
  }

  String _getRandomImage() {
    final random = Random();
    return images[random.nextInt(images.length)];
  }

  void _shuffleImage() {
    setState(() {
      _randomImage = _getRandomImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(_randomImage),
        ElevatedButton(
          onPressed: _shuffleImage,
          child: Text('Shuffle Image'),
        ),
      ],
    );
  }
}
