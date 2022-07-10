import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor_final/views/pageselection.dart';
import 'constants.dart';
import 'models/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTutor User',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      home: const MySplashScreen(title: 'My Tutor'),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool remember = false;
  String status = "Loading...";
  late double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => loadPref());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: Image.asset('assests/images/1.png'),
              ),
              const CircularProgressIndicator(),
              Text(status,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const Text("Version 0.1",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        status = "Credentials found, auto log in...";
      });
      _loginUser(email, password);
    } else {
      _loginUser(email, password);
      setState(() {
        status = "Login as guest...";
      });
    }
  }

  _loginUser(email, password) {
    http.post(
        Uri.parse(
            CONSTANTS.server + "/279199/final_mbmytutor/php/custlogin.php"),
        body: {"email": email, "password": password}).then((response) {
      var data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];
        Customer customer = Customer.fromJson(extractdata);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => PageSelection(
                      customer: customer,
                    )));
      } else if (response.statusCode == 200 && data['status'] == 'failed'){
        Customer customer = Customer( 
          id: '0',
          name: 'guest',
          email: 'guest@slumberjer.com',
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => PageSelection(
                      customer: customer,
                    )));
      }
    });
  }
}
