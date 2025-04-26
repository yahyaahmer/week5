import 'package:flutter_test/flutter_test.dart';

class TodoService {
  List<Map<String, dynamic>> todos = [];

  void toggleTodo(int index) {
    todos[index]['done'] = !(todos[index]['done']);
  }
}


void main() {
  group('TodoService Tests', () {
    test('toggleTodo should flip the done status', () {
      final service = TodoService();
      service.todos = [
        {'title': 'Test Task', 'done': false},
      ];

      service.toggleTodo(0);

      expect(service.todos[0]['done'], true);

      service.toggleTodo(0);

      expect(service.todos[0]['done'], false);
    });
  });
}
