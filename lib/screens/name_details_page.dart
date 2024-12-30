import 'package:flutter/material.dart';

class NameDetailsPage extends StatelessWidget {
  final String nickname;
  final String fullName;

  NameDetailsPage({required this.nickname, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for $nickname'),
      ),
      body: Center(
        child: Text(
          fullName,
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
