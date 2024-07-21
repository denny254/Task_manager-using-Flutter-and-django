import 'dart:convert';
import 'package:fronted/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fronted/Constants/api.dart';
import 'package:fronted/Models/todo.dart';
import 'package:fronted/Widgets/todo_container.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int done = 0;
  
  List<Todo> myTodos = [];
  bool isLoading = true;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _showModel() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: Column(
              children: [
                Text(
                  "Add your Todos",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _postData(title: _titleController.text, desc: _descController.text);
                    _titleController.clear();
                    _descController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body);
      data.forEach((todo) {
        Todo t = Todo(
          id: todo['id'],
          title: todo['title'],
          desc: todo['desc'],
          isDone: todo['isDone'],
          date: todo['date'],
        );
        if (todo['isDone']) {
          done += 1;
        }
        myTodos.add(t);
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error is $e");
    }
  }

  void _postData({required String title, required String desc}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "title": title,
          "desc": desc,
          "isDone": false,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          myTodos = [];
        });
        fetchData();
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print("Error is $e");
    }
  }

  void delete_todo(String id) async {
    try {
      // ignore: unused_local_variable
      http.Response response = await http.delete(Uri.parse(api + "/" + id));
      setState(() {
        myTodos = [];
      });
      fetchData();
    } catch (e) {
      print(e);
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
      backgroundColor: Color(0xFF001133),
      appBar: customAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            PieChart(
              dataMap: {
                "Done": done.toDouble(),
                "Incomplete": (myTodos.length - done).toDouble(),
              },
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: myTodos.map((e) {
                      return TodoContainer(
                        id: e.id,
                        onPressed: () => delete_todo(e.id.toString()),
                        title: e.title,
                        desc: e.desc,
                        isDone: e.isDone,
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModel,
        child: Icon(Icons.add),
      ),
    );
  }
}
