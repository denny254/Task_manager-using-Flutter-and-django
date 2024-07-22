import 'package:fronted/Constants/colors.dart';
import 'package:fronted/Utils/methods.dart';
import 'package:fronted/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fronted/Models/todo.dart';
import 'package:fronted/Widgets/todo_container.dart';
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

  get title => null;
  get desc => null;

  void _showModel({Todo? todo}) {
    if (todo != null) {
      _titleController.text = todo.title;
      _descController.text = todo.desc;
    } else {
      _titleController.clear();
      _descController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: Column(
              children: [
                Text(
                  todo == null ? "Add your Todos" : "Update your Todo",
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
                    if (todo == null) {
                      _postData(
                          title: _titleController.text,
                          desc: _descController.text);
                    } else {
                      _updateTodo(
                          id: todo.id,
                          title: _titleController.text,
                          desc: _descController.text,
                          isDone: todo.isDone);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(todo == null ? "Add" : "Update"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchData() async {
    List<Todo> todos = await helperFunction.fetchData();
    setState(() {
      myTodos = todos;
      done = todos.where((todo) => todo.isDone).length;
      isLoading = false;
    });
  }

  void _postData({required String title, required String desc}) async {
    await helperFunction.postData(title: title, desc: desc);
    fetchData();
  }

  void _updateTodo(
      {required int id,
      required String title,
      required String desc,
      required bool isDone}) async {
    await helperFunction.updateTodo(
        id: id, title: title, desc: desc, isDone: isDone);
    fetchData();
  }

  void _deleteTodo(int id) async {
    await helperFunction.deleteTodo(id);
    fetchData();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
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
                        onPressed: () {
                          _deleteTodo(e.id);
                        },
                        title: e.title,
                        desc: e.desc,
                        isDone: e.isDone,
                        onUpdate: () {
                          _showModel(todo: e);
                        },
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModel(),
        child: Icon(Icons.add),
      ),
    );
  }
}
