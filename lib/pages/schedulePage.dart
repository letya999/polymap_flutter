import 'package:flutter/material.dart';
import 'package:polymap/colors.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage();

  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  bool isDark = false;

  @override
  void initState() {
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
          'Расписание',
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