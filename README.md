# f1utter

Simple Formula 1 app written with Flutter.
+ Countdown remaining time until next race
+ Results of completed races
+ Driver and constructor standings
+ Switch between dark and light theme
+ Automatically extract colors from flags with [Material 3 Dynamic Color](https://m3.material.io/styles/color/dynamic-color/user-generated-color#35bc06c5-35d9-4559-9f5d-07ea734cbcb1)

## Screenshots

![Countdown](https://ahmedbera.github.io/img/f1utter-v2-1.png)
![Standings](https://ahmedbera.github.io/img/f1utter-v2-2.png)

## Build/Run
App is configured to run on Android and Web. Easiest way to run is using Visual Studio Code with browser of your choice.

```bash
git clone https://github.com/ahmedbera/f1lutter
cd f1lutter
flutter pub get
flutter pub run flutter_launcher_icons # only if you want to update icons
flutter run
```

## Acknowledgements 
* Data is provided by [Ergast Motor Racing Developer API](https://ergast.com/mrd/)
