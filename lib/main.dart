import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Task> tasks = [
    Task(title: "Zadanie z metodologii", deadline: "sroda za tydzien", done: false, priority: "sredni"),
    Task(title: "Napisac sprawozdanie", deadline: "do konca miesiaca", done: false, priority: "niski"),
    Task(title: "Nadrobic fluttera", deadline: "do wtorku", done: true, priority: "sredni"),
    Task(title: "Projekt strony internetowej", deadline: "do konca miesiaca", done: false, priority: "wysoki"),
  ];

  @override
  Widget build(BuildContext context) {
    int completedTasks = tasks.where((task) => task.done).length;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text('KrakFlow'))),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Masz dziś ${tasks.length - completedTasks} zadania, wykonano już $completedTasks."),
              SizedBox(height: 16),
              Text(
                "Dzisiejsze zadania",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      title: tasks[index].title,
                      subtitle: '${tasks[index].deadline} | Priorytet: ${tasks[index].priority}',
                      isDone: tasks[index].done,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;
  final bool done;
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

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? Colors.green : Colors.grey,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
