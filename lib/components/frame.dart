import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Frame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('restaurant').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          // MapPage를 직접 반환하는 대신, 데이터를 MapPage에 전달합니다.
          return MapPage(restaurants: snapshot.data!.docs);
        },
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String name;
  final String address;
  final String subname;
  final Map<String, dynamic> data;

  DetailPage({
    required this.name,
    required this.subname,
    required this.data,
    required this.address,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  bool _isFavorited = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.data['images'] is List
        ? List<String>.from(widget.data['images'])
        : [];
    List<String> banners = widget.data['banner'] is List
        ? List<String>.from(widget.data['banner'])
        : [];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 100),
                child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.address,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 4),
              if (images.isNotEmpty)
                Image.network(
                  images[0],
                  height: 20,
                  fit: BoxFit.contain,
                )
              else
                Text('아직 만드는 중...'),
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return (images.length > index + 1)
                    ? Image.network(
                        images[index + 1],
                        width: 60,
                        fit: BoxFit.contain,
                      )
                    : Container();
              }),
            ),
            SizedBox(height: 16),
            if (banners.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    String imageUrl = banners[index];
                    if (imageUrl.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.network(
                          imageUrl,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Center(child: Text('이미지가 없습니다.'));
                    }
                  },
                ),
              )
            else
              Text(
                '아직 만드는 중',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: '리뷰'),
                Tab(text: '정보'),
                Tab(text: '메뉴'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ReviewPage(),
                  Center(child: Text('정보 내용')),
                  Center(child: Text('메뉴 내용')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  final List<DocumentSnapshot> restaurants;

  MapPage({required this.restaurants});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _center = const LatLng(37.5758772, 126.9768121);
  final _list = ['서울', '대구', '포항', '대전'];
  String _selectedCity = '서울';
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers.clear();
    for (var restaurant in widget.restaurants) {
      Map<String, dynamic> data = restaurant.data() as Map<String, dynamic>;
      if (data['location'] != null) {
        _markers.add(Marker(
          markerId: MarkerId(restaurant.id),
          position:
              LatLng(data['location'].latitude, data['location'].longitude),
          infoWindow: InfoWindow(title: data['name']),
        ));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              items: _list
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value!;
                  // 여기에 도시 변경에 따른 지도 업데이트 로직을 추가할 수 있습니다.
                });
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.white,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.restaurants.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = widget.restaurants[index].data()
                        as Map<String, dynamic>;
                    List<String> banner = data['banner'] is List
                        ? List<String>.from(data['banner'])
                        : [];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16), // 원하는 패딩 설정
                        elevation: 2, // 그림자 효과
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              name: data['name'] ?? 'No Name',
                              data: data,
                              address: data['address'] ?? 'No Address',
                              subname: data['subname'],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.network(
                            banner[0],
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 16), // 이미지와 텍스트 사이의 간격
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'] ?? 'No Name',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  data['subname'] ?? 'No subname',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
