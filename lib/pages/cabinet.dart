import 'package:flutter/material.dart';
import 'package:polymap/colors.dart';
import 'package:polymap/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Private Cabinet page (3rd on bottom bar)
class CabinetPage extends StatefulWidget {
  CabinetPage();

  @override
  CabinetPageState createState() => CabinetPageState();
}

// State of Private Cabinet page
class CabinetPageState extends State<CabinetPage> {
  bool isDark = false; // isDark theme flag
  String groupNumber = ''; // user's group number

  @override
  void initState() {

    // get and set isDark theme flag
    MyColors.getTheme().then((isDark) {
      setState(() {
        this.isDark = isDark;
      });
    });

    // get and set user's group number
    this.initGroup();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Личный кабинет',
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 0,
            color: (this.isDark) ? MyColors.gray237 : Colors.white,
          ),
        ),
        backgroundColor:
            (this.isDark) ? MyColors.darkAppBar : MyColors.greenPolyTech,
      ),
      backgroundColor: (this.isDark) ? MyColors.darkBackground : Colors.white,
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                indent: 16,
                height: 0,
                color: MyColors.gray216,
              ),
          physics: BouncingScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return getListItem(index);
          },
        ),
      ),
    );
  }

  // Element of the listView
  Widget getListItem(int index) {
    switch (index) {
      case 0:
        return RawMaterialButton(
          padding: EdgeInsets.only(left: 16, right: 16),
          splashColor: Colors.black12,
          highlightColor: Colors.white10,
          onPressed: () => Navigator.pushNamed(context, '/schedulePage'), // go to Schedule page
          child: Row(
            children: <Widget>[
              Text(
                'Расписание',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0,
                  color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                ),
              )
            ],
          ),
        );
      case 1:
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Темная тема',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0,
                  color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                ),
              ),
              Switch(
                activeColor: MyColors.greenPolyTech,
                value: this.isDark,
                onChanged: (isDark) {
                  this.isDark = isDark;
                  MyColors.setTheme(isDark).then((_) {
                    RestartWidget.restartApp(context);
                  });
                },
              )
            ],
          ),
        );
      default:
        return RawMaterialButton(
          padding: EdgeInsets.only(left: 16, right: 16),
          splashColor: Colors.black12,
          highlightColor: Colors.white10,
          onPressed: () => Navigator.pushNamed(context, '/groupPage') // go to change group number page
              .whenComplete(() => this.initGroup()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Номер группы:',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0,
                  color: (this.isDark) ? MyColors.gray237 : MyColors.gray77,
                ),
              ),
              Text(
                this.groupNumber,
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0,
                  color: (this.isDark) ? MyColors.greenPolyTech : MyColors.greenPolyTech,
                ),
              )
            ],
          ),
        );
    }
  }

  // get and set group number method
  void initGroup() {
    getGroup().then((groupNumber) {
      setState(() {
        if (groupNumber != '') this.groupNumber = groupNumber;
        else this.groupNumber = 'Выберите группу...';
      });
    });
  }

  // get group number method
  static Future<String> getGroup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('group') ?? 'Выберите группу...';
  }
}
