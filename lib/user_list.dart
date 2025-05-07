import 'package:flutter/material.dart';
import 'package:registration_app/services/database_service.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, Object?>> userList = [];

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  Future<void> getUserList() async {
    userList = await _databaseService.getUserList();
    setState(() {});
  }

  Future<void> _showEditDialog(Map<String, Object?> user) async {
    final TextEditingController emailController =
    TextEditingController(text: user['emailId'] as String);
    final TextEditingController passwordController =
    TextEditingController(text: user['password'] as String);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _databaseService.updateUser(
                id: user['id'] as int,
                emailId: emailController.text,
                password: passwordController.text,
              );
              Navigator.pop(context);
              getUserList();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(int id) async {
    await _databaseService.deleteUser(id);
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        backgroundColor: Color(0xFFFBBB3B),
        elevation: 0,
      ),
      body: userList.isEmpty
          ? const Center(child: Text("No users found."))
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          var item = userList[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(item['emailId'] as String),
              subtitle: Text("Password: ${item['password']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditDialog(item),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(item['id'] as int),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}
