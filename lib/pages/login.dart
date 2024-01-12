import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_rent/pages/Landing/landing.dart';
import 'package:house_rent/pages/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/firebase_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseService firebaseService = FirebaseService();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  Future<void> saveuid(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;

    if (user != null) {
      // Save the UID to SharedPreferences
      await prefs.setString('uid', user.uid);
      print('User UID saved to SharedPreferences: ${user.uid}');
    } else {
      print('User not found or unable to sign in');
    }
  } catch (e) {
    print('Error signing in: $e');
    // Handle authentication errors as needed
  }
}
//  String getCurrentUserID() {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   User? user = auth.currentUser;

//   if (user != null) {
//     String uid = user.uid;
//     return uid;
//   } else {
//     // User is not logged in
//     return ''; // or handle it as needed
//   }
// }

  void saveLoginStatus() async {
   String uid = firebaseService.getCurrentUserId();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    const snackBar = SnackBar(content: Text('Enter Valid Credentials'));
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 253, 252, 252)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    height: 33.0,
                    width: 243.0,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Khooj The Search",
                            style: GoogleFonts.poppins(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF494949)))),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  Text("House Rental System",
                      style: GoogleFonts.poppins(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF379FAA))),
                  SizedBox(
                    height: 41.0,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Hi,",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Color(
                              0xFF000000,
                            ))),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Login Now",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000))),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: 75.0,
                    width: 315.0,
                    child: TextField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        
                        prefixIcon: Icon(Icons.alternate_email_outlined),
                          labelText: "Enter Your EMAIL",
                          hintText: "---@gmail.com",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    height: 75.0,
                    width: 315.0,
                    child: TextField(
                      obscureText: true,
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password_outlined),
                          labelText: "Enter Your Password",
                          hintText: "Your Password",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      firebaseService.loginUser(emailcontroller.text, passwordcontroller.text).then((value) => 
                      value=="success" ? Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LandingPage())):ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar));
                    
                      saveuid(emailcontroller.text, passwordcontroller.text);
                      saveLoginStatus();
                      
                    },
                    child: Container(
                      height: 55.0,
                      width: 315.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xFF98EAF3)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Login",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF004A54)))),
                    ),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  GestureDetector(
                    onTap: (){
Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen()));

                  },
                    child: Container(
                      height: 55.0,
                      width: 315.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color.fromARGB(255, 152, 243, 199)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Registration",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF004A54)))),
                    ),
                  ),
                  
                  
                ],
              ),
            )),
      ),
    );
  }
}