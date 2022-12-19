import 'package:auth_sqflite/screens/login.dart';
import 'package:auth_sqflite/services/crud.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    this.email,
  }) : super(key: key);
  final String? email;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool? _userPresent;

  void checkUsers() async {
    bool val = await Crud.users();
    setState(() {
      _userPresent = val;
      if (widget.email == null || !val) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.email ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
