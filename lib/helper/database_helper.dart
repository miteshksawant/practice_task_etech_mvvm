import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practical_task_etech_mvvm/model/user_model.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DataBaseHelper {
  List<User> _users = [];
  static Database? _database;

  List<User> get users => _users;
  static int currentPage = 1; // Declare currentPage as static

  Future<List<User>> fetchUsers({int results = 100}) async {
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

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, country TEXT, registrationDate TEXT, userImage TEXT, city TEXT, state TEXT, postcode TEXT, age TEXT, birthDate TEXT)',
        );
      },
    );
  }

}