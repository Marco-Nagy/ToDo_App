import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/todoScreens/ArchiveScreen.dart';
import 'package:todo_app/todoScreens/DoneScreen.dart';
import 'package:todo_app/todoScreens/TasksScreen.dart';


abstract class TasksState {}

class InitTasksState extends TasksState {}

class BottomNavigationState extends TasksState {}

class BottomSheetState extends TasksState {}

class InsertTasksState extends TasksState {}

class DeleteTasksState extends TasksState {}

class GetTasksState extends TasksState {}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit(TasksState initialState) : super(initialState);

  static TasksCubit get(context) => BlocProvider.of(context);

  int bottomNavIndex = 0;

  onBottomNavigationChange({required int newIndex}) {
    bottomNavIndex = newIndex;

    emit(
        BottomNavigationState()); //emit == setState , emit Refresh all BlockConsumer
  }

  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchiveScreen()];
  List<String> titles = ["TasksScreen", "DoneScreen", "ArchiveScreen"];

  bool isSheetExpanded = false;

  onBottomSheetExpanded({required bool isExpanded}) {
    isSheetExpanded = isExpanded;
    emit(BottomSheetState());
  }

  late Database _database;
  List<Map> activeList = [];
  List<Map> archiveList = [];
  List<Map> doneList = [];

  openMyDatabase() async {
    // _database = await openDatabase("My.tasksDB", version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table
    //   await db.execute(
    //       'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, value INTEGER, num REAL)');
    // });

    // openDatabase("My.tasksDB", version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table
    //   await db.execute(
    //       'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, value INTEGER, num REAL)');
    // }).then((value) {
    //   _database = value;
    // });

    openDatabase(
      "My.tasksDB",
      version: 1,
      onCreate: (Database db, int version) async {
        print('Database Created');
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT,status TEXT)');
      },
      onOpen: (db) {
        _database = db;
        print('Database Opened');
        emit(InitTasksState());
        getTasks(status: "active");
        getTasks(status: "done");
        getTasks(status: "archive");
      },
    );
  }

  insertTask({
    required String title,
    required String date,
    required String time,
    String status = "active",
  }) async {
    await _database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time , status) VALUES(" $title ", "$date", "$time","$status")')
          .then((value) {
        emit(InitTasksState());
        getTasks(status: status);
      }).catchError((error) {
        print('Row Error =>  $error');
      });
    });
  }

  getTasks({required String status}) async {
    _database
        .rawQuery('SELECT * FROM Tasks WHERE status = "$status"')
        .then((value) {
      if (status == "active")
        activeList = value;
      else if (status == "done")
        doneList = value;
      else if (status == "archive") archiveList = value;
      emit(GetTasksState());
    });
  }

  var deletedTask;

  deleteTasks({required task}) async {
    deletedTask = task;
    await _database.rawDelete(
        'DELETE FROM Tasks WHERE id = ?', ['${task['id']}']).then((value) {
      emit(DeleteTasksState());
      getTasks(status: "active");
      getTasks(status: "done");
      getTasks(status: "archive");
      print('Task Deleted = $value');
    }).catchError((error) {
      print('Error Task Deleted=>  $error');
    });
  }

  undoDelete() {
    insertTask(
      title: deletedTask['title'],
      date: deletedTask['date'],
      time: deletedTask['time'],
      status: deletedTask['status'],
    );
  }

  updateTasks({
    required String status,
    required int id,
  }) async {
    await _database.rawUpdate(
        'UPDATE Tasks  SET status = ? WHERE id = ?', ['$status', id]);
  }
}
