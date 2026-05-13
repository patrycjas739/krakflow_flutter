import '../main.dart';
import 'task_local_database.dart';

class TaskSyncService {
  static Future<void> loadInitialDataIfNeeded() async {
    if (!TaskLocalDatabase.isEmpty()) {
      return;
    } 
    else {
      final tasks = await TaskApiService.fetchTasks();
      await TaskLocalDatabase.saveTasks(tasks);
    }
  }
}
