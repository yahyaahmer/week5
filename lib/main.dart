import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> decoded = jsonDecode(todosString);
      setState(() {
        todos = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    } else {
      // Default tasks if nothing saved yet
      setState(() {
        todos = [
          {'title': 'Task 1', 'done': false},
          {'title': 'Task 2', 'done': true},
          {'title': 'Task 3', 'done': false},
          {'title': 'Task 4', 'done': true},
        ];
      });
      saveTodos(); // Save them for the first time
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(todos);
    await prefs.setString('todos', encoded);
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index]['done'] = !todos[index]['done'];
    });
    saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "To Do List",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo['title']),
                    trailing: Checkbox(
                      value: todo['done'],
                      onChanged: (value) {
                        toggleTodo(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
