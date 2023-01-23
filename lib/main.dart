import 'package:f1lutter/routes/countdown_route.dart';
import 'package:f1lutter/routes/settings_route.dart';
import 'package:f1lutter/routes/standings_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f1lutter/models/settings_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings(),
      child: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CountdownRoute(),
    StandingsRoute(),
    SettingsRoute(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var settingsState = context.watch<Settings>();

    return MaterialApp(
      title: 'Namer App',
      theme: settingsState.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("F1utter"),
          elevation: 3,
          scrolledUnderElevation: 3,
          actions: settingsState.scaffolActions,
        ),
        backgroundColor: settingsState.themeData.colorScheme.background,
        bottomNavigationBar: NavigationBar(
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Countdown',
            ),
            NavigationDestination(
              icon: Icon(Icons.business),
              label: 'Standings',
            ),
            NavigationDestination(
              icon: Icon(Icons.business),
              label: 'Settings',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
