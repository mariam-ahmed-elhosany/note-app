import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit.dart';
import '../states.dart';
import '../widgets.dart';

class DoneTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(builder: (context,state){
      var tasks=AppCubit.get(context).doneTasks;
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