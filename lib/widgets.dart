import 'package:flutter/material.dart';
import 'package:untitled1/cubit.dart';
import 'package:untitled1/cubit.dart';

Widget TaskItem(Map model,context)=>Padding(

  padding: const EdgeInsets.all(20.0),

  child: Row(

  mainAxisSize: MainAxisSize.min,

  mainAxisAlignment: MainAxisAlignment.start,

  crossAxisAlignment: CrossAxisAlignment.start,

  children: [

  CircleAvatar(

  radius: 40,

  child: Text("${model['time']}",),

  ),

  SizedBox(width: 10,),

  Expanded(

    child:Column(

                crossAxisAlignment: CrossAxisAlignment.start,

    children: [

    Text("${model['title']}",style: TextStyle(

    fontSize: 18,

    fontWeight: FontWeight.bold

    ),),

    Text("${model['data']}",style: TextStyle(

    fontSize: 18,

    color: Colors.blueGrey

    ),),

    ],

    ),

  ),

    SizedBox(width: 10,),

    IconButton(onPressed: () {

       AppCubit.get(context).updateDataBase(id: model['id'], status: "done");

    }, icon: Icon(Icons.check_box),color: Colors.green,),

    IconButton(onPressed: () {

       AppCubit.get(context).updateDataBase(id: model['id'], status: "archive");

    }, icon: Icon(Icons.archive),color: Colors.black45,),

  ],

  ),

  );