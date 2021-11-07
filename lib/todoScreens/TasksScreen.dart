import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data.dart';

import '../Components.dart';
import '../tasks_cubit.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit,TasksState>(
      builder: (context, state) {
        TasksCubit cubit =TasksCubit.get(context);
        return buildTaskListView(cubit.activeList,cubit);
      },
      listener: (context, state) {

      },
    );
  }
}
