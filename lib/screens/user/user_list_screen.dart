import 'package:flutter/material.dart';
import 'package:flutter_practical_task_etech_mvvm/repo/user_repository.dart';
import 'package:flutter_practical_task_etech_mvvm/screens/user/user_detail_screen.dart';
import 'package:flutter_practical_task_etech_mvvm/usage/app_comman.dart';
import 'package:provider/provider.dart';
import 'package:flutter_practical_task_etech_mvvm/model/user_model.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> usersFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    usersFuture = loadUsers();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the end of the list, load more data
      loadMoreUsers();
    }
  }

  Future<void> loadMoreUsers() async {
    final List<User> moreUsers = await UserRepository.fetchUsers();
    if (moreUsers.isNotEmpty) {
      setState(() {
        usersFuture =
            usersFuture.then((existingUsers) => existingUsers + moreUsers);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<User>> loadUsers() async {
    final cachedUsers = await UserRepository.getUsers();

    if (cachedUsers.isNotEmpty) {
      return cachedUsers;
    } else {
      final users = await UserRepository.fetchUsers();
      users.forEach((user) async {
        await UserRepository.insertUser(user);
      });
      return users;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder(
        future: UserRepository.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("error: ${snapshot.error}");
            return Center(child: Text('Error fetching users'));
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: userRepository.users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailScreen(user: userRepository.users[index]),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                            NetworkImage(userRepository.users[index].userImage ?? ""),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userRepository.users[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          AppComman.getFormattedDate(
                                              dateTime: DateTime.parse(
                                                  userRepository.users[index]
                                                      .registrationDate)),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Icon(Icons.arrow_forward_ios,
                                            size: 10, color: Colors.grey)
                                      ],
                                    ),
                                  ],
                                ),
                                Text(userRepository.users[index].email),
                                Row(
                                  children: [
                                    const Text(
                                      "Country | ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      userRepository.users[index].country,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
