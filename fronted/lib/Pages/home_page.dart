import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fronted/Constants/api.dart';
import 'package:fronted/Models/todo.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> myTodos = [];
  void fetchData() async {
    try{
       http.Response response = await http.get(Uri.parse(api));
       var data = json.decode(response.body);
       data.forEach((todo){
        Todo t = Todo(
          id: todo['id'],
          title: todo['title'],
          desc: todo['desc'],
          isDone: todo['isDone'],
          date: todo['date'],
        );
        myTodos.add(t);
       });
       print(myTodos.length);
       
    }
    catch (e) {
      print("Error is $e");
    }
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}