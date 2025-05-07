import 'package:flutter/material.dart';
import 'package:registration_app/services/shared_preferences_service.dart';

import 'home_screen.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferencesService prefService = SharedPreferencesService();

  Future<void> initSharedPref() async {
    await prefService.initSharedPref();
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
    debugPrint("Inside initState");

    Future.delayed(const Duration(seconds: 3), () {
      getLocalData();
      // _navigateToNextPage();
    });
  }

  void getLocalData() {
    bool? isUserLoggedIn = prefService.getPrefBool(
        prefKey: SharedPreferencesService.kIsUserLoggedIn);
    //Below method is used to clear all the data which we have saved in local storage
    // prefs.clear();

    if (isUserLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    debugPrint("Inside dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset("assets/quicknsol.png",width: 200.0,height: 200.0,alignment: Alignment.center,),
              Text(
                "Developed by Rohit Hegade",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      )),
    );
  }
}
