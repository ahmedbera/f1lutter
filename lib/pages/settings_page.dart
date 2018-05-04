import 'package:flutter/material.dart';
import 'package:f1utter/persistent_state.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() {
    return new _SettingsPageState();
  }
}


class _SettingsPageState extends State<SettingsPage> {
  var selected;
  
  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(8.0),
          color: Theme.of(context).accentColor,
          child: new Text("Visual Settings"),
        ),
        new ListTile(
          title: new Text("Theme"),
          leading: new Icon(Icons.lightbulb_outline),
          trailing: new PopupMenuButton(
            onSelected: (var value) { GlobalData.updateTheme(value); },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Brightness>>[
              const PopupMenuItem(
                value: Brightness.dark,
                child: const Text("Dark"),
              ),
              const PopupMenuItem(
                value: Brightness.light,
                child: const Text("Light"),
              ),
            ],
          ),
        ),
        new Divider(),
      ],
    );
  }

}
