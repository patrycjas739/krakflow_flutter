import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'services/task_local_database.dart';
import 'services/task_sync_service.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("tasks");
  runApp(MyApp());
}
class TaskApiService{
  static const String baseUrl = "https://dummyjson.com";
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/todos"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List todos = data["todos"];

      return todos.map((todo) {
        return Task(
          id: todo["id"],
          title: todo["todo"],
            deadline: "brak",
            done: todo["completed"],
            priority: "sredni",
        );
    }).toList();
    } else {
      throw Exception("Blad pobrania danych");
    }
  }
}
// class TaskRepository extends StatelessWidget {
//   const TaskRepository({super.key});
//
//   static List<Task> tasks = [];
//
//   @override
//   Widget build(BuildContext context){
//     return FutureBuilder<List<Task>>(
//       future: TaskApiService.fetchTasks(),
//       builder: (context, snapshot) {
//         if(snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(
//               child: Text("Błąd: ${snapshot.error}"),
//           );
//         }
//           final tasks = snapshot.data!;
//
//           return ListView(
//             children: tasks.map((task) {
//               return Text(task.title);
//             }).toList(),
//           );
//       },
//     );
//   }
//
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //int completedTasks = (TaskRepository.tasks).where((task) => task.done).length;

    return MaterialApp(home: DynamicznyMyApp());
  }
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});


  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nowe zadanie")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Termin wykonania",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final newTask = Task(
                    id: Random().nextInt(1000000),
                    title: titleController.text,
                    deadline: deadlineController.text,
                    done: false,
                    priority: priorityController.text,
                  );
                  Navigator.pop(context, newTask);
                },
                child: Text("Zapisz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicznyMyApp extends StatefulWidget {
  const DynamicznyMyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return StanDynamicznegoWidgetu();
  }
}

class StanDynamicznegoWidgetu extends State<DynamicznyMyApp> {
  String selectedFilter = "wszystkie";
  // bool _isLoading = true;
  // String? _errorMessage;
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    // super.initState();
    // TaskApiService.fetchTasks().then((pobraneZadania) {
    //   setState(() {
    //     TaskRepository.tasks = pobraneZadania;
    //     _isLoading = false;
    //     _errorMessage = null;
    //   });
    // }).catchError((error) {
    //   setState(() {
    //     _isLoading = false;
    //     _errorMessage = error.toString();
    //   });
    //   print("Blad pobierania: $error");
    // });
      super.initState();
      tasksFuture = loadTasks();
    }

    Future<List<Task>> loadTasks() async {
      await TaskSyncService.loadInitialDataIfNeeded();
      return TaskLocalDatabase.getTasks();
    }

  Future<void> addTask(Task task) async {
    await TaskLocalDatabase.addTask(task);
    //await loadTasks();
    setState(() {
      tasksFuture = loadTasks();
    });
  }


  @override
  Widget build(BuildContext context) {
  //   //Waiting (z.3)
  //   if (_isLoading){
  //     return Scaffold(
  //       appBar: AppBar(title: Center(child: Text('KrakFlow'))),
  //       body: Center(child: CircularProgressIndicator()),
  //     );
  // }
  //
  //   //Error (z.3)
  //   if(_errorMessage != null){
  //     return Scaffold(
  //       appBar: AppBar(title: Center(child: Text('KrakFlow'))),
  //         body: Center(
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Text(
  //               "Blad pobierania danych:\n$_errorMessage",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(color: Colors.red, fontSize: 16),
  //             ),
  //           ),
  //         ),
  //     );
  //   }
  //
  //   //Data (z.3)
  //   int tasksToDo = TaskRepository.tasks.where((task) => !task.done).length;
  //   List<Task> filteredTasks = TaskRepository.tasks;
  //
  //   if (selectedFilter == "wykonane"){
  //     filteredTasks = TaskRepository.tasks
  //         .where((task) => task.done)
  //         .toList();
  //   } else if (selectedFilter == "do zrobienia") {
  //     filteredTasks = TaskRepository.tasks
  //         .where((task) => !task.done)
  //         .toList();
  //   }

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('KrakFlow')),
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Potwierdzenie"),
                    content: Text("Czy na pewno chcesz usunąć wszystkie zadania?"),
                    actions: [
                      TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Anuluj"),
                  ),
                TextButton(
                onPressed: () async {
                  await TaskLocalDatabase.deleteAllTasks();
                  Navigator.pop(context);
                  setState(() {
                    tasksFuture = loadTasks();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Wszystkie zadania zostały usunięte")),
                  );
                },
                child: Text("Usuń"),
                ),
                ],
                );
              },
            );
          }
      )
          ]),

      body: FutureBuilder<List<Task>> (
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Błąd: ${snapshot.error}"));
          }

          final tasks = snapshot.data ?? [];

          int tasksToDo = tasks
              .where((task) => !task.done)
              .length;
          List<Task> filteredTasks = tasks;

          if (selectedFilter == "wykonane") {
            filteredTasks = tasks.where((task) => task.done).toList();
          } else if (selectedFilter == "do zrobienia") {
            filteredTasks = tasks.where((task) => !task.done).toList();
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Masz dziś $tasksToDo zadania"),
                SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "wszystkie";
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: selectedFilter == "wszystkie" ? Colors
                            .blue : Colors.grey,
                      ),
                      child: Text("Wszystkie"),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = "do zrobienia";
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: selectedFilter == "do zrobienia"
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        child: Text("Do zrobienia")
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = "wykonane";
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: selectedFilter == "wykonane" ? Colors
                              .blue : Colors.grey,
                        ),
                        child: Text("Wykonane")
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Text(
                  "Dzisiejsze zadania",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),
                        onDismissed: (direction) async {
                          await TaskLocalDatabase.deleteTask(
                              task.id);
                          setState(() {
                            tasksFuture = loadTasks();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Zadanie usunięte")),
                          );
                        },
                        child: TaskCard(
                          title: task.title,
                          subtitle:
                          '${task.deadline} | Priorytet: ${task.priority}',
                          isDone: task.done,
                          onChanged: (value) async {
                            final updatedTask = Task(
                              id: task.id,
                              title: task.title,
                              deadline: task.deadline,
                              priority: task.priority,
                              done: value ?? false,
                            );
                            await TaskLocalDatabase.updateTask(updatedTask);
                            setState(() {
                              tasksFuture = loadTasks();
                            });
                          },

                          onTap: () async {
                            final Task? updatedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditTaskScreen(task: task),
                              ),
                            );
                            if (updatedTask != null) {
                              await TaskLocalDatabase.updateTask(updatedTask);
                              setState(() {
                                tasksFuture = loadTasks();
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final offsetAnimation = Tween<Offset>(
                      begin: Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
            ),
          );
          if (newTask != null) {
            setState(() {
              addTask(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;
  final bool done;
  final String priority;
  final int id;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
    required this.id
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": deadline,
      "priority": priority,
      "done": done,
    };
  }

  factory Task.fromMap(Map map){
    return Task(
      id: map["id"],
      title: map["title"],
      deadline: map["deadline"],
      priority: map["priority"],
      done: map["done"],
    );
  }
}


class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDone;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChanged;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDone,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: isDone, onChanged: onChanged),
        title: Text(
          title,
          style: TextStyle(
            decoration: isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: isDone ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(subtitle,
        style: TextStyle(
          color: isDone ? Colors.grey : Colors.black,
        )),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.title;
    deadlineController.text = widget.task.deadline;
    priorityController.text = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edytuj zadanie")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Termin wykonania",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Task(
                  id: widget.task.id,
                  title: titleController.text,
                  deadline: deadlineController.text,
                  done: widget.task.done,
                  priority: priorityController.text,
                );
                Navigator.pop(context, updatedTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),

    );
  }
}
