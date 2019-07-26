import 'package:flutter/material.dart';
import 'package:polymap/pages/map.dart';
import 'package:polymap/pages/handbook.dart';
import 'package:polymap/pages/cabinet.dart';
import 'package:polymap/colors.dart';

class RootPage extends StatefulWidget {
  final int startPage;
  RootPage(this.startPage);

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  PageController _pageController;
  final PageStorageBucket bucket = PageStorageBucket();
  int _pageIndex;
  bool isDark = false;

  final List<Widget> _pages = [
    MapPage(),
    HandbookPage(),
    CabinetPage(),
  ];

  @override
  void initState() {
    this._pageIndex = widget.startPage;
    MyColors.getTheme().then((isDark) {
      setState(() {
        this.isDark = isDark;
      });
    });

    super.initState();
    this._pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.bottomCenter,
      children: <Widget>[
        IndexedStack(
          children: _pages,
          index: this._pageIndex,
        ),
        Container(
          height: 55,
          child: Scaffold(
            bottomNavigationBar: Container(
              height: 55,
              child: Theme(
                data: Theme.of(context).copyWith(
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: (this.isDark)
                        ? MyColors.darkAppBar
                        : MyColors.lightAppBar,
                    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                    primaryColor: MyColors.greenPolyTech,
                    textTheme: Theme.of(context).textTheme.copyWith(
                        caption: new TextStyle(color: MyColors.gray165))),
                // sets the inactive color of the `BottomNavigationBar`
                child: BottomNavigationBar(
                  onTap: onTabTapped,
                  currentIndex: _pageIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        IconData(0xe902, fontFamily: 'bottomBarIconsFamily'),
                        size: 22,
                        color: (this._pageIndex == 0)
                            ? MyColors.greenPolyTech
                            : MyColors.gray165,
                      ),
                      title: Text('Карта'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        IconData(0xe900, fontFamily: 'bottomBarIconsFamily'),
                        size: 22,
                        color: (this._pageIndex == 1)
                            ? MyColors.greenPolyTech
                            : MyColors.gray165,
                      ),
                      title: Text('Справочник'),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(
                          IconData(0xe901, fontFamily: 'bottomBarIconsFamily'),
                          size: 22,
                          color: (this._pageIndex == 2)
                              ? MyColors.greenPolyTech
                              : MyColors.gray165,
                        ),
                        title: Text('Кабинет'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
