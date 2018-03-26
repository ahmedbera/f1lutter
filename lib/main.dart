import 'package:flutter/material.dart';
import 'pages/countdown_page.dart';
import 'pages/standings_page.dart';

void main() => runApp(new F1utter());

class F1utter extends StatefulWidget{
  F1utter({Key key});

  @override
  _F1utterState createState() => new _F1utterState();
}

class _F1utterState extends State<F1utter> {
  Brightness brightness = Brightness.light;
  int currentTab = 0;
  CountdownPage countdownPage = new CountdownPage();
  StandingsPage standingsPage = new StandingsPage();
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    pages = [countdownPage, standingsPage];
    currentPage = countdownPage;
  }

  _toggleTheme() {
    if(this.brightness == Brightness.light) {
      setState(() {
        this.brightness = Brightness.dark;
      });
    } else {
      setState(() {
        this.brightness = Brightness.light;
      });
    }
  }
  
  _tabTapped (int tappedTab) {
    setState(() {
      currentTab = tappedTab;
      currentPage = this.pages[tappedTab];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'F1utter',
      home: new MaterialApp(
        theme: new ThemeData( 
          primarySwatch: Colors.red,
          accentColor: Colors.tealAccent,
          brightness: this.brightness,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text("F1utter"),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.lightbulb_outline),
                tooltip: "Toggle Theme",
                onPressed: this._toggleTheme,
              )
            ],
          ),
          bottomNavigationBar: new BottomNavigationBar(
            currentIndex: currentTab,
            onTap: this._tabTapped,
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem( // tab 0
                icon: new Icon(Icons.timer),
                title: new Text("Schedule")
              ),
              new BottomNavigationBarItem( // tab 1
                icon: new Icon(Icons.equalizer),
                title: new Text("Rankings")
              )
            ],
          ),
          body: this.currentPage,
        ),
      )
      //new CountdownPage(title: 'F1utter', swatch: Colors.blue),
    );
  }
}

