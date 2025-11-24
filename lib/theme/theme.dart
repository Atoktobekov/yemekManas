import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'InstrumentSans',

  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    elevation: 3,
    backgroundColor: Colors.white,//Color(0xFFF8D8AA),
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

);
