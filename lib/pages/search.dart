import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:polymap/models/building.dart';
import 'package:flutter/cupertino.dart';
import 'package:polymap/colors.dart';
import 'package:polymap/models/cabinet.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return child;
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  bool isDark = false;
  String searchString = '';
  Stream stream = FirebaseDatabase.instance.reference().once().asStream();

  @override
  void initState() {
    MyColors.getTheme().then((isDark) {
      this.isDark = isDark;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (this.isDark) ? MyColors.darkBackground : Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            color: (this.isDark) ? MyColors.darkAppBar : MyColors.greenPolyTech,
            height: MediaQuery.of(context).padding.top + 71,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  10, MediaQuery.of(context).padding.top + 10, 10, 10),
              child: Card(
                elevation: 7,
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                    text: this.searchString,
                    selection: TextSelection.collapsed(
                        offset: this.searchString.length),
                  )),
                  onChanged: (searchString) {
                    setState(() {
                      this.searchString = searchString;
                    });
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Поиск...',
                    prefixIcon: IconButton(
                      onPressed: Navigator.of(context).pop,
                      icon: Icon(
                        IconData(58848,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: true),
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            elevation: 4,
            color: (this.isDark) ? MyColors.darkBackground : Colors.white,
            child: SizedBox(
              height: 71,
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  this._categoryWidget(0),
                  this._categoryWidget(1),
                  this._categoryWidget(2),
                  this._categoryWidget(3),
                  this._categoryWidget(4),
                  this._categoryWidget(5),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DataSnapshot>(
              stream: this.stream,
              builder: (context, dataSnapshot) {
                if (dataSnapshot.hasError)
                  return new Text('${dataSnapshot.error}');
                switch (dataSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.greenPolyTech),
                      ),
                    );
                  default:
                    List<Building> buildings = List<Building>();
                    List<Cabinet> cabinets = List<Cabinet>();
                    dataSnapshot.data.value['Building']
                        .toList()
                        .forEach((building) {
                      if (building['ID'] != null) {
                        buildings.add(Building(
                            building['Description'],
                            building['ID'],
                            building['Lat'],
                            building['Lng'],
                            building['Name_build'],
                            building['Number_of_org'],
                            building['Working_hours']));
                      }
                    });
                    dataSnapshot.data.value['Cabinet']
                        .toList()
                        .forEach((cabinet) {
                      if (cabinet['Name'] == 'Лаборатория') {
                        cabinets.add(Cabinet(
                            cabinet['Attachment'].toString(),
                            cabinet['Cabinet'].toString(),
                            cabinet['Fixation'].toString(),
                            cabinet['Floor'].toString(),
                            cabinet['ID_building'],
                            cabinet['Name'].toString()));
                      }
                    });
                    return ListView.separated(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      separatorBuilder: (context, index) => Divider(
                            height: 0,
                            color: MyColors.gray216,
                          ),
                      physics: BouncingScrollPhysics(),
                      itemCount: (this.getBuildingsByName(buildings).length +
                          this.getCabinetsByName(cabinets).length),
                      itemBuilder: (BuildContext context, int index) {
                        return RawMaterialButton(
                          splashColor: Colors.black12,
                          highlightColor: Colors.white10,
                          onPressed: () {
                            int buildingCounts =
                                this.getBuildingsByName(buildings).length - 1;
                            if (index <= buildingCounts) {
                              Navigator.of(context).pop(
                                  this.getBuildingsByName(buildings)[index]);
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 50,
                                  color: MyColors.greenPolyTech,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  (index <=
                                          this
                                                  .getBuildingsByName(buildings)
                                                  .length - 1)
                                      ? this
                                          .getBuildingsByName(buildings)[index]
                                          .name
                                      : (getCabinetsByName(cabinets)[index -
                                      (this
                                                      .getBuildingsByName(
                                                          buildings)
                                                      .length )].name +
                                          ', ' +
                                          getCabinetsByName(cabinets)[index -
                                              (this
                                                      .getBuildingsByName(
                                                          buildings)
                                                      .length )]
                                              .cabinet +
                                          ' кб.'),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: (this.isDark)
                                          ? MyColors.gray237
                                          : MyColors.gray77,
                                      letterSpacing: 0),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryWidget(int index) {
    IconData iconData;
    String text;
    Color color;

    switch (index) {
      case 0:
        iconData = IconData(0xe9a3, fontFamily: 'categoriesIconsFamily');
        text = 'Поесть';
        color = MyColors.yellowEat;
        break;
      case 1:
        iconData = IconData(0xe954, fontFamily: 'categoriesIconsFamily');
        text = 'Печать';
        color = MyColors.lightBluePrint;
        break;
      case 2:
        iconData = IconData(0xe921, fontFamily: 'categoriesIconsFamily');
        text = 'Деканат';
        color = MyColors.redDirectory;
        break;
      case 3:
        iconData = IconData(0xe91f, fontFamily: 'categoriesIconsFamily');
        text = 'Библиотеки';
        color = MyColors.purpleLibrary;
        break;
      case 4:
        iconData = IconData(0xe9aa, fontFamily: 'categoriesIconsFamily');
        text = 'Лаборатории';
        color = MyColors.blueLaboratory;
        break;
      default:
        iconData = IconData(0xe946, fontFamily: 'categoriesIconsFamily');
        text = 'Канцелярия';
        color = MyColors.greenOffice;
        break;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 13, 18, 0),
      child: Column(
        children: <Widget>[
          Icon(
            iconData,
            size: 36,
            color: color,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
            ),
          ),
        ],
      ),
    );
  }

  List<Building> getBuildingsByName(List<Building> buildings) {
    List<Building> returnBuildings = List<Building>();
    buildings.forEach((item) {
      if (item.name.toLowerCase().contains(this.searchString.toLowerCase()))
        returnBuildings.add(item);
    });
    return returnBuildings;
  }

  List<Cabinet> getCabinetsByName(List<Cabinet> cabinets) {
    List<Cabinet> returnCabinets = List<Cabinet>();
    cabinets.forEach((item) {
      if ((item.name.toLowerCase() + item.cabinet.toLowerCase())
          .contains(this.searchString.toLowerCase())) returnCabinets.add(item);
    });
    return returnCabinets;
  }
}
