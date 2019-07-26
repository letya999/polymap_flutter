import 'package:flutter/material.dart';
import 'package:polymap/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupPage extends StatefulWidget {
  GroupPage();

  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  bool isDark = false; // same as in cabinet.dart
  String groupNumber = ''; // same as in cabinet.dart

  @override
  void initState() {

    // same as in cabinet.dart
    MyColors.getTheme().then((isDark) {
      setState(() {
        this.isDark = isDark;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            IconData(58848,
                fontFamily: 'MaterialIcons', matchTextDirection: true),
          ),
        ),
        title: Text(
          'Выбор группы',
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 0,
            color: (this.isDark) ? MyColors.gray237 : Colors.white,
          ),
        ),
        backgroundColor:
            (this.isDark) ? MyColors.darkAppBar : MyColors.greenPolyTech,
      ),
      backgroundColor: (this.isDark) ? MyColors.darkBackground : MyColors.gray237,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 3,
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                    text: this.groupNumber,
                    selection: TextSelection.collapsed(
                        offset: this.groupNumber.length),
                  )),
                  onChanged: (searchString) {
                    this.groupNumber = searchString;
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(
                          IconData(59375, fontFamily: 'MaterialIcons'),
                      ),
                    ),
                    hintText: 'Ваша группа...',
                    contentPadding: EdgeInsets.only(top: 15, bottom: 15),
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
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 64,
              child: FloatingActionButton(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                backgroundColor: MyColors.greenPolyTech,
                onPressed: () {
                  setGroup(this.groupNumber);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Сохранить группу',
                  style: TextStyle(
                    fontSize: 20,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                      color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // set user's group number
  static Future<bool> setGroup(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString('group', value);
  }
}
