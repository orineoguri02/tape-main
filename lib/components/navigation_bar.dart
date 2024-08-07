import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/course/folder.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomNavigationBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: widget.selectedIndex == 0
                      ? Colors.grey.shade300
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.selectedIndex == 0 ? Colors.black : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  child: Icon(
                    Icons.home,
                    size: 40,
                  ),
                ),
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: widget.selectedIndex == 1
                      ? Colors.grey.shade300
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.selectedIndex == 1 ? Colors.black : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  child: Icon(
                    Icons.menu,
                    size: 40,
                  ),
                ),
              ),
              label: '메뉴',
            ),
          ],
          currentIndex: widget.selectedIndex,
          selectedItemColor: Colors.black,
          onTap: widget.onItemTapped,
        ),
        Positioned(
          bottom: 50,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomImageDisplay()),
              );
            },
            backgroundColor: Color(0xff4863E0),
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
