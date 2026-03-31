import 'package:flutter/material.dart';
//import 'task_repository.dart'
void main() {
  runApp(MyApp());
}

class TaskRepository {
  static List<Task> tasks = [
    Task(title: "Zadanie z metodologii",
        deadline: "sroda za tydzien",
        done: false,
        priority: "sredni"),
    Task(title: "Napisac sprawozdanie",
        deadline: "do konca miesiaca",
        done: false,
        priority: "niski"),
    Task(title: "Nadrobic fluttera",
        deadline: "do wtorku",
        done: true,
        priority: "sredni"),
    Task(title: "Projekt strony internetowej",
        deadline: "do konca miesiaca",
        done: false,
        priority: "wysoki"),
  ];
}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //int completedTasks = (TaskRepository.tasks).where((task) => task.done).length;

    return MaterialApp(
      home: DynamicznyMyApp(),
    );
  }
}

class AddTaskScreen extends StatelessWidget{
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
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
            Text("Tutaj bedzie formularz dodawania taska"),
            ElevatedButton(
              onPressed: () {
                child: Text("Zapisz"),
            )
          ]
        )
      ),
    );
  }
}

class DynamicznyMyApp extends StatefulWidget{
  const DynamicznyMyApp({super.key});

  @override
  State<StatefulWidget> createState(){
    return StanDynamicznegoWidgetu();
  }
}

class StanDynamicznegoWidgetu extends State<DynamicznyMyApp>{
  @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
        title: Center(child: Text('KrakFlow'))),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Masz dziś ${TaskRepository.tasks.length} zadania"),

          //wykonano już $completedTasks."),
          SizedBox(height: 16),
          Text(
            "Dzisiejsze zadania",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: TaskRepository.tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  title: TaskRepository.tasks[index].title,
                  subtitle: '${TaskRepository.tasks[index].deadline} | Priorytet: ${TaskRepository.tasks[index].priority}',
                  isDone: TaskRepository.tasks[index].done,
                );
              },
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );
        },
        child: Icon(Icons.add)
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
