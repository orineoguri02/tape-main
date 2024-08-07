import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/info.dart';

class Resturant extends StatefulWidget {
  const Resturant({super.key});

  @override
  State<Resturant> createState() => _ResturantState();
}

class _ResturantState extends State<Resturant> {
  List<Map<String, dynamic>> restaurantData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('restaurant').get();

      // 모든 문서를 리스트에 추가
      List<Map<String, dynamic>> fetchedData = [];
      for (var doc in querySnapshot.docs) {
        fetchedData.add(doc.data() as Map<String, dynamic>);
      }

      setState(() {
        restaurantData = fetchedData; // restaurantData 업데이트
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: restaurantData.length, // 리스트 타일 개수
          itemBuilder: (context, index) {
            final restaurant = restaurantData[index];
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ListTile(
                title: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Info(), // 각 레스토랑에 맞는 페이지로 이동
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      if (restaurant['banner'] != null &&
                          restaurant['banner'].isNotEmpty)
                        Image.network(
                          restaurant['banner'][0], // 첫 번째 배너 이미지 사용
                          fit: BoxFit.cover,
                          width: 150, // 이미지 크기 조정
                          height: 130,
                        ),
                      SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'] ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            Text(
                              restaurant['subname'] ?? '',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            SizedBox(
                              width: 130,
                              height: 30,
                              child: restaurant['intro_image'] != null
                                  ? Image.network(
                                      restaurant['intro_image'],
                                    )
                                  : Container(), // intro_image가 없을 경우 빈 컨테이너
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
