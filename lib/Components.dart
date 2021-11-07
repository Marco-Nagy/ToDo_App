import 'package:flutter/material.dart';
import 'package:todo_app/tasks_cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 30,
  required String text,
  Function()? function,}) =>
    Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );

Widget defaultTextField({
  required TextEditingController controller,
  TextInputType? type,
  TextInputAction inputAction = TextInputAction.next,
  required FormFieldValidator validator,
  required String label,
  required IconData prefixIcon,
  Widget? suffixIcon,
  bool obscureText = false,
  GestureTapCallback? onTap,
}) =>
    TextFormField(
      onTap: onTap,
      controller: controller,
      obscureText: obscureText,
      keyboardType: type,
      textInputAction: inputAction,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        prefixIcon: Icon(prefixIcon,
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );

Widget buildTaskListView(List<Map> list, TasksCubit cubit) {
  Widget buildTaskItem(int index) {
    return Dismissible(
      key: Key(list[index]['id'].toString()),
      onDismissed:(direction) {
        cubit.deleteTasks(task: list[index]);

      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30)
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(
                  list[index]['title'], style: TextStyle(fontSize: 20,),)),
                IconButton(onPressed: () {
                  cubit.updateTasks(status: "done", id: list[index]['id']);
                  cubit.getTasks(status: "active");
                  cubit.getTasks(status: "archive");
                  cubit.getTasks(status: "done");
                }, icon: Icon(Icons.done_all, color: Colors.blue,)),
                IconButton(onPressed: () {
                  cubit.updateTasks(status: "archive", id: list[index]['id']);
                  cubit.getTasks(status: "active");
                  cubit.getTasks(status: "archive");
                  cubit.getTasks(status: "done");
                }, icon: Icon(Icons.archive, color: Colors.blue,)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date :${list[index]['date']}",
                    style: TextStyle(fontSize: 16,)),
                Text("Time : ${list [index]['time']}",
                    style: TextStyle(fontSize: 16,)),
              ],
            )
          ],
        ),
      ),
    );
  }
  return ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(index),
    separatorBuilder: (context, index) => SizedBox(width: 10,),
    itemCount: list.length,
  );
}