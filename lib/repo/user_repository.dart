import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_task_etech_mvvm/helper/database_helper.dart';
import 'package:flutter_practical_task_etech_mvvm/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserRepository extends ChangeNotifier {
  final Dio _dio = Dio();
  List<User> _users = [];
  static Database? _database;

  List<User> get users => _users;
  static int currentPage = 1; // Declare currentPage as static

  static Future<List<User>> fetchUsers({int results = 100}) async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/?page=$currentPage&results=$results'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      currentPage++; // Increment the page for the next request

      return results.map((user) {
        return User(
          name: '${user['name']['first']} ${user['name']['last']}',
          email: user['email'],
          country: user['location']['country'],
          registrationDate: user['registered']['date'],
          userImage: user['picture']['thumbnail'],
          city: user['location']['city'],
          state: user['location']['state'],
          postcode: (user['location']?['postcode'] ?? 0).toString(),
          age: (user['dob']?['age'] ?? 0).toString(),
          birthDate: user['dob']?['date'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<void> insertUser(User user) async {
    final db = await DataBaseHelper().database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<User>> getUsers() async {
    final db = await DataBaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) {
      return User(
        name: maps[index]['name'],
        email: maps[index]['email'],
        country: maps[index]['country'],
        registrationDate: maps[index]['registrationDate'],
        userImage: maps[index]['userImage'],
        city: maps[index]['city'],
        state: maps[index]['state'],
        postcode: maps[index]['postcode'],
        age: maps[index]['age'],
        birthDate: maps[index]['date'],
      );
    });
  }
}
