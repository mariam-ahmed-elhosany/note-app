// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/cubit.dart';
import 'package:untitled1/states.dart';
import 'package:untitled1/widgets.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


     return BlocConsumer<AppCubit,AppStates>(builder: (context,state){
      var tasks=AppCubit.get(context).newTasks;
      return ListView.separated(
              itemBuilder: (context, index) => TaskItem(tasks[index],context),
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black26,
                    endIndent: 30,
                    indent: 30,
                  ),
              itemCount: tasks.length);
    }, listener: (context,state){});
  }
}
