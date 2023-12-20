import 'package:flutter/material.dart';
import 'package:flutter_practical_task_etech_mvvm/repo/user_repository.dart';
import 'package:flutter_practical_task_etech_mvvm/screens/user/user_list_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserRepository()),
        ],
        child: UserListScreen(),
      ),
    );
  }
}


