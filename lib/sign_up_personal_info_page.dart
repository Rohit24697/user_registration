import 'package:flutter/material.dart';
import 'package:registration_app/services/database_service.dart';
import 'package:registration_app/services/shared_preferences_service.dart';
import 'package:registration_app/sign_up_account_info_page.dart';
import 'package:registration_app/widget/base_page_layout_widget.dart';

class SignUpPersonalInfoPage extends StatefulWidget {
  const SignUpPersonalInfoPage({super.key});

  @override
  State<SignUpPersonalInfoPage> createState() => _SignUpPersonalInfoPageState();
}

class _SignUpPersonalInfoPageState extends State<SignUpPersonalInfoPage> {
  SharedPreferencesService service = SharedPreferencesService();
  final DatabaseService _databaseService = DatabaseService();

  String firstName = "";
  String lastName = "";
  String userName = "";
  String emailId = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9._%+-]+@(gmail|yahoo)\.com$");

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _saveUserInfo() async {
    await service.savePrefString(
        key: SharedPreferencesService.kEmail,
        value: _emailController.text);

    int id = DateTime.now().millisecondsSinceEpoch;

    await _databaseService.insertUser(
      id: id,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      emailId: _emailController.text,
      password: 'test123',
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpAccountInfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePageLayoutWidget(
      title: "Join Us",
      subTitle: "Create Free Account",
      cardBody: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Personal Info",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "This is create account page, fill personal info to create your free account.",
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Your Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          hintText: "First Name",
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black26, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black26, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Email Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.email_rounded),
                    hintText: "Enter Your Email Address",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email address';
                    }
                    if (!emailValid.hasMatch(value)) {
                      return 'Only @gmail.com or @yahoo.com allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Username",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.check_circle, color: Colors.green),
                    hintText: "john_123",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveUserInfo();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill all fields correctly")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBB3B),
                    ),
                    child: const Text(
                      "Save and Continue",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

