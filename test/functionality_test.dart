import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:task_manager_app/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';

class MockDataProvider extends Mock implements TaskDataProvider {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TaskDataProvider sut;
  late SharedPreferences mockPrefs;

  setUp(() async {
    mockPrefs = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
    sut = TaskDataProvider(mockPrefs);
  });

  test(
    "initial values are correct",
    () {
      sut.getTasks();
      expect(sut.tasks, []);
    },
  );

  group('Task', () {
    test('Add new task', () async {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sut = TaskDataProvider(sharedPreferences);
      final task = TaskModel(
          id: 'id',
          title: 'title',
          description: 'description',
          startDateTime: DateTime.now(),
          stopDateTime: DateTime.now());
      expect(sut.tasks.length, 0);
      await sut.createTask(task);
      expect(sut.tasks.length, 1);
    });

    test('Delete task', () async {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sut = TaskDataProvider(sharedPreferences);
      final task = TaskModel(
          id: 'delete_task_id',
          title: 'delete_task_title',
          description: 'delete_task_description',
          startDateTime: DateTime.now(),
          stopDateTime: DateTime.now());
      sut.createTask(task);
      expect(sut.tasks.length, 1);
      expect(sut.tasks[0].id, 'delete_task_id');
      sut.deleteTask(task);
      expect(sut.tasks.length, 0);
    });
  });
}
