import 'package:flutter/material.dart';
import 'package:registration_app/services/shared_preferences_service.dart';
import 'package:registration_app/sign_up_personal_info_page.dart';
import 'package:registration_app/widget/base_page_layout_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'forget_password_page.dart';
import 'home_screen.dart';
import 'widget/common_button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferencesService _preferencesService = SharedPreferencesService();

  String emailId = "";
  String password = "";

  @override
  void initState() {
    super.initState();

    _getAllData();

  }
  bool _isObscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9,!#$%&'*+-/=?^_`{|}~]+@(gmail|yahoo)\.com$");
  final RegExp passwordValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9,!#$%&'*+-/=?^_`{|}~]");

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your Email ";
    } else if (!value.contains("@")) {
      return "Email address must contain @";
    } else if (!value.contains(".com")) {
      return "Email address must contain .com";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BasePageLayoutWidget(
      title: "Hello",
      subTitle: "Welcome Back !",
      cardBody: Card(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                        "Login Account",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "This is login page, Please insert correct Email ID and Password here",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Text(
                      textAlign: TextAlign.start,
                      "Email Address",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    onChanged: (value){
                      emailId = value;
                    },
                    controller: _emailController,
                    // validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      hintText: "Enter Your Email Address",
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black45, width: 2.0),
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!passwordValid.hasMatch(value)) {
                        return 'Please enter correct password';
                      }
                      return null;
                    },

                    onChanged: (value){
                      password = value;
                    },
                    obscureText: _isObscured,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                        onPressed: (){
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black45, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                      ),
                      Text(
                        "Save Password",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              ///When we want to return only one function then only we use ( => ) Arrow function
                              builder: (context) => const ForgetPasswordPage(),
                            ),
                          );
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  CommonButtonWidget(
                    formKey: _formKey,
                    buttonLabel: "Login Account",
                    onClick: () {

                      if(validateUserAccount()){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            ///When we want to return only one function then only we use ( => ) Arrow function
                            builder: (context) =>
                            const HomeScreen(),
                          ),
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "EmailId or Password is wrong.")));
                      }


                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            ///When we want to return only one function then only we use ( => ) Arrow function
                            builder: (context) =>
                            const SignUpPersonalInfoPage(),
                          ),
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          "Create New Account",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getAllData() {
    debugPrint("First Name : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kFirstName)}");
    debugPrint("Last Name : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kLastName)}");
    debugPrint("User Name : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kUserName)}");
    debugPrint("Email Id : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kEmail)}");
    debugPrint("Password : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kPassword)}");
  }

  void showSnackbar() {
    var snackBar = const SnackBar(content: Text("Account login successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool validateUserAccount() {
    if(emailId.isEmpty){
      return false;
    }
    if(password.isEmpty){
      return false;
    }
    String? dbEmailId = _preferencesService.getPrefString(prefKey: SharedPreferencesService.kEmail);
    String? dbPassword = _preferencesService.getPrefString(prefKey: SharedPreferencesService.kPassword);

    debugPrint("User Input Email Id : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kEmail)}");
    debugPrint("User Input Password : ${_preferencesService.getPrefString(prefKey: SharedPreferencesService.kPassword)}");
    if(emailId == dbEmailId && password == dbPassword){
      _preferencesService.savePrefBool(prefKey: SharedPreferencesService.kIsUserLoggedIn, value: true);
      return true;
    }else{
      _preferencesService.savePrefBool(prefKey: SharedPreferencesService.kIsUserLoggedIn, value: false);
      return false;
    }
  }
}
