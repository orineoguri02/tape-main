import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/info.dart';
import 'package:flutter_application_1/screens/resturant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  String? name;
  String? subname;
  List<String> imageUrls = []; // 이미지 URL 리스트

  @override
  void initState() {
    super.initState();
    fetchMarkers();
    fetchData();
    _selectedCity = _list[0];
  }

  Future<void> fetchMarkers() async {
    try {
      // 'restaurants' 컬렉션에서 데이터 가져오기
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('location').get();

      // 각 문서에 대해 반복하여 마커 추가
      for (var doc in querySnapshot.docs) {
        String id = doc['id'];
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];

        // 마커 추가
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(id),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: name,
                onTap: () {
                  // 마커 클릭 시 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Info()), // Info 페이지로 이동
                  );
                },
              ),
            ),
          );
        });
      }
    } catch (e) {
      print('Error fetching markers: $e'); // 오류 처리
    }
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('restaurant')
          .doc('2dyLMDEuhOKTPWITd21v')
          .get();
      setState(() {
        name = doc['name'];
        subname = doc['subname'];
        imageUrls = List<String>.from(doc['banner']);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final LatLng _center = const LatLng(37.5758772, 126.9768121);
  final _list = ['서울', '대구', '포항', '대전'];
  String _selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 100,
            child: DropdownButton(
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
                child: SingleChildScrollView(
                    controller: scrollController, child: Resturant()),
              );
            },
          ),
        ],
      ),
    );
  }
}
