import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Components.dart';
import '../data.dart';
import '../tasks_cubit.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<TasksCubit,TasksState>(
      builder: (context, state) {
        TasksCubit cubit = TasksCubit.get(context);
        return buildTaskListView(cubit.archiveList, cubit);
      },
      listener: (context, state) {

      },
    );
  }
}