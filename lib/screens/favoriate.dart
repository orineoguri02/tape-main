import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('찜'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Option(
            imageUrl: 'assets/fav1.png',
            name: '오뜨로 성수',
            category: '식당',
          ),
          Option(
            imageUrl: 'assets/fav2.png',
            name: '차이나플레인',
            category: '식당',
          ),
        ],
      ),
    );
  }
}

class Option extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String category;

  const Option(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.category});

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(widget.imageUrl, width: 150, height: 150),
            Positioned(
              bottom: 3,
              right: 3,
              child: IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(Icons.favorite,
                    color: _isFavorited ? Color(0xff4863E0) : Colors.grey),
                iconSize: 27,
              ),
            ),
          ],
        ),
        Text(widget.name, style: TextStyle(fontSize: 20, color: Colors.black)),
        Text(widget.category,
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
