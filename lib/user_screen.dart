import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_fake_user_package/user_model.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;

// React native equivalent of the commented code.
// {
//     dataList && dataList.map((value) => (
//     <>
//     ...
//     </>))
// }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                      child: Text(user.name.firstname[0].toUpperCase())),
                  title: Text('${user.name.firstname} ${user.name.lastname}'),
                  subtitle: Text(user.email),
                  trailing: Text(user.username),
                );
              },
            );
          }
        },
      ),
    );
  }
}
