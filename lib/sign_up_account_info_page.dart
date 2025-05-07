import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:registration_app/services/shared_preferences_service.dart';

import 'login_page.dart';
import 'widget/common_button_widget.dart';

class SignUpAccountInfoPage extends StatefulWidget {
  const SignUpAccountInfoPage({super.key});

  @override
  State<SignUpAccountInfoPage> createState() => _SignUpAccountInfoPageState();
}

class _SignUpAccountInfoPageState extends State<SignUpAccountInfoPage> {
  SharedPreferencesService prefService = SharedPreferencesService();

  String password = "";

  @override
  void initState() {
    super.initState();

  }

  Future<void> saveData() async {
    //SAVE PASSWORD
    prefService.savePrefString(
        key: SharedPreferencesService.kPassword, value: password);
  }

  bool validateUserInput() {
    if (password.isEmpty) {
      return false;
    }
    return true;
  }

  void _getAllData() {
    debugPrint(
        "First Name : ${prefService.getPrefString(prefKey: SharedPreferencesService.kFirstName)}");
    debugPrint(
        "Last Name : ${prefService.getPrefString(prefKey: SharedPreferencesService.kLastName)}");
    debugPrint(
        "User Name : ${prefService.getPrefString(prefKey: SharedPreferencesService.kUserName)}");
    debugPrint(
        "Email Id : ${prefService.getPrefString(prefKey: SharedPreferencesService.kEmail)}");
    debugPrint(
        "Password : ${prefService.getPrefString(prefKey: SharedPreferencesService.kPassword)}");
  }

  // Add these controllers for date fields
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Add the date picker method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dayController.text = picked.day.toString().padLeft(2, '0');
        _monthController.text = picked.month.toString().padLeft(2, '0');
        _yearController.text = picked.year.toString();
      });
    }
  }

  // Add dispose method to clean up controllers
  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void showSnackbar() {
    var snackBar =
    const SnackBar(content: Text("Account created successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Security question related declarations
  String? _selectedQuestion;
  final List<String> _securityQuestions = [
    'What was your first pet\'s name?',
    'What city were you born in?',
    'What is your mother\'s maiden name?',
    'What was your first school?'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFFBBB3B),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          // alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(80),
                ),
                color: Color(0XFFFBBB3B),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Secure Account",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            "This is secure account page, fill account information to crate your free account.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Birthday Section
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Birthday",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _dayController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Day",
                                    suffixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFF2F2F2),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _monthController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Month",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFF2F2F2),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _yearController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Year",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFF2F2F2),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          // Password Section
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            onChanged: (value) {
                              debugPrint("$value");
                              password = value;
                            },
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              suffixIcon: Icon(Icons.remove_red_eye),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Phone Number Section
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              CountryCodePicker(
                                mode: CountryCodePickerMode.dialog,
                                onChanged: (country) {
                                  print(
                                      'Country code selected: ${country.code}');
                                },
                                initialSelection: 'IN',
                                showFlag: true,
                                showDropDownButton: true,
                              ),
                              Expanded(
                                child: TextField(
                                  obscureText: false,
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter Phone Number",
                                    suffixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: BorderSide(
                                        color: Color(0xFFF2F2F2),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Security Question Section
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Security Question",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            value: _selectedQuestion,
                            items: _securityQuestions
                                .map((question) => DropdownMenuItem(
                              value: question,
                              child: Text(question),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedQuestion = value;
                              });
                            },
                            hint: const Text('Select a security question'),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            decoration: InputDecoration(
                              hintText: "Your Answer...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          //Create Account Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0XFFFBBB3B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                if (validateUserInput()) {
                                  saveData();
                                  _getAllData();
                                }
                                showSnackbar();
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Back to Login
                          TextButton(
                            onPressed: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
