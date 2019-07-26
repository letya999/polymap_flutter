import 'package:flutter/material.dart';
import 'package:polymap/pages/root.dart';
import 'package:polymap/pages/search.dart';
import 'package:polymap/colors.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:polymap/pages/groupPage.dart';
import 'package:polymap/pages/schedulePage.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database = new FirebaseDatabase();
    database.setPersistenceEnabled(true);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyColors.greenPolyTech,
        cursorColor: MyColors.greenPolyTech,
      ),
      home: RestartWidget(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/searchPage':
            return new MyCustomRoute(
              builder: (_) => new SearchPage(),
              settings: settings,
            );
          case '/groupPage':
            return new MyCustomRoute(
              builder: (_) => new GroupPage(),
              settings: settings,
            );
          case '/schedulePage':
            return new MyCustomRoute(
              builder: (_) => new SchedulePage(),
              settings: settings,
            );
        }
        assert(false);
      },
    );
  }
}

class RestartWidget extends StatefulWidget {

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = new UniqueKey();
  int startPage = 0;

  void restartApp() {
    this.setState(() {
      this.key = new UniqueKey();
      this.startPage = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: RootPage(startPage),
    );
  }
}
