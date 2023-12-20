import 'package:flutter/material.dart';
import 'package:flutter_practical_task_etech_mvvm/model/user_model.dart';
import 'package:flutter_practical_task_etech_mvvm/usage/app_comman.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  const UserDetailScreen({Key? key,required this.user}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4285F4), Color(0xFF34A853)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(widget.user.userImage ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade600,
                        ),
                        child: Center(
                          child: Text(
                            widget.user.age ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              const Divider(height: 2, color: Colors.grey, thickness: 2.0),
              const SizedBox(height: 8.0),
              const Text(
                "Email:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.user.email),
              const SizedBox(height: 8.0),
              const Text(
                "Date Joined:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                AppComman.getFormattedDate(
                    dateTime: DateTime.parse(widget.user.registrationDate)),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              const Text(
                "DOB:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                AppComman.getFormattedDate(
                    dateTime: DateTime.parse(widget.user.birthDate ?? "")),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              const Divider(height: 2, color: Colors.grey, thickness: 2.0),
              const SizedBox(height: 8.0),
              const Text(
                "City:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.user.city),
              const SizedBox(height: 8.0),
              const Text(
                "State:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.user.state),
              const SizedBox(height: 8.0),
              const Text(
                "Country:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.user.country),
              const SizedBox(height: 8.0),
              const Text(
                "Postcode:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.user.postcode ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
