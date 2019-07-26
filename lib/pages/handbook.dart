import 'package:flutter/material.dart';
import 'package:polymap/colors.dart';

class HandbookPage extends StatefulWidget {
  HandbookPage();

  @override
  HandbookPageState createState() => HandbookPageState();
}

class HandbookPageState extends State<HandbookPage> {
  bool isDark = false; // same as in cabinet.dart

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
        title: Text(
          'Справочник',
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
      body: Center(
        child: Text(
          'Comming soon…',
          style: TextStyle(
            fontSize: 22,
            color: (this.isDark)
                ? MyColors.gray237Opacity07
                : MyColors.gray77Opacity07,
          ),
        ),
      ),
    );
  }
}
