import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Components.dart';
import 'package:todo_app/tasks_cubit.dart';


class Home extends StatelessWidget {
  late BuildContext context;

  var _scaffoldKye = GlobalKey<ScaffoldState>();
  var _formKye = GlobalKey<FormState>();
  var _titleController = TextEditingController();
  var _dateController = TextEditingController();
  var _timeController = TextEditingController();
  late TasksCubit cubit;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   openMyDatabase();
  // }

  @override
  Widget build(BuildContext context) {

    this.context = context;
    return BlocProvider(
      create: (context) => TasksCubit(InitTasksState())..openMyDatabase(),
      child: BlocConsumer<TasksCubit,TasksState>(
        builder: (context, state) {
          cubit = TasksCubit.get(context);
          return Scaffold(
              key: _scaffoldKye,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.bottomNavIndex]),
              ),
              floatingActionButton: cubit.bottomNavIndex == 0
                  ? FloatingActionButton(
                onPressed: () {
                  if (cubit.isSheetExpanded) {
                    if (_formKye.currentState!.validate()) {
                      String title = _titleController.text;
                      String date = _dateController.text;
                      String time = _timeController.text;
                      print('Title : $title, Date : $date , Time : $time ');
                      cubit.insertTask(title: title, date: date, time: time,);
                      // setState(() {
                      //
                      // });

                      Navigator.pop(context);
                    }
                  } else {
                    _scaffoldKye.currentState!
                        .showBottomSheet((context) => buildBottomSheet(),
                        elevation: 20)
                        .closed
                        .then((value) {
                      //cubit.isSheetExpanded = false;
                      cubit.onBottomSheetExpanded(isExpanded: false);
                      _titleController.text = "";
                      _dateController.text = "";
                      _timeController.text = "";
                      // setState(() {});
                    });
                    // cubit.isSheetExpanded = true;
                    cubit.onBottomSheetExpanded(isExpanded: true);
                    // setState(() {});
                  }
                },
                child: Icon(
                  cubit.isSheetExpanded ? Icons.add : Icons.edit,
                ),
              )
                  : null,
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: cubit.bottomNavIndex,
                  type: BottomNavigationBarType.fixed,
                  elevation: 50,
                  backgroundColor: Colors.white70,
                  onTap: (value) {
                   // cubit.bottomNavIndex = value;
                    cubit.onBottomNavigationChange( newIndex: value);
                    // setState(() {});
                  },
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Tasks"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.done_all_rounded), label: "Done"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive), label: "Archive"),
                  ]),
              body: cubit.screens[cubit.bottomNavIndex]);
        },
        listener: (context, state) {
      if(state is DeleteTasksState){
        showSnackBar();
      }
        },
      ),
    );
  }
  void showSnackBar(){
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Task Deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          cubit.undoDelete();
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    _scaffoldKye.currentState!.showSnackBar(snackBar);
  }

  Widget buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      color: Colors.white70,
      child: Form(
        key: _formKye,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            defaultTextField(
              controller: _titleController,
              type: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Title required";
                }
                return null;
              },
              label: "Title",
              prefixIcon: Icons.title,
            ),
            SizedBox(
              height: 10,
            ),
            defaultTextField(
              onTap: () => _selectDate(context),
              controller: _dateController,
              type: TextInputType.datetime,
              validator: (value) {
                if (value.isEmpty) {
                  return "Date required";
                }
                return null;
              },
              label: "Date",
              prefixIcon: Icons.date_range,
            ),
            SizedBox(
              height: 10,
            ),
            defaultTextField(
              controller: _timeController,
              validator: (value) {
                if (value.isEmpty) {
                  return "Time required";
                }
                return null;
              },
              label: "Time",
              prefixIcon: Icons.watch_later,
              onTap: () => _selectTime(),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) _selectedDate = picked;
    _dateController.text =
        "${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}";
  }

  late TimeOfDay _time =TimeOfDay.now();

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time ,
    );
    if (newTime != null) {
      _time = newTime;
      _timeController.text = _time.format(context);
    }
  }


}
