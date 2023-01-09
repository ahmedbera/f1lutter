// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:f1lutter/models/settings_model.dart';
import 'package:provider/provider.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsState = context.watch<Settings>();
    var isDarkTheme = settingsState.themeData.brightness == Brightness.dark;

    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        SwitchListTile(
          title: Text("Dark Theme"),
          value: isDarkTheme,
          onChanged: (value) {
            settingsState.setBrightness(value);
          },
        )
      ],
    );
  }
}
