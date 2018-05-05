import 'package:flutter/material.dart';
import 'package:f1utter/persistent_state.dart';
import 'dart:async';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() {
    return new _SettingsPageState();
  }
}


class _SettingsPageState extends State<SettingsPage> {
  var selected;

  Future<Null> _colorDialog(colorType) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          contentPadding: new EdgeInsets.symmetric( horizontal: 8.0, vertical: 16.0),
          title: new Text("Choose a color"),
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new Wrap(
                runAlignment: WrapAlignment.start,
                runSpacing: 4.0,
                spacing: 4.0,
                children: colorType == "accent" ?
                  Colors.accents.map((color){
                    return new CircleAvatar(
                      backgroundColor: color,
                      child: new InkWell(
                        onTap: () {
                          GlobalData.accentColor.value = color;
                          Navigator.pop(context);
                        },
                        child: GlobalData.accentColor.value == color ? new Icon(Icons.check) : null,
                      )
                    );
                  }).toList() : 
                  Colors.primaries.map((color){
                    return new CircleAvatar(
                      backgroundColor: color,
                      child: new InkWell(
                        onTap: () {
                          GlobalData.primaryColor.value = color;
                          Navigator.pop(context);
                        },
                        child: GlobalData.primaryColor.value == color ? new Icon(Icons.check) : null,
                      )
                    );
                  }).toList(),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new SimpleDialogOption(
                  child: new Text("Cancel"),
                  onPressed: () { Navigator.pop(context);},
                )
              ],  
            )
          ],
        );
      }
    );
  }

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
          subtitle: new Text("Choose your base theme (light or dark)"),
          trailing: new PopupMenuButton(
            onSelected: (var value) { GlobalData.appBrightness.value = value; },
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
        new ListTile(
          title: new Text("Primary Color"),
          onTap: () {_colorDialog("primary");},
          enabled: Theme.of(context).brightness == Brightness.light ? true : false,
          subtitle: new Text("Only works with light theme"),
          trailing: new CircleAvatar(
             backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        new Divider(),
        new ListTile(
          title:  new Text("Accent Color"),
          onTap: () {_colorDialog("accent");},
          trailing: new CircleAvatar(
             backgroundColor: Theme.of(context).accentColor,
          ),
        ),
        new Divider(),
      ],
    );
  }

}
