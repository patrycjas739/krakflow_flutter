import 'package:flutter/material.dart';

//import 'task_repository.dart'
void main() {
  runApp(MyApp());
}

class TaskRepository {
  static List<Task> tasks = [
    Task(
      title: "Zadanie z metodologii",
      deadline: "sroda za tydzien",
      done: false,
      priority: "sredni",
    ),
    Task(
      title: "Napisac sprawozdanie",
      deadline: "do konca miesiaca",
      done: false,
      priority: "niski",
    ),
    Task(
      title: "Nadrobic fluttera",
      deadline: "do wtorku",
      done: true,
      priority: "sredni",
    ),
    Task(
      title: "Projekt strony internetowej",
      deadline: "do konca miesiaca",
      done: false,
      priority: "wysoki",
    ),
  ];
}

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

  @override
  Widget build(BuildContext context) {
    int tasksToDo = TaskRepository.tasks.where((task) => !task.done).length;
    List<Task> filteredTasks = TaskRepository.tasks;

    if (selectedFilter == "wykonane"){
      filteredTasks = TaskRepository.tasks
          .where((task) => task.done)
          .toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks
          .where((task) => !task.done)
          .toList();
    }

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
                onPressed: () {
                  setState(() {
                    TaskRepository.tasks.clear();
                  });
                  Navigator.pop(context);
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

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Masz dziś $tasksToDo zadania"),
            SizedBox(height:8),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = "wszystkie";
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: selectedFilter == "wszystkie" ? Colors.blue : Colors.grey,
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
                      foregroundColor: selectedFilter == "do zrobienia" ? Colors.blue : Colors.grey,
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
                      foregroundColor: selectedFilter == "wykonane" ? Colors.blue : Colors.grey,
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
                    key: ValueKey(task.title),
                    onDismissed: (direction) {
                      setState(() {
                        TaskRepository.tasks.remove(task);
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
                        onChanged: (value) {
                          setState(() {
                            task.done = value!;
                          });
                        },
                      onTap: () async {
                        final Task? updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(task: task),
                          ),
                        );
                        if (updatedTask != null) {
                          setState(() {
                            TaskRepository.tasks[index] = updatedTask;
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
              TaskRepository.tasks.add(newTask);
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
  bool done;
  final String priority;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
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
