import 'package:ekskul/constant/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

String jsonserver =
    "https://my-json-server.typicode.com/WageSapta/json-server/";



push(BuildContext context, Widget widget) =>
    Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
pushreplacement(BuildContext context, Widget widget) =>
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => widget));
pushreplacementnamed(BuildContext context, String routeName) =>
    Navigator.pushReplacementNamed(context, routeName);
pushnamed(BuildContext context, String routeName) =>
    Navigator.of(context).pushNamed(routeName);
