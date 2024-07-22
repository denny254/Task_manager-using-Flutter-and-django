import 'dart:convert';
import 'package:fronted/Constants/api.dart';
import 'package:fronted/Models/todo.dart';
import 'package:http/http.dart' as http;

HelperFunction helperFunction = HelperFunction();

class HelperFunction {
  Future<List<Todo>> fetchData() async {
    List<Todo> myTodos = [];
    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var todo in data) {
          Todo t = Todo(
            id: todo['id'],
            title: todo['title'],
            desc: todo['desc'],
            isDone: todo['isDone'],
            date: todo['date'],
          );
          myTodos.add(t);
        }
        print(myTodos.length);
        return myTodos;
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return myTodos;
  }

  Future<void> postData({required String title, required String desc}) async {
    try {
      final response = await http.post(
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
        print("Todo added successfully.");
      } else {
        print("Failed to add todo. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding todo: $e");
    }
  }

  Future<void> updateTodo({
    required int id,
    required String title,
    required String desc,
    required bool isDone,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$api/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "title": title,
          "desc": desc,
          "isDone": isDone,
        }),
      );
      if (response.statusCode == 200) {
        print("Todo updated successfully.");
      } else {
        print("Failed to update todo. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating todo: $e");
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$api/$id'));
      if (response.statusCode == 204) {
        print("Todo deleted successfully.");
      } else {
        print("Failed to delete todo. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }
}
