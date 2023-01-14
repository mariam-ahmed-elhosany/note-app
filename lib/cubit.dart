// ignore_for_file: unnecessary_string_interpolations

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'archived_tasks/archived_taks_screen.dart';
import 'done_tasks/done_tasks_screen.dart';
import 'new_tasks/new_tasks_screen.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => AppCubit.get(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(BottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("Database created");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,data TEXT, time TEXT, status TEXT)')
          .then((value) {
        print("Table created");
      }).catchError((error) {
        print("Error when creating table ${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print("Database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

   insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    //   database!.transaction((txn)async {
    //    txn.rawInsert('INSERT INTO tasks(title,time,data,status)VALUES ("First task", "200","2-2-2022","New")');
    // }).then((value){
    //   print('$value raw inserted');
    // }).catchError((error){
    //   print("Error!!!... ${error.toString()}");
    // });

    await database!.rawInsert(
            'INSERT INTO tasks(title,time,data,status)VALUES ("$title", "$time","$date","New")')
        .then((value) {
      print('$value raw inserted');
      emit(AppInsertDataBaseState());
      getDataFromDataBase(database);
        }).catchError((error) {
      print("Error!!!... ${error.toString()}");
    });
  }

  getDataFromDataBase(database) {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
     database.rawQuery('SELECT * FROM tasks').then((value) {
       newTasks=value;
       // value.forEach((element) {
       //   if (element['status']=='new')
       //     newTasks.add(element);
       //
       //   else if (element['status']=='done')
       //     doneTasks.add(element);
       //   else
       //     archiveTasks.add(element);
       //   print(element['status']);
       // });
        emit(AppGetDataBaseState());
         print(newTasks);

     });


  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    fabIcon = icon;
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetState());
  }

  void updateDataBase({
    required int id,
    required String status,
  }) async {
    await database!.rawUpdate(
      'UPDATE tasks SET status= ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      emit(AppUpdateDataBaseState());
      getDataFromDataBase(database);
    });
  }
//   void deleteDataBase({
//   required id
// }){
//     database!.rawDelete('DELETE  FROM tasks WHERE id=? ',[id]).then((value){
//       getDataFromDataBase(database);
//       emit(AppDeleteDataBaseState());
//     });
//   }
}
