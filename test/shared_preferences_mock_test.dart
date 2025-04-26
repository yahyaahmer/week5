import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:week5/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart';

void main() {
  group('SharedPreferences Mock Test', () {
    test('loadTodos should load todos from shared preferences', () async {
      
      final mockPrefs = MockSharedPreferences();
      const fakeTodoList = '[{"title":"Mock Task","done":false}]';

      when(mockPrefs.getString('todos')).thenReturn(fakeTodoList);

      final state = TodoPageStateForTest(prefs: mockPrefs);
      await state.loadTodos();

      expect(state.todos.length, 1);
      expect(state.todos[0]['title'], 'Mock Task');
      expect(state.todos[0]['done'], false);
    });
  });
}

class TodoPageStateForTest {
  final SharedPreferences prefs;
  List<Map<String, dynamic>> todos = [];

  TodoPageStateForTest({required this.prefs});

  Future<void> loadTodos() async {
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> decoded = jsonDecode(todosString);
      todos = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }
}
