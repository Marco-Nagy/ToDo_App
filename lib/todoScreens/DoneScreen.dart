import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data.dart';

import '../Components.dart';
import '../tasks_cubit.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<TasksCubit,TasksState>(
      builder: (context, state) {

      TasksCubit cubit =TasksCubit.get(context);
        return buildTaskListView(cubit.doneList,cubit);
      },
      listener: (context, state) {

      },
    );
  }
}