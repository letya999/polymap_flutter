import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:polymap/models/building.dart';
import 'package:polymap/colors.dart';
import 'package:rubber/rubber.dart';
import 'package:polymap/models/cabinet.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  List<Cabinet> childrenOfItem = List<Cabinet>();
  Completer<GoogleMapController> _controller = Completer();

  // current position on the map
  CameraPosition currentPosition = CameraPosition(
    target: LatLng(60.006751, 30.372479),
    zoom: 16,
  );
  Building item = Building('', 0, 0, 0, '', 0, '');
  Set<Marker> markers = new Set<Marker>(); // set of markers on map
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); // key for saving state of map
  bool isDark = false; // same as in cabinet.dart

  RubberAnimationController _rubberAnimationController; // controller for animation of building card

  @override
  void initState() {
    // init building card animation
    this._rubberAnimationController = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(pixel: 300),
        lowerBoundValue: AnimationControllerValue(pixel: 60),
        upperBoundValue: AnimationControllerValue(percentage: 1),
        duration: Duration(milliseconds: 200));
    this._rubberAnimationController.addStatusListener(_statusListener);
    this._rubberAnimationController.animationState.addListener(_stateListener);

    // get theme
    MyColors.getTheme().then((isDark) {
      setState(() {
        this.isDark = isDark;
      });
    });

    super.initState();
    setState(() {}); // this one runs "@override Widget build" method
  }

  // for animation of card
  @override
  void dispose() {
    this._rubberAnimationController.removeStatusListener(_statusListener);
    this
        ._rubberAnimationController
        .animationState
        .removeListener(_stateListener);
    super.dispose();
  }

  // for animation of card
  void _stateListener() {
    print(
        "state changed ${this._rubberAnimationController.animationState.value}");
    if (this._rubberAnimationController.animationState.value ==
        AnimationState.collapsed) {
      this.closeItem();
    }
  }

  // listener of building card position
  void _statusListener(AnimationStatus status) {
    print("changed status ${this._rubberAnimationController.status}");
  }

  void setMarker() {
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId('0'),
      position: LatLng(this.item.lat, this.item.lng),
    ));
  }

  void goToMarker() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(this.item.lat, this.item.lng), 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: RubberBottomSheet(
        lowerLayer: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              tiltGesturesEnabled: false,
              initialCameraPosition: this.currentPosition,
              onMapCreated: (GoogleMapController controller) {
                this._controller.complete(controller);
              },
              onCameraMove: (cameraPosition) {
                this.currentPosition = cameraPosition;
              },
              minMaxZoomPreference: MinMaxZoomPreference(14, 20),
              markers: this.markers,
              onTap: (_) => this.closeItem(),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/searchPage')
                        .then((item) => this.whenReturnItem(item));
                  },
                  fillColor: Colors.white,
                  elevation: 4,
                  highlightElevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixText: '   ',
                      hintText: 'Поиск...',
                      hintStyle: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0,
                        color: MyColors.gray165,
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        upperLayer: SafeArea(
          child: _getUpperLayer(),
        ),
        animationController: this._rubberAnimationController,
      ),
    );
  }

  Widget _getUpperLayer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Material(
        elevation: 10,
        color: (this.isDark) ? MyColors.darkBackground : MyColors.gray240,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
          child: Column(
            children: <Widget>[
              Container(
                height: 5,
                width: 30,
                child: RaisedButton(
                  disabledColor: MyColors.greenPolyTech,
                  onPressed: null,
                  color: MyColors.greenPolyTech,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      this.item.name,
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 0,
                        color:
                            (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Учебное здание',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0,
                      color: (this.isDark)
                          ? MyColors.gray237Opacity07
                          : MyColors.gray77Opacity07,
                    ),
                  ),
                ],
              ),
              RawMaterialButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15),
                    Icon(
                      IconData(58738, fontFamily: 'MaterialIcons'),
                      color: MyColors.greenPolyTech,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Построить маршрут',
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0,
                        color: MyColors.greenPolyTech,
                      ),
                    ),
                  ],
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15),
                    Icon(
                      IconData(59536,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true),
                      color: MyColors.greenPolyTech,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Показать вход',
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0,
                        color: MyColors.greenPolyTech,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Режим работы:',
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: 0,
                      color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    this.item.workTime,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0,
                      color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                    ),
                  )
                ],
              ),
              SizedBox(height: 13),
              Row(
                children: <Widget>[
                  Text(
                    'Места:',
                    style: TextStyle(
                      fontSize: 19,
                      letterSpacing: 0,
                      color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                    ),
                  )
                ],
              ),
              SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        indent: 0,
                        height: 0,
                        color: MyColors.gray216,
                      ),
                  physics: BouncingScrollPhysics(),
                  itemCount: this.childrenOfItem.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
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
                            this.childrenOfItem[index].name +
                                ', ' +
                                childrenOfItem[index].cabinet +
                                ' кб.',
                            style: TextStyle(
                                fontSize: 17,
                                color: (this.isDark)
                                    ? MyColors.gray237
                                    : MyColors.gray77,
                                letterSpacing: 0),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 55),
            ],
          ),
        ),
      ),
    );
  }

  void whenReturnItem(dynamic item) {
    if (item.runtimeType == Building) {
      this.childrenOfItem.clear();
      this.item = item;
      this._rubberAnimationController.halfExpand(from: 0);
      this.setMarker();
      this.goToMarker();
      FirebaseDatabase.instance
          .reference()
          .child('Cabinet')
          .once()
          .then((children) {
        children.value.toList().forEach((child) {
          if (child['ID_building'] == this.item.id) {
            this.childrenOfItem.add(Cabinet(
                child['Attachment'].toString(),
                child['Cabinet'].toString(),
                child['Fixation'].toString(),
                child['Floor'].toString(),
                child['ID_building'],
                child['Name'].toString()));
          }
        });
        setState(() {});
      });
    }
  }

  void closeItem() {
    setState(() {
      this._rubberAnimationController.animateTo(to: 0);
      this.markers.clear();
      this.item = Building('', 0, 0, 0, '', 0, '');
      this.childrenOfItem.clear();
    });
  }
}
