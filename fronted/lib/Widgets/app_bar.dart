import 'package:flutter/material.dart';
import 'package:fronted/Constants/colors.dart';


AppBar customAppBar() {
  return AppBar(
    title: Text('Django Todos', style: TextStyle(color: Colors.white),),
    backgroundColor: darkBlue,
  );
}