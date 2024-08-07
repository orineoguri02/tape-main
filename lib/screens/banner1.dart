import 'package:flutter/material.dart';

class Banner1 extends StatefulWidget {
  const Banner1({super.key});

  @override
  State<Banner1> createState() => _Banner1State();
}

class _Banner1State extends State<Banner1> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        width: 350,
        // 카드 스크롤의 높이를 설정
        child: ListView(scrollDirection: Axis.horizontal, children: [
          SizedBox(
            width: 350,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset('assets/ban1.png')),
            ),
          ),
          SizedBox(
            width: 350,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset('assets/ban2.png')),
            ),
          ),
          SizedBox(
            width: 350,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset('assets/ban3.png')),
            ),
          ),
          SizedBox(
            width: 350,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset('assets/ban4.png')),
            ),
          ),
        ]));
  }
}
