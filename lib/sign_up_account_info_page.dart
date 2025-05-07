
import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:registration_app/services/shared_preferences_service.dart';

import 'login_page.dart';

class SignUpAccountInfoPage extends StatefulWidget {
  const SignUpAccountInfoPage({super.key});

  @override
  State<SignUpAccountInfoPage> createState() => _SignUpAccountInfoPageState();
}

class _SignUpAccountInfoPageState extends State<SignUpAccountInfoPage> {
  final SharedPreferencesService prefService = SharedPreferencesService();

  final _formKey = GlobalKey<FormState>();

  String password = "";
  bool _obscurePassword = true;

  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _securityAnswerController = TextEditingController();

  String? _selectedQuestion;

  final List<String> _securityQuestions = [
    'What was your first pet\'s name?',
    'What city were you born in?',
    'What is your mother\'s maiden name?',
    'What was your first school?'
  ];

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _phoneController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

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

  bool validateUserInput() {
    if (password.isEmpty) return false;
    if (_dayController.text.isEmpty || _monthController.text.isEmpty || _yearController.text.isEmpty) return false;
    if (_phoneController.text.isEmpty || _phoneController.text.length != 10) return false;
    if (_selectedQuestion == null || _securityAnswerController.text.isEmpty) return false;
    return true;
  }

  Future<void> saveData() async {
    await prefService.savePrefString(
        key: SharedPreferencesService.kPassword, value: password);
  }

  void _getAllData() {
    debugPrint("First Name : ${prefService.getPrefString(prefKey: SharedPreferencesService.kFirstName)}");
    debugPrint("Last Name : ${prefService.getPrefString(prefKey: SharedPreferencesService.kLastName)}");
    debugPrint("User Name : ${prefService.getPrefString(prefKey: SharedPreferencesService.kUserName)}");
    debugPrint("Email Id : ${prefService.getPrefString(prefKey: SharedPreferencesService.kEmail)}");
    debugPrint("Password : ${prefService.getPrefString(prefKey: SharedPreferencesService.kPassword)}");
  }

  void showSnackbar() {
    const snackBar = SnackBar(content: Text("Account created successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Secure Account",
                              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "This is secure account page, fill account information to create your free account.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 20),

                            // Birthday
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Birthday", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
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
                                      suffixIcon: const Icon(Icons.calendar_today),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
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
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
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
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                    ),
                                    onTap: () => _selectDate(context),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Password
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Password", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 10),

                            TextField(
                              obscureText: _obscurePassword,
                              onChanged: (value) => password = value,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Phone Number
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Phone Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                CountryCodePicker(
                                  mode: CountryCodePickerMode.dialog,
                                  onChanged: (country) {},
                                  initialSelection: 'IN',
                                  showFlag: true,
                                  showDropDownButton: true,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      hintText: "Enter Phone Number",
                                      suffixIcon: const Icon(Icons.phone),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Security Question
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Security Question", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 10),

                            DropdownButtonFormField<String>(
                              value: _selectedQuestion,
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              items: _securityQuestions
                                  .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedQuestion = value),
                              hint: const Text('Select a security question'),
                            ),

                            const SizedBox(height: 10),

                            TextField(
                              controller: _securityAnswerController,
                              decoration: InputDecoration(
                                hintText: "Your Answer...",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0XFFFBBB3B),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                ),
                                onPressed: () {
                                  if (validateUserInput()) {
                                    saveData();
                                    _getAllData();
                                    showSnackbar();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please fill all required fields")),
                                    );
                                  }
                                },
                                child: const Text("Create Account",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextButton(
                              onPressed: () {
                                Navigator.popUntil(context, (route) => route.isFirst);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}