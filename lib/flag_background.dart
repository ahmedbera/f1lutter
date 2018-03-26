import 'package:flutter/material.dart';
import 'race_card.dart';
import 'dart:ui';

class FlagBackground extends StatelessWidget {
  FlagBackground({Key key, this.closestRace});
  
  final Race closestRace;

  @override
    Widget build(BuildContext context) {
      return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new ExactAssetImage('assets/flags/' + closestRace.country + '.png'),
          fit: BoxFit.cover,
        ),
        gradient: new LinearGradient(
          begin: const Alignment(0.0, -1.0),
          end: const Alignment(0.0, 0.6),
          colors: <Color>[
            const Color(0xffef5350),
            const Color(0x00ef5350)
          ],
        ),
      ),
      child: new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: new Container(
          decoration: new BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            gradient: new LinearGradient(
              begin: const Alignment(0.0, .0),
              end: const Alignment(1.0, .0),
              colors: <Color> [
                Colors.black.withOpacity(1.0),
                Colors.black.withOpacity(0.30)
              ]
            )
          ),
        ),
      ),
    );
  }
}