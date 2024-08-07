import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  String? address; // 주소
  String? name; // 이름
  String? starImageUrl; // 별 이미지 URL
  List<String> imageUrls = []; // 이미지 URL 리스트
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('restaurant')
          .doc('2dyLMDEuhOKTPWITd21v')
          .get();
      setState(() {
        name = doc['name']; // Firestore에서 이름 가져오기
        address = doc['address']; // Firestore에서 주소 가져오기
        imageUrls = List<String>.from(doc['images']);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 150),
                  child: Text(
                    name ?? '이름을 가져오는 중...',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  address ?? '주소를 가져오는 중...',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),
                imageUrls.isNotEmpty
                    ? Image.network(
                        imageUrls[0], // 첫 번째 이미지를 표시
                        height: 20,
                        fit: BoxFit.contain,
                      )
                    : CircularProgressIndicator(), // 로딩 상태 표시
                // 로딩 상태 표시
              ],
            ),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(Icons.favorite,
                      color: _isFavorited ? Color(0xff4863E0) : Colors.grey),
                  iconSize: 27,
                ),
                Text(
                  '찜하기',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 45),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return (imageUrls.length > index)
                    ? Image.network(
                        imageUrls[index + 1],
                        width: 60,
                        fit: BoxFit.contain,
                      )
                    : Container(); // 이미지가 없는 경우 빈 컨테이너
              }),
            ),
            Scroll1(),
            const TabBar(
              tabs: [
                Tab(text: '리뷰'),
                Tab(text: '정보'),
                Tab(text: '메뉴'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: const [
                  ReviewPage(), // 리뷰 페이지
                  Center(child: Text('탭 2의 내용')),
                  Center(child: Text('탭 3의 내용')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//리뷰기능임

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();

  // 사용자가 선택한 별점
  int _rating1 = 0;
  int _rating2 = 0;
  int _rating3 = 0;
  int _rating4 = 0;

  // 별점을 제출하는 함수
  void _submitRating() {
    String reviewText = _textController.text.trim();
    // 별점이 0보다 큰 경우에만 제출
    if (_rating1 > 0 && _rating2 > 0 && _rating3 > 0 && _rating4 > 0) {
      // Firestore의 'ratings' 컬렉션에 별점 추가
      _firestore.collection('ratings').add({
        'rating': _rating1,
        'wheelchair_access': _rating2,
        'wheelchair_seating': _rating3,
        'kindness': _rating4,
        'review': reviewText, // 선택한 별점
        'timestamp': FieldValue.serverTimestamp(), // 서버 타임스탬프
      }).then((_) {
        // 성공적으로 저장된 경우
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리뷰가 저장되었습니다!')), // 사용자에게 알림
        );
        // 상태를 초기화하여 별점 선택 초기화
        setState(() {
          _rating1 = 0;
          _rating2 = 0;
          _rating3 = 0;
          _rating4 = 0;
          _textController.clear();
          // 별점 초기화
        });
      }).catchError((error) {
        // 오류 발생 시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $error')), // 오류 메시지 표시
        );
      });
    } else {
      // 별점을 선택하지 않은 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 항목의 별점을 선택하세요!')), // 별점 선택 요청
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '별점을 선택하세요:',
              style: TextStyle(fontSize: 20), // 텍스트 스타일
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating1
                        ? Icons.star
                        : Icons.star_border, // 선택된 별점에 따라 아이콘 변경
                    color: Color(0xff4863E0), // 별점 색상
                  ),
                  iconSize: 40,
                  onPressed: () {
                    // 별점을 선택할 때
                    setState(() {
                      _rating1 = index + 1; // 선택한 별점 저장
                    });
                  },
                );
              }),
            ), //전체 별점
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '휠체어 출입',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating2
                                ? Icons.star
                                : Icons.star_border, // 선택된 별점에 따라 아이콘 변경
                            color: Color(0xff4863E0), // 별점 색상
                          ),
                          iconSize: 30,
                          onPressed: () {
                            // 별점을 선택할 때
                            setState(() {
                              _rating2 = index + 1; // 선택한 별점 저장
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '휠체어 좌석',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating3
                                ? Icons.star
                                : Icons.star_border, // 선택된 별점에 따라 아이콘 변경
                            color: Color(0xff4863E0), // 별점 색상
                          ),
                          iconSize: 30,
                          onPressed: () {
                            // 별점을 선택할 때
                            setState(() {
                              _rating3 = index + 1; // 선택한 별점 저장
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '친절도',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating4
                                ? Icons.star
                                : Icons.star_border, // 선택된 별점에 따라 아이콘 변경
                            color: Color(0xff4863E0), // 별점 색상
                          ),
                          iconSize: 30,
                          onPressed: () {
                            // 별점을 선택할 때
                            setState(() {
                              _rating4 = index + 1; // 선택한 별점 저장
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ), //휠체어 출입 별점

            SizedBox(
              width: double.infinity,
              height: 150,
              child: TextField(
                controller: _textController, // 텍스트 필드 컨트롤러
                decoration: InputDecoration(
                  hintText: '이곳에 다녀온 경험을 자세히 공유해주세요\n\n\n', // 레이블 텍스트
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)), // 테두리 스타일
                ),
                maxLines: null,
              ),
            ),

            SizedBox(height: 50), // 텍스트 필드와 버튼 사이의 여백
            ElevatedButton(
              onPressed: () {
                _submitRating(); // 평점 제출 함수 호출
                Navigator.pop(context); // 현재 페이지를 닫음
              },
              child: Text('제출'), // 버튼 텍스트
            )
          ],
        ),
      ),
    );
  }
} //별점 기능임

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ratings')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('오류가 발생했습니다'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var reviewDoc = snapshot.data!.docs[index];
            var reviewData = reviewDoc.data() as Map<String, dynamic>?;

            if (reviewData == null) {
              return ListTile(title: Text('리뷰 데이터를 불러올 수 없습니다.'));
            }

            return ListTile(
              leading: SizedBox(),
              title: Row(
                children: [
                  Text('전체 평가: '),
                  Row(
                    children: List.generate(5, (starIndex) {
                      int rating = reviewData['rating'] as int? ?? 0;
                      return Icon(
                        starIndex < rating ? Icons.star : Icons.star_border,
                        color: Color(0xff4863E0),
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('휠체어 출입: ${reviewData['wheelchair_access'] ?? 'N/A'}'),
                  Text('휠체어 좌석: ${reviewData['wheelchair_seating'] ?? 'N/A'}'),
                  Text('친절도: ${reviewData['kindness'] ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text(reviewData['review'] as String? ?? '리뷰 내용 없음'),
                ],
              ),
            );
          },
        );
      },
    );
  }
} // 탭바에 있는 리뷰기능임

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/gungun.png'),
            ),
            SizedBox(
              width: 40,
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Rating()));
                  },
                  child: Image.asset('assets/rating1.png')),
            ),
          ],
        ),
        Expanded(
          child: ReviewList(),
        )
      ],
    );
  }
}

class Scroll1 extends StatefulWidget {
  // banner부분
  const Scroll1({super.key});

  @override
  State<Scroll1> createState() => _Scroll1State();
}

class _Scroll1State extends State<Scroll1> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImages(); // 이미지 URL 가져오기
  }

  Future<void> fetchImages() async {
    try {
      String folderPath = 'info_banner/'; // Firebase Storage의 폴더 경로
      final ListResult result =
          await FirebaseStorage.instance.ref(folderPath).listAll();

      List<String> urls = [];
      for (var ref in result.items) {
        String url = await ref.getDownloadURL(); // 각 이미지의 URL 가져오기
        urls.add(url);
      }

      setState(() {
        imageUrls = urls; // 가져온 URL 리스트로 상태 업데이트
      });
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        imageUrls = []; // 에러 발생 시 빈 리스트로 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          SizedBox(width: 50),
          SizedBox(
            height: 200,
            width: 340,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  imageUrls.isNotEmpty ? imageUrls.length : 1, // 이미지가 없으면 1로 설정
              itemBuilder: (context, index) {
                // 이미지가 없을 경우 로딩 인디케이터 표시
                if (imageUrls.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                return SizedBox(
                  width: 200,
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(
                      imageUrls[index], // 동적으로 URL 사용
                      fit: BoxFit.cover, // 이미지 맞춤
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
