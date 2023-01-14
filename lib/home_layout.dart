// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled1/cubit.dart';
import 'package:untitled1/states.dart';

import 'archived_tasks/archived_taks_screen.dart';
import 'constants.dart';
import 'done_tasks/done_tasks_screen.dart';
import 'new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text(
              cubit.titles[AppCubit.get(context).currentIndex],
            )),
            body: ConditionalBuilder(
              builder: (context) => cubit.screens[cubit.currentIndex],
              condition: true,
              fallback: (context) => Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              )),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              currentIndex: AppCubit.get(context).currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived tasks',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertIntoDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    //                   insertIntoDatabase(
//                       title: titleController.text,
//                       time: timeController.text,
//                       date: dateController.text)
//                       .then((value) {
//                     getDataFromDataBase(database).then((value) {
//                       Navigator.pop(context);
// // setState(() {
// //   tasks=value;
// //   print(tasks);
// //   fabIcon = Icons.edit;
// //   isBottomSheetShown = false;
// // });
//                     });
//
//                   });

                  }
                } else {
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                  // isBottomSheetShown = true;
// setState(() {
//   fabIcon = Icons.add;
// });
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            height: 250,
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        "Task title",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.title),
                                    ),
                                    controller: titleController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Title can not be empty!";
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        print(
                                            value!.format(context).toString());
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        "Task time",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                    ),
                                    controller: timeController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Time can not be empty!";
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2025-31-12"))
                                          .then((value) {
                                        print(
                                            DateFormat.yMMMd().format(value!));
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        "Task Date",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      prefixIcon:
                                          Icon(Icons.calendar_month_outlined),
                                    ),
                                    controller: dateController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Date must not be empty!";
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(
                          isShow: false,
                          icon: Icons.edit,
                        );

                        // isBottomSheetShown = false;
// setState(() {
//   fabIcon = Icons.edit;
// });
                      });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
