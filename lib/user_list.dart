// import 'package:flutter/material.dart';
// import 'package:registration_app/services/api_service.dart';
//
// class UserList extends StatefulWidget {
//   const UserList({super.key});
//
//   @override
//   State<UserList> createState() => _UserListState();
// }
//
// class _UserListState extends State<UserList> {
//   List<dynamic> userList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getUserList();
//   }
//
//   Future<void> getUserList() async {
//     try {
//       final users = await ApiService.getUserList();
//       setState(() {
//         userList = users;
//       });
//     } catch (e) {
//       debugPrint("Error fetching users: $e");
//     }
//   }
//
//   Future<void> _showEditDialog(Map<String, dynamic> user) async {
//     final TextEditingController emailController =
//     TextEditingController(text: user['email'] ?? '');
//     final TextEditingController passwordController =
//     TextEditingController(); // Password not available from API
//
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit User'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 await ApiService.updateUser(
//                   user['id'],
//                   {
//                     'email': emailController.text,
//                     'password': passwordController.text,
//                   },
//                 );
//                 Navigator.pop(context);
//                 getUserList();
//               } catch (e) {
//                 debugPrint("Error updating user: $e");
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _deleteUser(int id) async {
//     try {
//       await ApiService.deleteUser(id);
//       getUserList();
//     } catch (e) {
//       debugPrint("Error deleting user: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User List"),
//         backgroundColor: Color(0xFFFBBB3B),
//         elevation: 0,
//       ),
//       body: userList.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         padding: const EdgeInsets.all(12.0),
//         itemCount: userList.length,
//         itemBuilder: (context, index) {
//           final user = userList[index];
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 8.0),
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   blurRadius: 6.0,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: ListTile(
//               title: Text(user['email'] ?? 'No Email'),
//               subtitle: Text("Username: ${user['username']}"),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () => _showEditDialog(user),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => _deleteUser(user['id']),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       backgroundColor: const Color(0xFFF5F5F5),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:registration_app/services/api_service.dart';
import 'package:registration_app/services/database_service.dart'; // Import your DatabaseService

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> apiUserList = [];
  List<Map<String, dynamic>> dbUserList = [];

  @override
  void initState() {
    super.initState();
    fetchUserLists();
  }

  Future<void> fetchUserLists() async {
    try {
      final apiUsers = await ApiService.getUserList();
      final dbUsers = await DatabaseService().getUserList(); // Using existing method

      setState(() {
        apiUserList = apiUsers;
        dbUserList = dbUsers;
      });
    } catch (e) {
      debugPrint("Error fetching user lists: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        backgroundColor: const Color(0xFFFBBB3B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const Text("Users from API", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...apiUserList.map((user) => _buildUserTile(user, isFromApi: true)),

          const SizedBox(height: 20),
          const Text("Users from Database", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...dbUserList.map((user) => _buildUserTile(user, isFromApi: false)),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user, {required bool isFromApi}) {
    final email = user['email'] ?? user['emailId'] ?? 'No Email';
    final username = user['username'] ?? user['userName'] ?? 'N/A';

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
        title: Text(email),
        subtitle: Text("Username: $username"),
        trailing: isFromApi
            ? null
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(user),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteDbUser(user['id']),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(Map<String, dynamic> user) async {
    final TextEditingController emailController =
    TextEditingController(text: user['emailId']);
    final TextEditingController passwordController =
    TextEditingController(text: user['password']);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Local User'),
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
              await DatabaseService().updateUser(
                id: user['id'],
                emailId: emailController.text,
                password: passwordController.text,
              );
              Navigator.pop(context);
              fetchUserLists();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDbUser(int id) async {
    await DatabaseService().deleteUser(id);
    fetchUserLists();
  }
}
